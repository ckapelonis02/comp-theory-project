#!/bin/bash

x=$1

bison -d -v -r all myanalyzer.y
flex mylexer.l

gcc -o mycompiler lex.yy.c myanalyzer.tab.c -lfl
./mycompiler < ../examples/$x.la > $x.c
indent $x.c -o $x.c
rm -f lex.yy.c myanalyzer.output myanalyzer.tab.c myanalyzer.tab.h mycompiler
gcc -std=c99 -Wall $x.c && ./a.out
