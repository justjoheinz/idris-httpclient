# the compiler: gcc for C program
CC = gcc

# debug flags
#DEBUG = -D_HTTPCLIENT_DEBUG=1

# compiler flags:
CFLAGS  = -Wall -I/usr/local/opt/curl/include $(DEBUG)

# linker flags:
LDFLAGS = -L/usr/local/opt/curl/lib

# define any libraries to link:
LIBS = -lcurl

SRCS = http.c memstream.c

all: $(SRCS)
	$(CC) $(CFLAGS) -c $(SRCS) $(LFLAGS) $(LIBS)

clean:
	$(RM) *.o *~  a.out
