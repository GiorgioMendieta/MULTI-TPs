#!/bin/bash

##########################
# Script to compile 
##########################

# Set env variables 

export GIET_SYS_PATH=/users/enseig/alain/giet_2011/sys
export GIET_APP_PATH=/users/enseig/alain/giet_2011/app
export AS=/opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-as
export CC=/opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-gcc
export LD=/opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-ld
export DU=/opt/gcc-cross-mipsel/8.2.0/bin/mipsel-unknown-elf-objdump

# Compile ASM files
$AS -g -mips32 -o reset.o reset.s
$AS -g -mips32 -o giet.o $GIET_SYS_PATH/giet.s

# Compile C files
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_SYS_PATH -I. -c -o drivers.o $GIET_SYS_PATH/drivers.c
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_SYS_PATH -I. -c -o common.o $GIET_SYS_PATH/common.c
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_SYS_PATH -I. -c -o ctx_handler.o $GIET_SYS_PATH/ctx_handler.c
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_SYS_PATH -I. -c -o irq_handler.o $GIET_SYS_PATH/irq_handler.c
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_SYS_PATH -I. -c -o sys_handler.o $GIET_SYS_PATH/sys_handler.c
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_SYS_PATH -I. -c -o exc_handler.o $GIET_SYS_PATH/exc_handler.c