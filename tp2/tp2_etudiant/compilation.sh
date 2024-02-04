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

export CCFLAGS="-Wall -mno-gpopt -ffreestanding -mips32 -I$(GIET_SYS_PATH) -I."


# Change directory 
cd ./soft

# Compile ASM files
$AS -g -mips32 -o reset.o reset.s
$AS -g -mips32 -o giet.o $GIET_SYS_PATH/giet.s

# Compile C files
$CC $CCFLAGS -c -o drivers.o $GIET_SYS_PATH/drivers.c
$CC $CCFLAGS -c -o common.o $GIET_SYS_PATH/common.c
$CC $CCFLAGS -c -o ctx_handler.o $GIET_SYS_PATH/ctx_handler.c
$CC $CCFLAGS -c -o irq_handler.o $GIET_SYS_PATH/irq_handler.c
$CC $CCFLAGS -c -o sys_handler.o $GIET_SYS_PATH/sys_handler.c
$CC $CCFLAGS -c -o exc_handler.o $GIET_SYS_PATH/exc_handler.c