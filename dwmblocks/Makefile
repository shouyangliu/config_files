.POSIX:

CC = cc
CFLAGS = -Wall -Wextra -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L -O2

all: dwmblocks

dwmblocks: dwmblocks.c blocks/battery.o blocks/memory.o blocks/cpu.o blocks/wifi.o blocks/ip.o blocks/datetime.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: blocks/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o blocks/*.o dwmblocks

.PHONY: all clean