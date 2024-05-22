clear
bison -d -v -r all -Wconflicts-rr -Wcounterexamples myanalyzer.y
flex mylexer.l
gcc -o mycompiler lex.yy.c myanalyzer.tab.c cgen.c -lfl
./mycompiler < ../examples/mine/my-ex.la
sh clean.sh