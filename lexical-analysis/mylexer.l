%{
#include <stdio.h>
int lineNum = 1;
#define KEYWORD_SCALAR   258
#define KEYWORD_STR      259
#define KEYWORD_BOOL     260
#define KEYWORD_TRUE     261
#define KEYWORD_FALSE    262
#define KEYWORD_CONST    263
#define KEYWORD_IF       264
#define KEYWORD_ELSE     265
#define KEYWORD_ENDIF    266
#define KEYWORD_FOR      267
#define KEYWORD_IN       268
#define KEYWORD_ENDFOR   269
#define KEYWORD_WHILE    270
#define KEYWORD_ENDWHILE 271
#define KEYWORD_BREAK    272
#define KEYWORD_CONTINUE 273
#define KEYWORD_NOT      274
#define KEYWORD_AND      275
#define KEYWORD_OR       276
#define KEYWORD_DEF      277
#define KEYWORD_ENDDEF   278
#define KEYWORD_MAIN     279
#define KEYWORD_RETURN   280
#define KEYWORD_COMP     281
#define KEYWORD_ENDCOMP  282
#define KEYWORD_OF       283
#define KEYWORD_INTEGER  284

#define LPAREN     285
#define RPAREN     286
#define COMMA      287
#define LBRACKET   288
#define RBRACKET   289
#define COLON      290
#define PERIOD     291
#define SEMICOLON  292

#define PLUS         293
#define MINUS        294
#define MULT         295
#define DIV          296
#define MOD          297
#define POW          298

#define EQ           299
#define NEQ          300
#define LT           301
#define LEQ          302
#define GT           303
#define GEQ          304

#define ASSIGN       305
#define PLUS_ASSIGN  306
#define MINUS_ASSIGN 307
#define MULT_ASSIGN  308
#define DIV_ASSIGN   309
#define MOD_ASSIGN   310
#define COLON_ASSIGN 311

#define IDENTIFIER  312
#define INTEGER  313
#define FLOAT   314
#define CONST_STRING 315
%}

ID      [a-zA-Z_][0-9a-zA-Z_]*
DIGIT   [0-9]
INTEGER (0|[1-9]{DIGIT}*)
DECIMAL  ({INTEGER}"."{DIGIT}*)
FLOAT    {DECIMAL}([eE][+-]?{INTEGER})?
STRING \"[0-9a-zA-Z\., \-\+\*\/\:\_\$\%\!\#\@\&\~\^\(\)\\n\\t\\r\\""\"]*\"

%%                        
([ \r\t])|("--"[^\n]*)	/* skip these */

"scalar"     { printf("Token KEYWORD_SCALAR: %s\n", yytext); return KEYWORD_SCALAR; }
"str"        { printf("Token KEYWORD_STR: %s\n", yytext); return KEYWORD_STR; }
"bool"       { printf("Token KEYWORD_BOOL: %s\n", yytext); return KEYWORD_BOOL; }
"True"       { printf("Token KEYWORD_TRUE: %s\n", yytext); return KEYWORD_TRUE; }
"False"      { printf("Token KEYWORD_FALSE: %s\n", yytext); return KEYWORD_FALSE; }
"const"      { printf("Token KEYWORD_CONST: %s\n", yytext); return KEYWORD_CONST; }
"if"         { printf("Token KEYWORD_IF: %s\n", yytext); return KEYWORD_IF; }
"else"       { printf("Token KEYWORD_ELSE: %s\n", yytext); return KEYWORD_ELSE; }
"endif"      { printf("Token KEYWORD_ENDIF: %s\n", yytext); return KEYWORD_ENDIF; }
"for"        { printf("Token KEYWORD_FOR: %s\n", yytext); return KEYWORD_FOR; }
"in"         { printf("Token KEYWORD_IN: %s\n", yytext); return KEYWORD_IN; }
"endfor"     { printf("Token KEYWORD_ENDFOR: %s\n", yytext); return KEYWORD_ENDFOR; }
"while"      { printf("Token KEYWORD_WHILE: %s\n", yytext); return KEYWORD_WHILE; }
"endwhile"   { printf("Token KEYWORD_ENDWHILE: %s\n", yytext); return KEYWORD_ENDWHILE; }
"break"      { printf("Token KEYWORD_BREAK: %s\n", yytext); return KEYWORD_BREAK; }
"continue"   { printf("Token KEYWORD_CONTINUE: %s\n", yytext); return KEYWORD_CONTINUE; }
"not"        { printf("Token KEYWORD_NOT: %s\n", yytext); return KEYWORD_NOT; }
"and"        { printf("Token KEYWORD_AND: %s\n", yytext); return KEYWORD_AND; }
"or"         { printf("Token KEYWORD_OR: %s\n", yytext); return KEYWORD_OR; }
"def"        { printf("Token KEYWORD_DEF: %s\n", yytext); return KEYWORD_DEF; }
"enddef"     { printf("Token KEYWORD_ENDDEF: %s\n", yytext); return KEYWORD_ENDDEF; }
"main"       { printf("Token KEYWORD_MAIN: %s\n", yytext); return KEYWORD_MAIN; }
"return"     { printf("Token KEYWORD_RETURN: %s\n", yytext); return KEYWORD_RETURN; }
"comp"       { printf("Token KEYWORD_COMP: %s\n", yytext); return KEYWORD_COMP; }
"endcomp"    { printf("Token KEYWORD_ENDCOMP: %s\n", yytext); return KEYWORD_ENDCOMP; }
"of"         { printf("Token KEYWORD_OF: %s\n", yytext); return KEYWORD_OF; }
"integer"    { printf("Token KEYWORD_INTEGER: %s\n", yytext); return KEYWORD_INTEGER; }

