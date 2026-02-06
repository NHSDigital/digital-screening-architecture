.PHONY: export clean build install serve watch watch_and_serve

export:
	structurizr-cli export -workspace workspace.dsl -format json

clean:
	find . -name "*.dot" -delete
	find . -name "*.dot.svg" -delete

build: export clean

install:
	brew install graphviz structurizr-cli http-server entr

serve:
	http-server

watch:
	echo workspace.dsl | entr make build

watch_and_serve:
	echo workspace.dsl | entr make build & http-server

