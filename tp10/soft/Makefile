LD= /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-ld
CC= /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-gcc
AS= /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-as
DU= /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-objdump

SYS_OBJS=  reset_4procs.o \
	       giet.o \
	       drivers.o \
	       common.o \
           ctx_handler.o \
           sys_handler.o \
           irq_handler.o \
           exc_handler.o 

APP_OBJS=  stdio.o \
	       main_pgcd.o \
           main_display.o \
           main_fifo.o

GIET_SYS_PATH= /users/enseig/alain/giet_2011/sys
GIET_APP_PATH= /users/enseig/alain/giet_2011/app

CFLAGS= -Wall -mno-gpopt -ffreestanding -mips32 

## system & application compilation

all: sys.bin app.bin

## system compilation

sys.bin: $(SYS_OBJS) sys.ld seg.ld
	$(LD) -o $@ -T sys.ld $(SYS_OBJS)
	$(DU) -D $@ > ./Disassembly/$@.txt

giet.o: $(GIET_SYS_PATH)/giet.s
	$(AS) -g -mips32 -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

reset_mono.o: reset_mono.s
	$(AS) -g -mips32 -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

reset_2procs.o: reset_2procs.s
	$(AS) -g -mips32 -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

reset_4procs.o: reset_4procs.s
	$(AS) -g -mips32 -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

drivers.o: $(GIET_SYS_PATH)/drivers.c $(GIET_SYS_PATH)/drivers.h config.h
	$(CC) $(CFLAGS) -I$(GIET_SYS_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

common.o: $(GIET_SYS_PATH)/common.c $(GIET_SYS_PATH)/common.h config.h
	$(CC) $(CFLAGS) -I$(GIET_SYS_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

ctx_handler.o: $(GIET_SYS_PATH)/ctx_handler.c $(GIET_SYS_PATH)/ctx_handler.h config.h
	$(CC) $(CFLAGS) -I$(GIET_SYS_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

sys_handler.o: $(GIET_SYS_PATH)/sys_handler.c $(GIET_SYS_PATH)/sys_handler.h config.h
	$(CC) $(CFLAGS) -I$(GIET_SYS_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

irq_handler.o: $(GIET_SYS_PATH)/irq_handler.c $(GIET_SYS_PATH)/irq_handler.h config.h
	$(CC) $(CFLAGS) -I$(GIET_SYS_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

exc_handler.o: $(GIET_SYS_PATH)/exc_handler.c $(GIET_SYS_PATH)/exc_handler.h config.h
	$(CC) $(CFLAGS) -I$(GIET_SYS_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

## application compilation  

app.bin: $(APP_OBJS) app.ld seg.ld
	$(LD) -o $@ -T app.ld $(APP_OBJS)
	$(DU) -D $@ > ./Disassembly/$@.txt

stdio.o: $(GIET_APP_PATH)/stdio.c $(GIET_APP_PATH)/stdio.h
	$(CC) $(CFLAGS) -I$(GIET_APP_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

main_pgcd.o: main_pgcd.c 
	$(CC) $(CFLAGS) -I$(GIET_APP_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

main_display.o: main_display.c 
	$(CC) $(CFLAGS) -I$(GIET_APP_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

main_fifo.o: main_fifo.c 
	$(CC) $(CFLAGS) -I$(GIET_APP_PATH) -I. -c -o $@ $<
	$(DU) -D $@ > ./Disassembly/$@.txt

clean:
	rm -f *.o *.bin ./Disassembly/*.txt core *~
