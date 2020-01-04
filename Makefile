# Makefile for madbomber

# by Bill Kendrick
# bill@newbreedsoftware.com
# http://www.newbreedsoftware.com/madbomber/

# October 25, 1999 - April 14, 2002


# User-definable stuff:

BIN_PREFIX=/usr/local/bin/
DATA_PREFIX=/usr/share/madbomber/


# Defaults for Linux:

TARGET=madbomber
TARGET_DEF=LINUX
SDL_CFLAGS := $(shell sdl-config --cflags)
SDL_LDFLAGS := $(shell sdl-config --libs)


# Sound-related definitions:

MIXER=-lSDL_mixer
IMAGE=-lSDL_image
NOSOUNDFLAG=__SOUND


# Stuff we pass to the compiler:

CFLAGS=-Wall $(SDL_CFLAGS) \
	-DDATA_PREFIX=\"$(DATA_PREFIX)\" -D$(NOSOUNDFLAG) -D$(TARGET_DEF)
SDL_LIB=$(MIXER) $(IMAGE) $(SDL_LDFLAGS)


# Make commands:

all:	$(TARGET)

install:
	mkdir -p $(DATA_PREFIX)
	cp -r data/* $(DATA_PREFIX)
	chown -R root.root $(DATA_PREFIX)
	chmod -R a+rX,g-w,o-w $(DATA_PREFIX)
	cp madbomber $(BIN_PREFIX)
	chown root.root $(BIN_PREFIX)/madbomber
	chmod a+rx,g-w,o-w $(BIN_PREFIX)/madbomber


nosound:
	make $(TARGET) MIXER= NOSOUNDFLAG=NOSOUND

win32:
	make TARGET_DEF=WIN32 TARGET=madbomber.exe \
		DATA_PREFIX=data/ IMAGE="-lSDL_image -lpng -lz"
	cp /usr/local/cross-tools/i386-mingw32/lib/SDL*.dll .
	chmod 644 SDL*.dll

embedded:
	make TARGET_DEF=EMBEDDED MIXER= \
		DATA_PREFIX=/opt/QtPalmtop/share/madbomber/ \
		SDL_LIB="/usr/local/arm/lib/libSDL_mixer.a /usr/local/arm/lib/libSDL.a -L/opt/Qtopia/sharp/lib -lpthread -lqpe -lqte" \
		CC=/usr/local/arm/bin/arm-linux-gcc
	/usr/local/arm/bin/arm-linux-strip ${TARGET}

emtest:
	make $(TARGET) TARGET_DEF=EMBEDDED DATA_PREFIX=e/

clean:
	-rm madbomber madbomber.exe
	-rm *.o
	-rm SDL*.dll
	-rm madbomber*.ipk


# Main executable:

$(TARGET):	madbomber.o
	$(CC) $(CFLAGS) madbomber.o -o $(TARGET) $(SDL_LIB) -lm


# Main object:

madbomber.o:	madbomber.c
