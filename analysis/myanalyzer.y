%{
#include <stdio.h>
#include <stdlib.h>
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
%token <str> CONST_STRING     315

%start input

%type<str> func_decl_rec
%type<str> var_decl_rec
%type<str> const_decl_rec
%type<str> comp_decl_rec

%type<str> main_func
%type<str> main_header
%type<str> main_body
%type<str> main_end

%type<str> func_decl
%type<str> func_header
%type<str> func_body
%type<str> func_end
%type<str> func_param_list
%type<str> func_arg_type
%type<str> func_arg
%type<str> func_declarations
%type<str> func_arg_name
%type<str> func_stmts
%type<str> return_type
%type<str> return_stmt

%type<str> dt
%type<str> primitive_dt
%type<str> sized_arr_dt
%type<str> arr_dt
%type<str> bool_dt

%type<str> var_decl_list
%type<str> var_decl
%type<str> var_name
%type<str> var_type

%type<str> comp_decl
%type<str> comp_header
%type<str> comp_body
%type<str> comp_end
%type<str> comp_var_name

%type<str> const_decl
%type<str> const_expr

%type<str> stmt
%type<str> expr
%type<str> pos_integer


%%


/*
*                 INPUT PROGRAM
* */
input:
//  func_header { printf("%s", $1); };
//  main_func
//  | func_decl_rec input
//  | var_decl_rec input
  func_decl_rec
//  | const_decl_rec input
//  | comp_type_decl_rec input














/*
*                 RECURSIVE BASIC COMPONENTS
* */

func_decl_rec:
  func_decl
  {
    printf("%s\n", $1);
  };
  | func_decl_rec func_decl
  {
    printf("%s\n", $2);
  };

var_decl_rec:
  var_decl
  {
    printf("%s\n", $1);
  };
  | var_decl_rec var_decl
  {
    printf("%s\n", $2);
  };

const_decl_rec:
  const_decl
  {
    printf("%s\n", $1);
  };
  | const_decl_rec const_decl
  {
    printf("%s\n", $2);
  };

comp_decl_rec:
  comp_decl
  {
    printf("%s\n", $1);
  };
  | comp_decl_rec comp_decl
  {
    printf("%s\n", $2);
  };










/*
*                  MAIN FUNCTION
* */

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

main_end:
  func_end













/*
              FUNCTIONS
*/
func_decl:
  func_header func_body func_end
  {
    $$ = template("%s%s%s", $1, $2, $3);
  };

func_header:
  KEYWORD_DEF IDENTIFIER LPAREN func_param_list RPAREN COLON
  {
    $$ = template("def %s(%s):\n", $2, $4);
  };
  | KEYWORD_DEF IDENTIFIER LPAREN func_param_list RPAREN MINUS GT return_type COLON
  {
    $$ = template("def %s(%s) -> %s:\n", $2, $4, $8);
  };

return_type:
  var_type

func_param_list:
  %empty
  {
    $$ = "";
  };
  | func_arg
  | func_param_list COMMA func_arg
  {
    $$ = template("%s, %s", $1, $3);
  };

func_arg:
  func_arg_name COLON func_arg_type
  {
    $$ = template("%s: %s", $1, $3);
  };

func_arg_name:
  IDENTIFIER
  | IDENTIFIER LBRACKET RBRACKET
  {
    $$ = template("%s[]", $1);
  };

func_arg_type:
  var_type

//func_body:
//  func_stmts
//  | func_declarations func_body
//  {
//    $$ = template("%s\n\n%s", $1, $2);
//  };
//  | func_body return_stmt
//  {
//    $$ = template("%s\n\n%s", $1, $2);
//  };

func_declarations:
  %empty
{
  $$ = "";
};

func_stmts:
  %empty
{
  $$ = "";
};

return_stmt:
  KEYWORD_RETURN SEMICOLON
  {
    $$ = "return;";
  };
  | KEYWORD_RETURN expr SEMICOLON
  {
    $$ = template("return %s;", $2);
  };

func_end:
  KEYWORD_ENDDEF SEMICOLON
  {
    $$ = "enddef;\n";
  };











/*
*                  VARIABLES
* */
var_decl_list:
  var_name
  | var_decl_list COMMA var_name
  {
    $$ = template("%s, %s", $1, $3);
  };

var_decl:
  var_decl_list COLON var_type SEMICOLON
  {
    $$ = template("%s: %s;", $1, $3);
  };

var_decl_list:
  var_name
  | var_decl_list COMMA var_name
  {
    $$ = template("%s, %s", $1, $3);
  };

var_name:
  IDENTIFIER
  | IDENTIFIER LBRACKET pos_integer RBRACKET
  {
    $$ = template("%s[%s]", $1, $3);
  };

var_type:
  primitive_dt
  | IDENTIFIER













/*
*                  DATA TYPES
* */
dt:
  primitive_dt
  | KEYWORD_COMP
  {
    $$ = "comp";
  };
  | sized_arr_dt
  | arr_dt

arr_dt:
  LBRACKET RBRACKET COLON var_type
  {
    $$ = template("[]:%s", $4);
  };

sized_arr_dt:
  LBRACKET pos_integer RBRACKET COLON var_type
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














/*
*                  COMP TYPE
* */
comp_decl:
  comp_header comp_body comp_end
  {
    $$ = template("%s\n%s\n%s", $1, $2, $3);
  };

comp_var_name:
  '#' IDENTIFIER
  {
    $$ = template("#%s", $2);
  };
  | '#' IDENTIFIER LBRACKET INTEGER RBRACKET
  {
    $$ = template("#%s [%s]", $2, $4);
  };

comp_body:
  %empty
  | comp_var_name
  | comp_body func_decl_rec
  {
    $$ = template("%s\n%s", $1, $2);
  };

comp_header:
  KEYWORD_COMP IDENTIFIER
  {
    $$ = template("comp %s", $2);
  };

comp_end:
  KEYWORD_ENDCOMP SEMICOLON
  {
    $$ = "endcomp;";
  };

















/*
*                  CONST
* */
const_decl:
  KEYWORD_CONST IDENTIFIER ASSIGN const_expr COLON primitive_dt SEMICOLON
  {
    $$ = template("const %s = %s: %s;", $2, $4, $6);
  };

const_expr:
  %empty
  {
    $$ = "";
  };


























/*
*                  GENERAL
* */
pos_integer:
  INTEGER
  {
    if (atoi($1) > 0)
      $$ = $1;
    else
      exit(1);
  };

stmt:
  %empty
{
  $$ = "";
};

expr:
  %empty
{
  $$ = "";
};

















%%

int main() {
  if (yyparse() == 0)
    printf("\nAccepted!\n");
  else
    printf("\nRejected!\n");
}
