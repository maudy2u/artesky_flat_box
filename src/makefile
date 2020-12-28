# https://www.techbeamers.com/makefile-tutorial-create-client-server-program/
#make file overview :--
#you can add a little description here.

#variable declaration :-
# this is the variable which is used in the target.
cc=gcc
cpp=g++
MAKE=make
RM =rm

UNAME_M := $(shell uname -m)
UNAME_S := $(shell uname -s)

$(info On [${UNAME_S}])
$(info Compiling for [${UNAME_M}])

#       $(cpp)  -I./artesky-projects-devel/libartesky_SDK/1.0.0/include ./artesky_srv.c /lib/libartesky_arm64.so -o artesky_srv

# Find out which LIB to use
ifeq ($(UNAME_M), aarch64)
$(info Found: aarch64)
ARTESKY_LIB := ../lib/libartesky_arm64.so
endif

ifeq ($(UNAME_M), armv7l)
$(info Found: armv7l)
ARTESKY_LIB := ../lib/libartesky_arm32.so ./lib/libboost_system.so.1
endif

ifeq  ($(UNAME_M), x86_64)
ifeq ($(UNAME_S), Darwin)
$(info Found: Darwin/macOS)
ARTESKY_LIB := ../lib/libartesky_arm64.so
endif

ifeq ($(UNAME_S), Linux)
$(info Found: Linux)
ARTESKY_LIB := ../lib/libartesky_arm64.so
endif
endif

ifndef ARTESKY_LIB
$(info Nothing found.. At ALL)
endif

#targets .
all: client server
	#$(cpp) -o artesky_cmd artesky_cmd.c
	#$(cpp) -o artesky_srv artesky_srv.c
	#gnome-terminal -t server --working-directory=/home/parallels/src/tmp -e "./server"
	sleep 10s
	$(MAKE) client_target


#another target for client
server:
#-g -I./artesky-projects-devel/libartesky_SDK/1.0.0/include ./artesky_srv.c ./lib/libartesky_arm32.so ./lib/libboost_system.so.1 -o artesky_srv
	$(cpp) -g -I../libartesky_SDK/1.0.0/include ./artesky_srv.c $(ARTESKY_LIB) -o artesky_srv


client:
	$(cpp) -g -o artesky_cmd artesky_cmd.c

#another target for client
client_target:
	./artesky_cmd


clean:
	$(RM) artesky_srv
	$(RM) artesky_cmd

# ./lib/libartesky_arm32.so ./lib/libicui18n.so.63 ./lib/libQt5Gui.so.5 ./lib/libxcb-icccm.so.4 ./lib/libxcb-xinerama.so.0 ./lib/libboost_system.so.1 ./lib/libicuuc.so.63 ./lib/libQt5SerialPort.so.5 ./lib/libxcb-image.so.0 ./lib/libxcb-xkb.so.1 ./lib/libdouble-conversion.so.1 ./lib/libQt5Core.so.5 ./lib/libQt5Widgets.so.5 ./lib/libxcb-keysyms.so.1 ./lib/libxkbcommon-x11.so.0 ./lib/libicudata.so.63 ./lib/libQt5DBus.so.5 ./lib/libQt5XcbQpa.so.5 ./lib/libxcb-render-util.so.0
