
all:
	$(MAKE) -C examples OPT=$(OPT)

argless:
	$(MAKE) -C examples argless OPT=$(OPT)

clean:
	delp .
	delp src
	delp src/sys
	delp examples/console/units
	$(MAKE) -C examples clean
	rm -f *~
