%{
#include <stdio.h>
#include "cgen.h"

extern int yylex(void);
extern int lineNum;

%}

%union
{
  char* str;
}

%token KEYWORD_SCALAR   258
%token KEYWORD_STR      259
%token KEYWORD_BOOL     260
%token KEYWORD_TRUE     261
%token KEYWORD_FALSE    262
%token KEYWORD_CONST    263
%token KEYWORD_IF       264
%token KEYWORD_ELSE     265
%token KEYWORD_ENDIF    266
%token KEYWORD_FOR      267
%token KEYWORD_IN       268
%token KEYWORD_ENDFOR   269
%token KEYWORD_WHILE    270
%token KEYWORD_ENDWHILE 271
%token KEYWORD_BREAK    272
%token KEYWORD_CONTINUE 273
%token KEYWORD_NOT      274
%token KEYWORD_AND      275
%token KEYWORD_OR       276
%token KEYWORD_DEF      277
%token KEYWORD_ENDDEF   278
%token KEYWORD_MAIN     279
%token KEYWORD_RETURN   280
%token KEYWORD_COMP     281
%token KEYWORD_ENDCOMP  282
%token KEYWORD_OF       283
%token KEYWORD_INTEGER  284
%token LPAREN           285
%token RPAREN           286
%token COMMA            287
%token LBRACKET         288
%token RBRACKET         289
%token COLON            290
%token PERIOD           291
%token SEMICOLON        292
%token PLUS             293
%token MINUS            294
%token MULT             295
%token DIV              296
%token MOD              297
%token POW              298
%token EQ               299
%token NEQ              300
%token LT               301
%token LEQ              302
%token GT               303
%token GEQ              304
%token ASSIGN           305
%token PLUS_ASSIGN      306
%token MINUS_ASSIGN     307
%token MULT_ASSIGN      308
%token DIV_ASSIGN       309
%token MOD_ASSIGN       310
%token COLON_ASSIGN     311
%token <str> IDENTIFIER       312
%token <str> INTEGER          313
%token <str> FLOAT            314
%token CONST_STRING     315

%start input

%type<str> comp_type_decl
%type<str> const_decl
%type<str> var_decl
%type<str> func_decl
%type<str> main_func

%type<str> main_header
%type<str> main_body

%type<str> func_header
%type<str> func_body
%type<str> func_end
%type<str> func_name
%type<str> func_param_list
%type<str> return_type

%type<str> dt
%type<str> primitive_dt
%type<str> comp_dt
%type<str> sized_arr_dt
%type<str> arr_dt
%type<str> bool_dt

%%

input:
  main_func
  | func_decl input
//  | var_decl input
//  | const_decl input
//  | comp_type_decl input

main_func:
  main_header main_body func_end
  {
    printf("%s %s %s", $1, $2, $3);
  };

main_header:
  KEYWORD_DEF KEYWORD_MAIN LPAREN RPAREN COLON
  {
    $$ = "def main():\n";
  };

main_body:
  %empty
  {
    $$ = "";
  };

func_end:
  KEYWORD_ENDDEF SEMICOLON
  {
    $$ = "enddef;\n";
  };

func_decl:
  func_header func_body func_end
  {
    printf("%s %s %s", $1, $2, $3);
  };

func_header:
  KEYWORD_DEF IDENTIFIER LPAREN func_param_list RPAREN COLON
  {
    $$ = template("def %s(%s):\n", $2, $4);
  };
  | KEYWORD_DEF IDENTIFIER LPAREN func_param_list RPAREN " -> " return_type COLON
  {
    $$ = template("def %s(%s): ->  %s\n", $2, $4, $7);
  };

func_param_list:
  %empty
  {
    $$ = "";
  };

func_body:
  %empty
  {
    $$ = "";
  };

return_type:
  %empty
  {
    $$ = "";
  };

dt:
  primitive_dt
  | KEYWORD_COMP
  {
    $$ = "comp";
  };
  | sized_arr_dt
  | arr_dt

arr_dt:
  LBRACKET RBRACKET COLON primitive_dt
  {
    $$ = template("[]:%s", $4);
  };
  | LBRACKET RBRACKET COLON IDENTIFIER
  {
    $$ = template("[]:%s", $4);
  };

sized_arr_dt:
  LBRACKET INTEGER RBRACKET COLON primitive_dt
  {
    $$ = template("[%s]:%s", $2, $5);
  };
  | LBRACKET INTEGER RBRACKET COLON IDENTIFIER
  {
    $$ = template("[%s]:%s", $2, $5);
  };

primitive_dt:
  KEYWORD_SCALAR
  {
    $$ = "scalar";
  };
  | KEYWORD_INTEGER
  {
    $$ = "integer";
  };
  | KEYWORD_STR
  {
    $$ = "str";
  };
  | KEYWORD_BOOL
  {
    $$ = "bool";
  };


bool_dt:
  KEYWORD_TRUE
  {
    $$ = "True";
  };
  | KEYWORD_FALSE
  {
    $$ = "False";
  };

//const_decl:
//  KEYWORD_CONST IDENTIFIER EQ val primitive_dt;
//  {
//    $$ = template("const %s = %s: %s", $2, $4, $5);
//  };













%%

int main() {
  if (yyparse() == 0)
    printf("\nAccepted!\n");
  else
    printf("\nRejected!\n");
}
