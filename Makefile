COFFEE := $(wildcard *.coffee)
JS := $(COFFEE:coffee=js)

all: lint compile

lint:
	coffeelint $(COFFEE)

compile: $(JS)

clean:
	rm $(JS)

%.js: %.coffee
	coffee -m -c $<

.PHONY : all lint compile clean
