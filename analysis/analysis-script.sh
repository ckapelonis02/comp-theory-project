bison -d -v -r all myanalyzer.y
flex mylexer.l
gcc -o mycompiler lex.yy.c myanalyzer.tab.c -lfl
./mycompiler < ../examples/mine/myprog.la
sh clean.sh