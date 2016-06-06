#!/bin/bash
object_file1="$1.o";
script_file1="$1.c";
final_file=$1;

object_file2="$2.o";
script_file2="$2.s";

gcc -m32 -O0 -ggdb -c $script_file1 -o $object_file1
gcc -m32 -O0 -ggdb -c $script_file2 -o $object_file2
gcc -m32 -O0 -ggdb -o $final_file $object_file1 $object_file2
rm $object_file1 $object_file2;
echo "Program:";
./$final_file;
echo "\nKoniec";
