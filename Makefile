COFFEE:= $(wildcard *.coffee)

all: lint compile

lint: $(COFFEE)
	coffeelint $(COFFEE)

compile: $(COFFEE)
	coffee -c $(COFFEE)

