clear
bison -d -v -r all -Wconflicts-rr -Wconflicts-sr -Wcounterexamples myanalyzer.y
flex mylexer.l
gcc -o mycompiler lex.yy.c myanalyzer.tab.c -lfl
./mycompiler < ../examples/array_comprehension.la > kati.c
sh clean.sh