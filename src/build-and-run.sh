#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename_without_extension> [burn]"
    exit 1
fi

# Assign the argument to a variable
filename=$1

# Assemble the .asm file to .bin using NASM
nasm -f bin "${filename}/${filename}.asm" -o "${filename}/${filename}.bin"
# Check if NASM succeeded
if [ $? -ne 0 ]; then
    echo "> Assembly failed."
    exit 1
else 
    echo "> Assembly succeeded."
fi


dd if=${filename}/${filename}.bin of=${filename}/floppy.img bs=512 count=1 conv=notrunc
# Check if QEMU exited successfully
if [ $? -ne 0 ]; then
    echo "> Creating floppy failed."
    exit 1
else
    echo "> Creating floppy succeeded."
fi


qemu-system-i386 -fda ${filename}/floppy.img
