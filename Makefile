# $Id: Makefile,v 1.36 2009/09/21 17:02:44 mascarenhas Exp $

PLAT ?= linux
PLATS = linux macosx
MACOSX_TARGET ?= 10.14


T= lfs

CONFIG= ./config

include $(CONFIG)

SRCS= src/$T.c
OBJS= src/$T.o

.PHONY : default

default :
	$(MAKE) $(PLAT)

linux: PLAT = linux
macosx: PLAT = macosx

linux: LIB_OPTION= -shared 
macosx: LIB_OPTION= -bundle -undefined dynamic_lookup


linux macosx lib: src/lfs.so

linux macosx src/lfs.so: $(OBJS)
	MACOSX_DEPLOYMENT_TARGET=$(MACOSX_TARGET); export MACOSX_DEPLOYMENT_TARGET; $(CC) $(LIB_OPTION) -o src/lfs.so $(OBJS)

test: lib
	LUA_CPATH=./src/?.so lua tests/test.lua

install:
	mkdir -p $(DESTDIR)$(LUA_LIBDIR)
	cp src/lfs.so $(DESTDIR)$(LUA_LIBDIR)

clean:
	rm -f src/lfs.so $(OBJS)
