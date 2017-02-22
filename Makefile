# Makefile for kubectl

prog_name      = kubetail
conf_file_name = kube-multitail.conf
man_source     = kubetail.man
man_sec        = 1
man_file_name  = kubetail.$(man_sec)

DEST_DIR ?= $(HOME)

bindir = $(DEST_DIR)/bin
etcdir = $(DEST_DIR)/etc
mandir = $(DEST_DIR)/man/man$(man_sec)

program  = $(bindir)/$(prog_name)
conffile = $(etcdir)/$(conf_file_name)
manfile  = $(mandir)/$(man_file_name)

help:
	@echo "The Makefile supports these targets:"
	@echo "  make install-home  # to install into $(HOME)/{bin,etc,man}"
	@echo "  make install-usr   # to install into /usr/local/{bin,etc,man}"
	@echo ''
	@echo "Use -n to see the effects without doing it"

.PHONY: install-files install-home install-usr clean

install-files:: $(program) $(conffile) $(manfile)

install-home::
	$(MAKE) DEST_DIR=$(HOME) install-files

install-usr::
	$(MAKE) DEST_DIR=/usr/local install-files

clean::
	rm -f $(man_file_name)

$(bindir) $(etcdir) $(mandir):
	mkdir -p $@

$(program): $(bindir) kubetail Makefile
	install -b kubetail $@

$(conffile): $(etcdir) $(conf_file_name) Makefile
	install -b -m 0644 $(conf_file_name) $@

$(manfile): $(mandir) $(man_source) VERSION Makefile
	sed -Ee "s/@@VERSION@@/`cat VERSION`/g" <$(man_source) >$(man_file_name)
	install -m 0644 $(man_file_name) $@
