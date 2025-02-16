GUILE=guile -L .

example:
	$(GUILE) example.scm

test:
	$(GUILE) tests/tests.scm
