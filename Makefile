.PHONY: export clean all

export:
	structurizr-cli export -workspace workspace.dsl -format json

clean:
	find . -name "*.dot" -delete
	find . -name "*.dot.svg" -delete

build: export clean

install:
	brew install graphviz structurizr-cli http-server

serve:
	http-server

