# Makefile for kubectl

prog = kubetail

bindir = /usr/local/bin

# uncomment if you want to install only into your home bin dir
#bindir = $(HOME)/bin

help:
	@echo "You can use 'make install' to install kubetail into $(bindir)/$(prog)"

install: $(bindir)/$(prog)

$(bindir):
	mkdir -p $@

$(bindir)/$(prog): kubetail Makefile
	install -b kubetail $@
