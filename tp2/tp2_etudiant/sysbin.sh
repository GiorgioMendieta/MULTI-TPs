#!/bin/bash

source ./compilation.sh

# Generate sys.bin
$LD -o sys.bin -T sys.ld reset.o giet.o drivers.o common.o ctx_handler.o irq_handler.o sys_handler.o exc_handler.o
# Dissassemble sys.bin and save to text file
$DU -D sys.bin > sys.bin.txt