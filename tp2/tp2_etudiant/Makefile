# Set env variables 

GIET_SYS_PATH = /users/enseig/alain/giet_2011/sys
GIET_APP_PATH = /users/enseig/alain/giet_2011/app
AS = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-as
CC = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-gcc
LD = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-ld
DU = /opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-objdump

# Working directory
WORKDIR = work
# Source files directory
SOFTDIR = soft

CCFLAGS = -Wall -mno-gpopt -ffreestanding -mips32 -I$(GIET_SYS_PATH) -I.

.PHONY: clean make app sys

all : clean make app sys

make : 
# Create temporal work directory
	@mkdir -p $(WORKDIR)

# Compile ASM files
	@echo "Compiling ASM files"
	$(AS) -g -mips32 -o $(WORKDIR)/reset.o $(SOFTDIR)/reset.s
	$(AS) -g -mips32 -o $(WORKDIR)/giet.o $(GIET_SYS_PATH)/giet.s
	
# Compile C files
	@echo "Compiling C files"
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/drivers.o $(GIET_SYS_PATH)/drivers.c
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/common.o $(GIET_SYS_PATH)/common.c
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/ctx_handler.o $(GIET_SYS_PATH)/ctx_handler.c
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/irq_handler.o $(GIET_SYS_PATH)/irq_handler.c
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/sys_handler.o $(GIET_SYS_PATH)/sys_handler.c
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/exc_handler.o $(GIET_SYS_PATH)/exc_handler.c

app : make
# Create temporal sub directory
	@mkdir -p $(WORKDIR)/app

# Compile stdio.c et main.c in ./soft
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/app/main.o $(SOFTDIR)/main.c
	$(CC) $(CCFLAGS) -c -o $(WORKDIR)/app/stdio.o $(GIET_APP_PATH)/stdio.c

# Generate app.bin
	$(LD) -o $(WORKDIR)/app/app.bin -T $(SOFTDIR)/app.ld $(WORKDIR)/app/*.o

# Dissassemble sys.bin and save to text file
	@echo "Saved dissassembled app.bin file to /app.bin.txt"
	$(DU) -D $(WORKDIR)/app/app.bin > app.bin.txt

sys : make
# Create temporal sub directory
	@mkdir -p $(WORKDIR)/sys
# Generate sys.bin
	$(LD) -o $(WORKDIR)/sys/sys.bin -T $(SOFTDIR)/sys.ld $(WORKDIR)/*.o
# Dissassemble sys.bin and save to text file
	$(DU) -D $(WORKDIR)/sys.bin > sys.bin.txt

clean :
# Remove the work directory
	@rm -rf $(WORKDIR)