CC = gcc
CFLAGS = -Wall -Werror
TARGET = writer

ifdef CROSS_COMPILE
CC = $(CROSS_COMPILE)gcc
endif

all: $(TARGET)

$(TARGET): writer.c
	$(CC) $(CFLAGS) -o $(TARGET) writer.c

clean:
	rm -f $(TARGET) *.o
