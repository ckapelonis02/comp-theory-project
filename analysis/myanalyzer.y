%{
#include <stdio.h>
#include <string.h>
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
%token KEYWORD_DEF      277
%token KEYWORD_ENDDEF   278
%token KEYWORD_MAIN     279
%token KEYWORD_RETURN   280
%token KEYWORD_COMP     281
%token KEYWORD_ENDCOMP  282
%token KEYWORD_OF       283
%token KEYWORD_INTEGER  284

%token <str> IDENTIFIER       312
%token <str> INTEGER          313
%token <str> FLOAT            314
%token <str> CONST_STRING     315
%token HASHTAG                316


%token SEMICOLON        292

%right ASSIGN           305
%right PLUS_ASSIGN      306
%right MINUS_ASSIGN     307
%right COLON_ASSIGN     311
%right MULT_ASSIGN      308
%right DIV_ASSIGN       309
%right MOD_ASSIGN       310
%left KEYWORD_OR       276
%left KEYWORD_AND      275
%right KEYWORD_NOT      274
%left EQ               299
%left NEQ              300
%left LT               301
%left LEQ              302
%left GT               303
%left GEQ              304
%left PLUS             293
%left MINUS            294
%left MULT             295
%left DIV              296
%left MOD              297
%right POW              298
%left LBRACKET         288
%left RBRACKET         289
%left PERIOD           291
%left RPAREN           286
%left LPAREN           285

%token COMMA            287
%token COLON            290



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
%type<str> return_type

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
%type<str> comp_var_decl_rec
%type<str> comp_var_decl
%type<str> comp_var_decl_list
%type<str> comp_var_name
%type<str> comp_func_decl_rec

%type<str> const_decl

%type<str> expr
%type<str> operand
%type<str> expr_list

%type<str> stmt
%type<str> stmts
%type<str> if_stmt
%type<str> empty_stmt
%type<str> break_stmt
%type<str> continue_stmt
%type<str> return_stmt
%type<str> while_stmt
%type<str> for_stmt
%type<str> assign_stmt
%type<str> range_comprehension
%type<str> arr_comprehension

%type<str> func_call

%type<str> arr_index



%%


/*
*                 INPUT PROGRAM
* */
input:
//  main_func
//  | func_decl_rec input
//  | var_decl_rec input
//  | const_decl_rec input
//  | comp_decl_rec input














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
  func_body

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

func_body:
  func_declarations stmts
  {
    $$ = template("%s\n\n%s", $1, $2);
  };

func_declarations:
  %empty
  {
    $$ = "";
  }

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

var_name:
  IDENTIFIER
  | IDENTIFIER LBRACKET arr_index RBRACKET
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
  LBRACKET arr_index RBRACKET COLON var_type
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

comp_header:
  KEYWORD_COMP IDENTIFIER COLON
  {
    $$ = template("comp %s:", $2);
  };

comp_body:
  comp_var_decl_rec
  {
    $$ = template("%s", $1);
  };
  | comp_var_decl_rec comp_func_decl_rec
  {
    $$ = template("%s\n%s\n", $1, $2);
  };

comp_func_decl_rec:
  func_decl
  {
    $$ = template("%s\n", $1);
  };
  | comp_func_decl_rec func_decl
  {
    $$ = template("%s%s\n", $$, $2);
  };

comp_var_decl_rec:
  comp_var_decl
  {
    $$ = template("%s\n", $1);
  };
  | comp_var_decl_rec comp_var_decl
  {
    $$ = template("%s%s\n", $$, $2);
  };

comp_var_decl:
  comp_var_decl_list COLON var_type SEMICOLON
  {
    $$ = template("%s: %s;", $1, $3);
  };

comp_var_decl_list:
  comp_var_name
  | comp_var_decl_list COMMA comp_var_name
  {
    $$ = template("%s, %s", $1, $3);
  };

comp_var_name:
  HASHTAG IDENTIFIER
  {
    $$ = template("#%s", $2);
  };
  | HASHTAG IDENTIFIER LBRACKET arr_index RBRACKET
  {
    $$ = template("#%s[%s]", $2, $4);
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
  KEYWORD_CONST IDENTIFIER ASSIGN expr COLON primitive_dt SEMICOLON
  {
    $$ = template("const %s = %s: %s;", $2, $4, $6);
  };












/*
*                  EXPRESSIONS - OPERANDS
* */
expr: //conflict
  operand
  | expr PLUS expr
  {
    $$ = template("%s + %s", $1, $3);
  };
  | expr MINUS expr
  {
    $$ = template("%s - %s", $1, $3);
  };
  | expr MULT expr
  {
    $$ = template("%s * %s", $1, $3);
  };
  | expr DIV expr
  {
    $$ = template("%s / %s", $1, $3);
  };
  | expr MOD expr
  {
    $$ = template("%s", $1);
    strcat($$, " % ");
    strcat($$, template("%s", $3));
  };
  | expr GT expr
  {
    $$ = template("%s > %s", $1, $3);
  };
  | expr LT expr
  {
    $$ = template("%s < %s", $1, $3);
  };
  | expr GEQ expr
  {
    $$ = template("%s >= %s", $1, $3);
  };
  | expr LEQ expr
  {
    $$ = template("%s <= %s", $1, $3);
  };
  | expr EQ expr
  {
    $$ = template("%s == %s", $1, $3);
  };
  | expr NEQ expr
  {
    $$ = template("%s != %s", $1, $3);
  };
  | expr KEYWORD_AND expr
  {
    $$ = template("%s and %s", $1, $3);
  };
  | expr KEYWORD_OR expr
  {
    $$ = template("%s or %s", $1, $3);
  };
  | KEYWORD_NOT expr
  {
    $$ = template("not %s", $2);
  };
  | PLUS expr
  {
    $$ = template("+%s", $2);
  };
  | MINUS expr
  {
    $$ = template("-%s", $2);
  };
  | expr POW expr
  {
    $$ = template("%s**%s", $1, $3);
  };
  | LPAREN expr RPAREN
  {
    $$ = template("(%s)", $2);
  };
  | expr PERIOD expr
  {
    $$ = template("%s.%s", $1, $3);
  };
  | expr ASSIGN expr
  {
    $$ = template("%s = %s", $1, $3);
  };
  | expr PLUS_ASSIGN expr
  {
    $$ = template("%s += %s", $1, $3);
  };
  | expr MINUS_ASSIGN expr
  {
    $$ = template("%s -= %s", $1, $3);
  };
  | expr MULT_ASSIGN expr
  {
    $$ = template("%s *= %s", $1, $3);
  };
  | expr DIV_ASSIGN expr
  {
    $$ = template("%s /= %s", $1, $3);
  };
  | expr MOD_ASSIGN expr
  {
    $$ = template("%s %= %s", $1, $3);
  };
  | expr COLON_ASSIGN expr
  {
    $$ = template("%s := %s", $1, $3);
  };

operand:
  var_name
  | func_call
  | INTEGER
  | FLOAT
  | bool_dt
  | CONST_STRING

expr_list:
  %empty
  {
    $$ = "";
  };
  | expr
  | expr_list COMMA expr
  {
    $$ = template("%s, %s", $1, $3);
  };
























/*
*                  STATEMENTS
* */
stmts:
  stmt
  {
    $$ = template("%s", $1);
  };
  | stmts stmt
  {
    $$ = template("%s%s", $1, $2);
  };

stmt:
  empty_stmt
  | if_stmt
  | func_call SEMICOLON
  {
    $$ = template("%s;\n", $1);
  };
  | return_stmt
  | break_stmt
  | continue_stmt
  | while_stmt
  | for_stmt
  | assign_stmt
  | range_comprehension
  | arr_comprehension

range_comprehension:
  var_name COLON_ASSIGN LBRACKET expr KEYWORD_FOR var_name COLON INTEGER RBRACKET COLON var_type SEMICOLON
  {
    $$ = template("%s := [%s for %s:%s] : %s;\n", $1, $4, $6, $8, $11);
  };

arr_comprehension:
  var_name COLON_ASSIGN LBRACKET expr KEYWORD_FOR var_name COLON var_type KEYWORD_IN var_name KEYWORD_OF INTEGER RBRACKET COLON var_type SEMICOLON
  {
    $$ = template("%s := [%s for %s: %s in %s of %s] : %s;\n", $1, $4, $6, $8, $10, $12, $15);
  };

for_stmt:
   KEYWORD_FOR var_name KEYWORD_IN LBRACKET expr COLON expr COLON expr RBRACKET COLON stmts KEYWORD_ENDFOR SEMICOLON
  {
    $$ = template("for %s in [%s : %s : %s]:\n%sendfor;\n", $2, $5, $7, $9, $12);
  };
  | KEYWORD_FOR var_name KEYWORD_IN LBRACKET expr COLON expr RBRACKET COLON stmts KEYWORD_ENDFOR SEMICOLON
  {
    $$ = template("for %s in [%s : %s]:\n%sendfor;\n", $2, $5, $7, $10);
  };

while_stmt:
  KEYWORD_WHILE LPAREN expr RPAREN COLON stmts KEYWORD_ENDWHILE SEMICOLON
  {
    $$ = template("while (%s):\n%sendwhile;\n", $3, $6);
  };

assign_stmt:
  var_name ASSIGN expr SEMICOLON
  {
    $$ = template("%s = %s;\n", $1, $3);
  };

return_stmt:
  KEYWORD_RETURN SEMICOLON
  {
    $$ = "return;\n";
  };
  | KEYWORD_RETURN expr SEMICOLON
  {
    $$ = template("return %s;\n", $2);
  };

break_stmt:
  KEYWORD_BREAK SEMICOLON
  {
    $$ = "break;\n";
  };

continue_stmt:
  KEYWORD_CONTINUE SEMICOLON
  {
    $$ = "continue;\n";
  };

empty_stmt:
  SEMICOLON
  {
    $$ = ";\n";
  };

if_stmt:
  KEYWORD_IF LPAREN expr RPAREN COLON stmts KEYWORD_ENDIF SEMICOLON
  {
    $$ = template("if (%s):\n%sendif;\n", $3, $6);
  };
  | KEYWORD_IF LPAREN expr RPAREN COLON stmts KEYWORD_ELSE COLON stmts KEYWORD_ENDIF SEMICOLON
  {
    $$ = template("if (%s):\n%selse:\n%sendif;\n", $3, $6, $9);
  };

func_call:
  IDENTIFIER LPAREN expr_list RPAREN
{
  $$ = template("%s(%s)", $1, $3);
};







/*
*                  GENERAL
* */
arr_index:
  expr













%%

int main() {
  if (yyparse() == 0)
    printf("\nAccepted!\n");
  else
    printf("\nRejected!\n");
}
