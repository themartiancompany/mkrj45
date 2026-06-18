# SPDX-License-Identifier: AGPL-3.0

#    -----------------------------------------------------
#    Copyright © 2024, 2025, 2026  Pellegrino Prevete
#
#    All rights reserved
#    -----------------------------------------------------
#
#    This program is free software: you can redistribute
#    it and/or modify it under the terms of the
#    GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it
#    will be useful, but WITHOUT ANY WARRANTY;
#    without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Affero General Public License for
#    more details.
#
#    You should have received a copy of the
#    GNU Affero General Public License
#    along with this program.
#    If not, see <https://www.gnu.org/licenses/>.

_VERSION ?= insert.version.here
_PROJECT=mkrj45
PREFIX ?= /usr/local
BIN_DIR=$(DESTDIR)$(PREFIX)/bin
DOC_DIR=$(DESTDIR)$(PREFIX)/share/doc/$(_PROJECT)
DATA_DIR=$(DESTDIR)$(PREFIX)/share/$(_PROJECT)
MAN_DIR?=$(DESTDIR)$(PREFIX)/share/man

MAN_FILES=\
  $(wildcard *.1.rst)

DOCS_FILES=\
  $(wildcard *.md)

_INSTALL_FILE=\
  install \
    -vDm644
_INSTALL_EXE=\
  install \
    -vDm755
_INSTALL_DIR=\
  install \
    -vdm755

all:

build-man:

	mkdir \
	  -p \
	  "build"
	cp \
	  "variables.rst" \
	  "build"
	sed \
	  "s/insert.version.here/$(_VERSION)/g" \
	  -i \
	  "build/variables.rst"; \
	for _file in $(MAN_FILES); do \
	  _program="$( \
	    basename \
	      "$${_file%%*.1.rst}")"; \
	  rst2man \
	    "$${_file}" \
	    "build/$${_program}.1"; \
	done
	
install: install-doc install-man

install-scripts:
	$(INSTALL_EXE) \
	  "$(_PROJECT)/$(_PROJECT)" \
	  "$(BIN_DIR)/$(_PROJECT)"

install-doc:

	# $(INSTALL_FILE) \
	#   $(DOC_FILES) \
	#   -t \
	#   $(DOC_DIR)
	$(INSTALL_FILE) \
	  "README.md" \
	  -t \
	  $(DOC_DIR)/README.man.md

install-man:

	if [[ ! -d "build" ]]; then \
	  make \
	    build-man; \
	fi
	cd \
	  "build"; \
	for _file in "./"*; do \
	  $(_INSTALL_FILE) \
	    "$${_file}" \
	    "$(MAN_DIR)/man1/$${_file}"; \
	done

.PHONY: install install-doc install-man
