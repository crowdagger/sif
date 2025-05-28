GUILE=guile -L . -L vm

SRC = \
  hoot/sif/ui.scm \
  sif/scene.scm 
main.wasm: main-web.scm $(SRC)
	guild compile-wasm -L . -L hoot --bundle -o main.wasm main-web.scm

run:
	$(GUILE) main.scm

test:
	$(GUILE) tests/tests.scm

serve: main.wasm
	$(GUILE) -c '((@ (hoot web-server) serve))'


clean:
	rm *.wasm
