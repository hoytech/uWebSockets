UNAME := $(shell uname)
W        = -Wall
OPT      = -O2
STD      = -std=c++17
INCS     = -Isrc/
ifeq ($(UNAME), Darwin)
	LDFLAGS  = -luv -lssl -lz -lcrypto
endif
CXXFLAGS = $(STD) $(OPTS) $(W) -fPIC $(XCXXFLAGS) $(INCS)
INCS     = -Isrc/

SRCS = src/Extensions.cpp src/Group.cpp src/Networking.cpp src/Hub.cpp src/Node.cpp src/WebSocket.cpp src/HTTPSocket.cpp src/Socket.cpp src/Epoll.cpp src/Room.cpp

OBJS := $(SRCS:.cpp=.o)


.PHONY: clean all install


all: libuWS.a libuWS.so

clean:
	rm -f src/*.o libuWS.a libuWS.so

install:
	$(eval PREFIX ?= /usr/local)
	cp libuWS.a libuWS.so $(PREFIX)/lib/
	mkdir -p $(PREFIX)/include/uWS
	cp src/*.h $(PREFIX)/include/uWS/

%.o : %.cpp %.d Makefile
	$(CXX) $(CXXFLAGS) $(INCS) -c $< -o $@

libuWS.a: $(OBJS)
	$(AR) rs $@ $(OBJS)

libuWS.so: $(OBJS)
	$(CXX) $(LDFLAGS) -shared -o $@ $(OBJS)
