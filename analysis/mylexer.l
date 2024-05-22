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
int verbose = 0; // Global variable to control verbosity

#define VERBOSE_PRINT(fmt, ...) \
  do { if (verbose) printf(fmt, __VA_ARGS__); } while (0)

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
<string>{STRING}   { VERBOSE_PRINT("Token CONST_STRING: \"%s\"\n", yytext); yylval.str = strdup(yytext); return CONST_STRING; }
<string>\"         { BEGIN(INITIAL); }

"@defmacro"[ \r\t]+        { BEGIN(MACRO_DEF); }
<MACRO_DEF>{ID}    { ref_macro_id = strdup(yytext); BEGIN(MACRO_REPL); }
<MACRO_REPL>[ \r\t]+
<MACRO_REPL>.*\n    { add_macro(create_macro(ref_macro_id, strdup(yytext))); BEGIN(INITIAL); }

"scalar"           { VERBOSE_PRINT("Token KEYWORD_SCALAR: %s\n", yytext); return KEYWORD_SCALAR; }
"str"              { VERBOSE_PRINT("Token KEYWORD_STR: %s\n", yytext); return KEYWORD_STR; }
"bool"             { VERBOSE_PRINT("Token KEYWORD_BOOL: %s\n", yytext); return KEYWORD_BOOL; }
"True"             { VERBOSE_PRINT("Token KEYWORD_TRUE: %s\n", yytext); return KEYWORD_TRUE; }
"False"            { VERBOSE_PRINT("Token KEYWORD_FALSE: %s\n", yytext); return KEYWORD_FALSE; }
"const"            { VERBOSE_PRINT("Token KEYWORD_CONST: %s\n", yytext); return KEYWORD_CONST; }
"if"               { VERBOSE_PRINT("Token KEYWORD_IF: %s\n", yytext); return KEYWORD_IF; }
"else"             { VERBOSE_PRINT("Token KEYWORD_ELSE: %s\n", yytext); return KEYWORD_ELSE; }
"endif"            { VERBOSE_PRINT("Token KEYWORD_ENDIF: %s\n", yytext); return KEYWORD_ENDIF; }
"for"              { VERBOSE_PRINT("Token KEYWORD_FOR: %s\n", yytext); return KEYWORD_FOR; }
"in"               { VERBOSE_PRINT("Token KEYWORD_IN: %s\n", yytext); return KEYWORD_IN; }
"endfor"           { VERBOSE_PRINT("Token KEYWORD_ENDFOR: %s\n", yytext); return KEYWORD_ENDFOR; }
"while"            { VERBOSE_PRINT("Token KEYWORD_WHILE: %s\n", yytext); return KEYWORD_WHILE; }
"endwhile"         { VERBOSE_PRINT("Token KEYWORD_ENDWHILE: %s\n", yytext); return KEYWORD_ENDWHILE; }
"break"            { VERBOSE_PRINT("Token KEYWORD_BREAK: %s\n", yytext); return KEYWORD_BREAK; }
"continue"         { VERBOSE_PRINT("Token KEYWORD_CONTINUE: %s\n", yytext); return KEYWORD_CONTINUE; }
"not"              { VERBOSE_PRINT("Token KEYWORD_NOT: %s\n", yytext); return KEYWORD_NOT; }
"and"              { VERBOSE_PRINT("Token KEYWORD_AND: %s\n", yytext); return KEYWORD_AND; }
"or"               { VERBOSE_PRINT("Token KEYWORD_OR: %s\n", yytext); return KEYWORD_OR; }
"def"              { VERBOSE_PRINT("Token KEYWORD_DEF: %s\n", yytext); return KEYWORD_DEF; }
"enddef"           { VERBOSE_PRINT("Token KEYWORD_ENDDEF: %s\n", yytext); return KEYWORD_ENDDEF; }
"main"             { VERBOSE_PRINT("Token KEYWORD_MAIN: %s\n", yytext); return KEYWORD_MAIN; }
"return"           { VERBOSE_PRINT("Token KEYWORD_RETURN: %s\n", yytext); return KEYWORD_RETURN; }
"comp"             { VERBOSE_PRINT("Token KEYWORD_COMP: %s\n", yytext); return KEYWORD_COMP; }
"endcomp"          { VERBOSE_PRINT("Token KEYWORD_ENDCOMP: %s\n", yytext); return KEYWORD_ENDCOMP; }
"of"               { VERBOSE_PRINT("Token KEYWORD_OF: %s\n", yytext); return KEYWORD_OF; }
"integer"          { VERBOSE_PRINT("Token KEYWORD_INTEGER: %s\n", yytext); return KEYWORD_INTEGER; }
"("                { VERBOSE_PRINT("Token LPAREN: %s\n", yytext); return LPAREN; }
")"                { VERBOSE_PRINT("Token RPAREN: %s\n", yytext); return RPAREN; }
","                { VERBOSE_PRINT("Token COMMA: %s\n", yytext); return COMMA; }
"["                { VERBOSE_PRINT("Token LBRACKET: %s\n", yytext); return LBRACKET; }
"]"                { VERBOSE_PRINT("Token RBRACKET: %s\n", yytext); return RBRACKET; }
":"                { VERBOSE_PRINT("Token COLON: %s\n", yytext); return COLON; }
"."                { VERBOSE_PRINT("Token PERIOD: %s\n", yytext); return PERIOD; }
";"                { VERBOSE_PRINT("Token SEMICOLON: %s\n", yytext); return SEMICOLON; }
"+"                { VERBOSE_PRINT("Token PLUS: %s\n", yytext); return PLUS; }
"-"                { VERBOSE_PRINT("Token MINUS: %s\n", yytext); return MINUS; }
"*"                { VERBOSE_PRINT("Token MULT: %s\n", yytext); return MULT; }
"/"                { VERBOSE_PRINT("Token DIV: %s\n", yytext); return DIV; }
"%"                { VERBOSE_PRINT("Token MOD: %s\n", yytext); return MOD; }
"**"               { VERBOSE_PRINT("Token POW: %s\n", yytext); return POW; }
"=="               { VERBOSE_PRINT("Token EQ: %s\n", yytext); return EQ; }
"!="               { VERBOSE_PRINT("Token NEQ: %s\n", yytext); return NEQ; }
"<"                { VERBOSE_PRINT("Token LT: %s\n", yytext); return LT; }
"<="               { VERBOSE_PRINT("Token LEQ: %s\n", yytext); return LEQ; }
">"                { VERBOSE_PRINT("Token GT: %s\n", yytext); return GT; }
">="               { VERBOSE_PRINT("Token GEQ: %s\n", yytext); return GEQ; }
"="                { VERBOSE_PRINT("Token ASSIGN: %s\n", yytext); return ASSIGN; }
"+="               { VERBOSE_PRINT("Token PLUS_ASSIGN: %s\n", yytext); return PLUS_ASSIGN; }
"-="               { VERBOSE_PRINT("Token MINUS_ASSIGN: %s\n", yytext); return MINUS_ASSIGN; }
"*="               { VERBOSE_PRINT("Token MULT_ASSIGN: %s\n", yytext); return MULT_ASSIGN; }
"/="               { VERBOSE_PRINT("Token DIV_ASSIGN: %s\n", yytext); return DIV_ASSIGN; }
"%="               { VERBOSE_PRINT("Token MOD_ASSIGN: %s\n", yytext); return MOD_ASSIGN; }
":="               { VERBOSE_PRINT("Token COLON_ASSIGN: %s\n", yytext); return COLON_ASSIGN; }
"#"               { VERBOSE_PRINT("Token HASHTAG: %s\n", yytext); return HASHTAG; }
{ID}               {
              const char* repl = get_macro(yytext);
              if (repl == NULL) {
                VERBOSE_PRINT("Token IDENTIFIER: %s\n", yytext);
                yylval.str = strdup(yytext);
                return IDENTIFIER;
              }
              else {
                for (int i = strlen(repl)-1; i >= 0; i--)
                  unput(repl[i]);
              }
            }
{INTEGER}          {
                      yylval.str = strdup(yytext);
                      if (atoi(yylval.str) > 0) {
                        VERBOSE_PRINT("Token POS_INTEGER: %s\n", yytext);
                        return POS_INTEGER;
                      }
                      else {
                        VERBOSE_PRINT("Token INTEGER: %s\n", yytext);
                        return INTEGER;
                      }
}
{FLOAT}            { VERBOSE_PRINT("Token FLOAT: %s\n", yytext); yylval.str = strdup(yytext); return FLOAT; }
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
