.PHONY: all test clean distclean dist jemplate data

all: test

dist:
	rm -rf inc META.y*ml
	perl Makefile.PL
	$(MAKE) -f Makefile dist

install distclean tardist: Makefile
	$(MAKE) -f $< $@

test: Makefile
	TEST_RELEASE=1 $(MAKE) -f $< $@

Makefile: Makefile.PL
	perl $<

clean: distclean

reset: clean
	perl Makefile.PL
	$(MAKE) test

jemplate:
	jemplate --runtime=jquery --compile jt/* > assets/root/static/jemplate.js

data:
	for datum in apple banana cherry grape; do \
		mkdir -p assets/data/$$datum; \
		convert source/$$datum.jpg assets/data/$$datum/image.jpg; \
		convert source/$$datum.jpg -resize '128x128>' assets/data/$$datum/thumbnail.jpg; \
	done
