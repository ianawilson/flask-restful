.PHONY: test install docs analysis

install: venv
	. venv/bin/activate; python setup.py develop

venv:
	virtualenv venv

docs-dependencies: install
	. venv/bin/activate; pip install -e '.[docs]' --use-mirrors

docs:
	. venv/bin/activate; cd docs && make html

# Pycrypto is required to run the unit tests
test-dependencies: install
	. venv/bin/activate; pip install -e '.[paging]' --use-mirrors

test:
	. venv/bin/activate; python setup.py nosetests

analysis:
	. venv/bin/activate; flake8 --select=E112,E113,E901,E902,W601,W602,W603,W604,W402,W403,W404,W802,W803,W804,W805,W806 --ignore=W801 flask_restful tests

release: test
	$(shell python scripts/release.py $(shell python setup.py -V))

authors:
	echo "Authors\n=======\n\nA huge thanks to all of our contributors:\n\n" > AUTHORS.md
	git log --raw | grep "^Author: " | cut -d ' ' -f2- | cut -d '<' -f1 | sed 's/^/- /' | sort | uniq >> AUTHORS.md
