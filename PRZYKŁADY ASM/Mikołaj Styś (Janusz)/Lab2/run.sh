#!/bin/bash
object_file="$1.o";
script_file="$1.s";
bak_file="$script_file.bak";
final_file=$1;

cp $script_file $bak_file;
as --gstabs --32 $script_file -o $object_file;
ld -m elf_i386 $object_file -o $final_file;
rm $object_file;
echo "Program:";
./$final_file;
echo "\nKoniec:";