"("          { printf("Token LPAREN: %s\n", yytext); return LPAREN; }
")"          { printf("Token RPAREN: %s\n", yytext); return RPAREN; }
","          { printf("Token COMMA: %s\n", yytext); return COMMA; }
"["          { printf("Token LBRACKET: %s\n", yytext); return LBRACKET; }
"]"          { printf("Token RBRACKET: %s\n", yytext); return RBRACKET; }
":"          { printf("Token COLON: %s\n", yytext); return COLON; }
"."          { printf("Token PERIOD: %s\n", yytext); return PERIOD; }
";"          { printf("Token SEMICOLON: %s\n", yytext); return SEMICOLON; }

"+"                { printf("Token PLUS: %s\n", yytext); return PLUS; }
"-"                { printf("Token MINUS: %s\n", yytext); return MINUS; }
"*"                { printf("Token MULT: %s\n", yytext); return MULT; }
"/"                { printf("Token DIV: %s\n", yytext); return DIV; }
"%"                { printf("Token MOD: %s\n", yytext); return MOD; }
"**"               { printf("Token POW: %s\n", yytext); return POW; }

"=="               { printf("Token EQ: %s\n", yytext); return EQ; }
"!="               { printf("Token NEQ: %s\n", yytext); return NEQ; }
"<"                { printf("Token LT: %s\n", yytext); return LT; }
"<="               { printf("Token LEQ: %s\n", yytext); return LEQ; }
">"                { printf("Token GT: %s\n", yytext); return GT; }
">="               { printf("Token GEQ: %s\n", yytext); return GEQ; }

"="                { printf("Token ASSIGN: %s\n", yytext); return ASSIGN; }
"+="               { printf("Token PLUS_ASSIGN: %s\n", yytext); return PLUS_ASSIGN; }
"-="               { printf("Token MINUS_ASSIGN: %s\n", yytext); return MINUS_ASSIGN; }
"*="               { printf("Token MULT_ASSIGN: %s\n", yytext); return MULT_ASSIGN; }
"/="               { printf("Token DIV_ASSIGN: %s\n", yytext); return DIV_ASSIGN; }
"%="               { printf("Token MOD_ASSIGN: %s\n", yytext); return MOD_ASSIGN; }
":="               { printf("Token COLON_ASSIGN: %s\n", yytext); return COLON_ASSIGN; }

{ID} { printf("Token IDENTIFIER: %s\n", yytext); return IDENTIFIER; }
{INTEGER} { printf("Token INTEGER: %s\n", yytext); return INTEGER; }
{FLOAT} { printf("Token FLOAT: %s\n", yytext); return FLOAT; }
{STRING} { printf("Token CONST_STRING: %s\n", yytext); return CONST_STRING; }


\n 					 ++lineNum;
.           { printf("Unrecognized token %s in line %d: \n", yytext, lineNum); }
<<EOF>> 		return EOF;

%%
int main ()
{
   int token;
   while ( (token = yylex()) != EOF ) {}
}
