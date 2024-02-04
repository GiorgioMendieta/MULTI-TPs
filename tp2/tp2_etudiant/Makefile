#!/bin/sh

# Set env variables 
GIET_SYS_PATH = /users/enseig/alain/giet_2011/sys
GIET_APP_PATH = /users/enseig/alain/giet_2011/app
# Tools
AS  = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-as
GCC = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-gcc
LD  = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-ld
DU  = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-objdump

# Working directory
WORKDIR = ./work
# Source files directory
SOFTDIR = ./soft
# Compiler flags
CCFLAGS = -Wall -mno-gpopt -ffreestanding -mips32
CPPFLAGS = -I$(GIET_SYS_PATH) -I$(SOFTDIR)
ASMFLAGS = -g -mips32

.PHONY: clean giet app sys

all : clean giet sys app

giet : 
# Create temporal work directory
	@mkdir -p $(WORKDIR)

# Compile ASM files
	@echo "INFO: Compiling ASM files"
	$(AS) $(ASMFLAGS) -o $(WORKDIR)/reset.o $(SOFTDIR)/reset.s
	$(AS) $(ASMFLAGS) -o $(WORKDIR)/giet.o $(GIET_SYS_PATH)/giet.s
	
# Compile C files
	@echo "INFO: Compiling C files"
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/drivers.o     $(GIET_SYS_PATH)/drivers.c
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/common.o      $(GIET_SYS_PATH)/common.c
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/ctx_handler.o $(GIET_SYS_PATH)/ctx_handler.c
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/irq_handler.o $(GIET_SYS_PATH)/irq_handler.c
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/sys_handler.o $(GIET_SYS_PATH)/sys_handler.c
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/exc_handler.o $(GIET_SYS_PATH)/exc_handler.c

app :
	@echo "INFO: Building app.bin"

# Compile stdio.c et main.c in ./soft/
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/main.o main.c
	$(GCC) $(CCFLAGS) $(CPPFLAGS) -c -o $(WORKDIR)/stdio.o $(GIET_APP_PATH)/stdio.c

# Generate app.bin
	$(LD) -o $(WORKDIR)/app/app.bin -T $(SOFTDIR)/app.ld $(WORKDIR)/app/*.o

# Dissassemble sys.bin and save to text file
	$(DU) -D $(WORKDIR)/app/app.bin > $(WORKDIR)/app.bin.txt
	@echo "INFO: Saved dissassembled app.bin file to ./work/app.bin.txt"

sys :
	@echo "INFO: Building sys.bin"
# Generate sys.bin
	$(LD) -o $(WORKDIR)/sys.bin -T $(SOFTDIR)/sys.ld $(WORKDIR)/*.o
# Dissassemble sys.bin and save to text file
	$(DU) -D $(WORKDIR)/sys.bin > $(WORKDIR)/sys.bin.txt
	@echo "INFO: Saved dissassembled sys.bin file to ./work/sys.bin.txt"

clean :
# Remove the work directory
	@rm -rf $(WORKDIR)