clear
bison -d -v -r all -Wconflicts-rr -Wconflicts-sr -Wcounterexamples myanalyzer.y
flex mylexer.l
gcc -o mycompiler lex.yy.c myanalyzer.tab.c -lfl
./mycompiler < ../examples/correct1.la > correct1.c
rm -f lex.yy.c myanalyzer.output myanalyzer.tab.c myanalyzer.tab.h mycompiler
gcc -std=c99 -Wall correct1.c
./a.out