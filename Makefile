CFLAGS += -Wall -fexceptions -pthread -lm -O3 -fpermissive -fno-strict-aliasing
TARGET = fm_transmitter

CPP=$(CCPREFIX)g++

all: main.o error_reporter.o wave_reader.o stdin_reader.o transmitter.o
	$(CPP) $(CFLAGS) -o $(TARGET) main.o error_reporter.o wave_reader.o stdin_reader.o transmitter.o

wave_reader.o: wave_reader.cpp wave_reader.h
	$(CPP) $(CFLAGS) -c wave_reader.cpp

stdin_reader.o: stdin_reader.cpp stdin_reader.h
	$(CPP) $(CFLAGS) -c stdin_reader.cpp

error_reporter.o: error_reporter.cpp error_reporter.h
	$(CPP) $(CFLAGS) -c error_reporter.cpp

transmitter.o: transmitter.cpp transmitter.h
	$(CPP) $(CFLAGS) -c transmitter.cpp

main.o: main.cpp
	$(CPP) $(CFLAGS) -c main.cpp

install:
	@mkdir -p $(DESTDIR)/usr/bin
	@cp fm_transmitter $(DESTDIR)/usr/bin

prep-deb:
	make
	@mkdir -p deb-build/fm-transmitter
	@cp -p -r support/debian/. deb-build/fm-transmitter/debian
	@mkdir -p deb-build/fm-transmitter/debian/fm-transmitter
	@make DESTDIR=deb-build/fm-transmitter/debian/fm-transmitter install

deb-pkg:
	make BUILDMODE=$(BUILDMODE) prep-deb
	@cd deb-build/fm-transmitter/debian && debuild -b

deb-src:
	make BUILDMODE=$(BUILDMODE) prep-deb
	@cd deb-build/fm-transmitter/debian && debuild -S

clean:
	rm -rf *.o deb-build
