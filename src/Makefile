# the compiler: gcc for C program
CC = gcc

# compiler flags:
CFLAGS  = -Wall -I/usr/local/opt/curl/include

# linker flags:
LDFLAGS =	-L/usr/local/opt/curl/lib

# define any libraries to link:
LIBS = -lcurl

SRCS = http.c memstream.c

OBJS = $(SRCS:.c=.o)

# the build target executable:
MAIN = http

$(MAIN): $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) $(OBJS) $(LFLAGS) $(LIBS)

all: $(MAIN)

clean:
	$(RM) *.o *~  a.out
