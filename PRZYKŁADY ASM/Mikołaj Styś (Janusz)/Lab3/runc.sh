#!/bin/bash
object_file="$1.o";
script_file="$1.c";
bak_file="$script_file.bak";
final_file=$1;
log_file="lastRunLog"

cp $script_file $bak_file;
gcc -m32 -c -S $script_file
gcc -m32 -c $script_file -o $object_file
gcc -m32 $object_file -o $final_file
rm $object_file;
echo "Program:";
./$final_file;
echo "\nKoniec";
