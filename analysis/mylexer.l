%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cgen.h"
#include "myanalyzer.tab.h"
#define MACROS_SIZE 100
#define LINE_SIZE 512

typedef struct Macro {
   char *identifier;
   char *replacement;
} Macro;

char* print_line_n(FILE *fp, int n);
Macro* create_macro(const char *identifier, const char *replacement);
void add_macro(Macro* m);
const char* get_macro(const char *identifier);
Macro* macros_arr[MACROS_SIZE];
int avail = 0;
char* ref_macro_id = NULL;

int lineNum = 1;


%}

ID       [a-zA-Z_][0-9a-zA-Z_]*
DIGIT    [0-9]
INTEGER  (0|[1-9]{DIGIT}*)
DECIMAL  ({INTEGER}"."{DIGIT}*)
FLOAT    {DECIMAL}([eE][+-]?{INTEGER})?
STRING   ([0-9a-zA-Z\., \-\+\*\/\:\_\$\%\!\#\@\&\~\^\(\)]|\\[\\ntr\\"\\])*

%x string
%x MACRO_DEF
%x MACRO_REPL

%%                        
([ \r\t])|("--"[^\n]*)	/* skip these */

\"                 { BEGIN(string); }
<string>{STRING}   { printf("Token CONST_STRING: \"%s\"\n", yytext); return CONST_STRING; }
<string>\"         { BEGIN(INITIAL); }

"@defmacro"[ \r\t]+        { BEGIN(MACRO_DEF); }
<MACRO_DEF>{ID}    { ref_macro_id = strdup(yytext); BEGIN(MACRO_REPL); }
<MACRO_REPL>[ \r\t]+
<MACRO_REPL>.*\n    { add_macro(create_macro(ref_macro_id, strdup(yytext))); BEGIN(INITIAL); }

"scalar"           { printf("Token KEYWORD_SCALAR: %s\n", yytext); return KEYWORD_SCALAR; }
"str"              { printf("Token KEYWORD_STR: %s\n", yytext); return KEYWORD_STR; }
"bool"             { printf("Token KEYWORD_BOOL: %s\n", yytext); return KEYWORD_BOOL; }
"True"             { printf("Token KEYWORD_TRUE: %s\n", yytext); return KEYWORD_TRUE; }
"False"            { printf("Token KEYWORD_FALSE: %s\n", yytext); return KEYWORD_FALSE; }
"const"            { printf("Token KEYWORD_CONST: %s\n", yytext); return KEYWORD_CONST; }
"if"               { printf("Token KEYWORD_IF: %s\n", yytext); return KEYWORD_IF; }
"else"             { printf("Token KEYWORD_ELSE: %s\n", yytext); return KEYWORD_ELSE; }
"endif"            { printf("Token KEYWORD_ENDIF: %s\n", yytext); return KEYWORD_ENDIF; }
"for"              { printf("Token KEYWORD_FOR: %s\n", yytext); return KEYWORD_FOR; }
"in"               { printf("Token KEYWORD_IN: %s\n", yytext); return KEYWORD_IN; }
"endfor"           { printf("Token KEYWORD_ENDFOR: %s\n", yytext); return KEYWORD_ENDFOR; }
"while"            { printf("Token KEYWORD_WHILE: %s\n", yytext); return KEYWORD_WHILE; }
"endwhile"         { printf("Token KEYWORD_ENDWHILE: %s\n", yytext); return KEYWORD_ENDWHILE; }
"break"            { printf("Token KEYWORD_BREAK: %s\n", yytext); return KEYWORD_BREAK; }
"continue"         { printf("Token KEYWORD_CONTINUE: %s\n", yytext); return KEYWORD_CONTINUE; }
"not"              { printf("Token KEYWORD_NOT: %s\n", yytext); return KEYWORD_NOT; }
"and"              { printf("Token KEYWORD_AND: %s\n", yytext); return KEYWORD_AND; }
"or"               { printf("Token KEYWORD_OR: %s\n", yytext); return KEYWORD_OR; }
"def"              { printf("Token KEYWORD_DEF: %s\n", yytext); return KEYWORD_DEF; }
"enddef"           { printf("Token KEYWORD_ENDDEF: %s\n", yytext); return KEYWORD_ENDDEF; }
"main"             { printf("Token KEYWORD_MAIN: %s\n", yytext); return KEYWORD_MAIN; }
"return"           { printf("Token KEYWORD_RETURN: %s\n", yytext); return KEYWORD_RETURN; }
"comp"             { printf("Token KEYWORD_COMP: %s\n", yytext); return KEYWORD_COMP; }
"endcomp"          { printf("Token KEYWORD_ENDCOMP: %s\n", yytext); return KEYWORD_ENDCOMP; }
"of"               { printf("Token KEYWORD_OF: %s\n", yytext); return KEYWORD_OF; }
"integer"          { printf("Token KEYWORD_INTEGER: %s\n", yytext); return KEYWORD_INTEGER; }
"("                { printf("Token LPAREN: %s\n", yytext); return LPAREN; }
")"                { printf("Token RPAREN: %s\n", yytext); return RPAREN; }
","                { printf("Token COMMA: %s\n", yytext); return COMMA; }
"["                { printf("Token LBRACKET: %s\n", yytext); return LBRACKET; }
"]"                { printf("Token RBRACKET: %s\n", yytext); return RBRACKET; }
":"                { printf("Token COLON: %s\n", yytext); return COLON; }
"."                { printf("Token PERIOD: %s\n", yytext); return PERIOD; }
";"                { printf("Token SEMICOLON: %s\n", yytext); return SEMICOLON; }
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
{ID}               {
                     const char* repl = get_macro(yytext);
                     if (repl == NULL) {
                        printf("Token IDENTIFIER: %s\n", yytext);
                        return IDENTIFIER;
                     }
                     else {
                        for (int i = strlen(repl)-1; i >= 0; i--)
                           unput(repl[i]);
                     }
                   }
{INTEGER}          {
   printf("Token INTEGER: %s\n", yytext);
   yylval.str = strdup(yytext);
   return INTEGER; }
{FLOAT}            { printf("Token FLOAT: %s\n", yytext); return FLOAT; }
\n 					 ++lineNum;
.                  {
                     printf("Unrecognized token %s in line %d: %s\n", yytext, lineNum, print_line_n(yyin, lineNum));
                     exit(1);
                   }
<<EOF>> 	        	 return EOF;

%%
char* print_line_n(FILE *fp, int n) {
   char line[LINE_SIZE];
   int current_line = 0;

   // Move to the beginning of the file
   rewind(fp);

   // Read up to the n-th line
   while (fgets(line, sizeof(line), fp) != NULL) {
      if (++current_line == n) {
         // Allocate memory for the line to return
         char* result = malloc(strlen(line) + 1);
         if (result != NULL)
            strcpy(result, line);

         return result;
      }
   }
   return NULL;
}

// Create a macro
Macro* create_macro(const char *identifier, const char *replacement) {
   Macro *new_macro = (Macro *)malloc(sizeof(Macro));
   new_macro->identifier = strdup(identifier);
   new_macro->replacement = strdup(replacement);
   return new_macro;
}

// Function to add a macro definition
void add_macro(Macro* m) {
   for (int i = 0; i < avail; i++) {
      if (strcmp(m->identifier, macros_arr[i]->identifier) == 0) {
         macros_arr[i] = m;
         return;
      }
   }
   macros_arr[avail] = m;
   avail++;
}

// Function to get the replacement for a macro identifier
const char* get_macro(const char *identifier) {
   for (int i = 0; i < avail; i++) {
      if (strcmp(identifier, macros_arr[i]->identifier) == 0) {
         return macros_arr[i]->replacement;
      }
   }
   return NULL;
}