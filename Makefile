# Makefile for kubectl

prog_name      = kubetail
conf_file_name = kube-multitail.conf

bindir = $(HOME)/bin
etcdir = $(HOME)/etc

# uncomment if you want to install for multiple users
#bindir = /usr/local/bin
#etcdir = /usr/local/etc

program  = $(bindir)/$(prog_name)
conffile = $(etcdir)/$(conf_file_name)

help:
	@echo "You can use 'make install' to install $(prog_name) and $(conf_file_name)"

install: $(program) $(conffile)

$(bindir) $(etcdir):
	mkdir -p $@

$(program): kubetail Makefile
	install -b kubetail $@

$(conffile): $(conf_file_name) Makefile
	install -b -m 0644 $(conf_file_name) $@
