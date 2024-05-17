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
INTEGER {DIGIT}
DECIMAL  ({INTEGER}"."{DIGIT}*)
FLOAT    {DECIMAL}([eE][+-]?{INTEGER})
STRING \"([0-9a-zA-Z".""," ""-""+""*""/"":""_""$""%""!""#""@""&""~""^""("")""\n""\t""r""\\"\"])*\"

%%                        
([ \r\t])|("--"[^\n]*)	/* skip these */

"scalar"     { return KEYWORD_SCALAR; }
"str"        { return KEYWORD_STR; }
"bool"       { return KEYWORD_BOOL; }
"True"       { return KEYWORD_TRUE; }
"False"      { return KEYWORD_FALSE; }
"const"      { return KEYWORD_CONST; }
"if"         { return KEYWORD_IF; }
"else"       { return KEYWORD_ELSE; }
"endif"      { return KEYWORD_ENDIF; }
"for"        { return KEYWORD_FOR; }
"in"         { return KEYWORD_IN; }
"endfor"     { return KEYWORD_ENDFOR; }
"while"      { return KEYWORD_WHILE; }
"endwhile"   { return KEYWORD_ENDWHILE; }
"break"      { return KEYWORD_BREAK; }
"continue"   { return KEYWORD_CONTINUE; }
"not"        { return KEYWORD_NOT; }
"and"        { return KEYWORD_AND; }
"or"         { return KEYWORD_OR; }
"def"        { return KEYWORD_DEF; }
"enddef"     { return KEYWORD_ENDDEF; }
"main"       { return KEYWORD_MAIN; }
"return"     { return KEYWORD_RETURN; }
"comp"       { return KEYWORD_COMP; }
"endcomp"    { return KEYWORD_ENDCOMP; }
"of"         { return KEYWORD_OF; }
"integer"    { return KEYWORD_INTEGER; }

"("          { return LPAREN; }
")"          { return RPAREN; }
","          { return COMMA; }
"["          { return LBRACKET; }
"]"          { return RBRACKET; }
":"          { return COLON; }
"."          { return PERIOD; }
";"          { return SEMICOLON; }

"+"                { return PLUS; }
"-"                { return MINUS; }
"*"                { return MULT; }
"/"                { return DIV; }
"%"                { return MOD; }
"**"               { return POW; }

"=="               { return EQ; }
"!="               { return NEQ; }
"<"                { return LT; }
"<="               { return LEQ; }
">"                { return GT; }
">="               { return GEQ; }

"="                { return ASSIGN; }
"+="               { return PLUS_ASSIGN; }
"-="               { return MINUS_ASSIGN; }
"*="               { return MULT_ASSIGN; }
"/="               { return DIV_ASSIGN; }
"%="               { return MOD_ASSIGN; }
":="               { return COLON_ASSIGN; }

{ID} { return IDENTIFIER; }
{INTEGER} { return INTEGER; }

\n 					 ++lineNum;
.           { printf("Unrecognized token %s in line %d: \n", yytext, lineNum); }
<<EOF>> 		return EOF;

%%
int main ()
{
   int token;
   while ( (token = yylex()) != EOF )
      printf("Line %d Token %d: %s\n", lineNum, token, yytext);
}
