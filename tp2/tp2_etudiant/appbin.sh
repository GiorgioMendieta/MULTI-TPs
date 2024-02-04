#!/bin/bash

source ./compilation.sh

# Compile stdio.c et main.c in ./soft
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_APP_PATH -I. -c -o stdio.o $GIET_APP_PATH/stdio.c
$CC -Wall -mno-gpopt -ffreestanding -mips32 -I$GIET_APP_PATH -I. -c -o main.o main.c

# Generate app.bin
$LD -o app.bin -T app.ld stdio.o main.o

# Dissassemble sys.bin and save to text file
$DU -D app.bin > app.bin.txt