%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <stdarg.h>

const char *c_prologue =
    "#include \"lambdalib.h\"\n"
    "#include <math.h>\n";
extern FILE* yyin;
extern char* print_line_n(FILE *fp, int n);
extern int yylex(void);
extern char* replaceWord(const char* s, const char* oldW, const char* newW);
extern char* concat(const char *s1, const char *s2);
int yyerror_count = 0;
void yyerror(char const *pat, ...);
char *template(const char *pat, ...);
extern int lineNum;
int next_avail = 0;
char* comp_func_names[100];
char* comp_func_headers[100];

typedef struct sstream
{
  char *buffer;
  size_t bufsize;
  FILE* stream;
} sstream;

void ssopen(sstream *S) { S->stream = open_memstream(&S->buffer, &S->bufsize); }

char *ssvalue(sstream *S) {
  fflush(S->stream);
  return S->buffer;
}

void ssclose(sstream *S) { fclose(S->stream); }

char *replaceChar(char* const source, char toBeReplaced, char replacer) {
  for (int i = 0; i < strlen(source); ++i) {
    if (source[i] == toBeReplaced) {
      source[i] = replacer;
    }
  }
  return source;
}


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

%type<str> func_decl
%type<str> func_header
%type<str> func_body
%type<str> func_end
%type<str> func_param_list
%type<str> func_arg
%type<str> func_arg_name

%type<str> primitive_dt
%type<str> bool_dt

%type<str> var_decl_list
%type<str> var_decl
%type<str> var_name
%type<str> var_type

%type<str> comp_decl
%type<str> comp_var_decl_rec
%type<str> comp_var_decl
%type<str> comp_var_decl_list
%type<str> comp_var_name
%type<str> comp_func_decl_rec
%type<str> comp_func_body
%type<str> comp_var_name_
%type<str> comp_func_decl
%type<str> comp_func_header
%type<str> comp_func_param_list
%type<str> comp_expr
%type<str> comp_operand
%type<str> comp_expr_list
%type<str> comp_stmt
%type<str> comp_stmts
%type<str> comp_if_stmt
%type<str> comp_return_stmt
%type<str> comp_while_stmt
%type<str> comp_for_stmt
%type<str> comp_assign_stmt
%type<str> comp_range_comprehension
%type<str> comp_arr_comprehension
%type<str> comp_func_call
%type<str> comp_var_name_extended
%type<str> comp_var_type

%type<str> const_decl

%type<str> expr
%type<str> operand
%type<str> expr_list
%type<str> period_expr_list

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

%%


/*
*                 INPUT PROGRAM
* */
input:
  comp_decl_rec
  const_decl_rec
  var_decl_rec
  func_decl_rec
  main_func
  {
    puts(template("%s", c_prologue));
    puts(template("%s%s%s%s%s", $1, $2, $3, $4, $5));
  };














/*
*                 RECURSIVE BASIC COMPONENTS
* */
func_decl_rec:
  %empty
  {
    $$ = "";
  };
  | func_decl_rec func_decl
  {
    $$ = template("%s\n%s\n", $1, $2);
  };

var_decl_rec:
  %empty
  {
    $$ = "";
  };
  | var_decl_rec var_decl
  {
    $$ = template("%s\n%s\n", $1, $2);
  };

const_decl_rec:
  %empty
  {
    $$ = "";
  };
  | const_decl_rec const_decl
  {
    $$ = template("%s\n%s\n", $1, $2);
  };

comp_decl_rec:
  %empty
  {
    $$ = "";
  };
  | comp_decl_rec comp_decl
  {
    $$ = template("%s\n%s\n", $1, $2);
  };


/*
*                  MAIN FUNCTION
* */

main_func:
  main_header func_body func_end
  {
    $$ = template("%s%s%s", $1, $2, $3);
  };

main_header:
  KEYWORD_DEF KEYWORD_MAIN LPAREN RPAREN COLON
  {
    $$ = "int main() {\n";
  };



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
    $$ = template("void %s(%s) {\n", $2, $4);
  };
  | KEYWORD_DEF IDENTIFIER LPAREN func_param_list RPAREN MINUS GT var_type COLON
  {
    $$ = template("%s %s(%s) {\n", $8, $2, $4);
  };

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
  func_arg_name COLON var_type
  {
    $$ = template("%s %s", $3, $1);
  };

func_arg_name:
  IDENTIFIER
  | IDENTIFIER LBRACKET RBRACKET
  {
    $$ = template("%s[]", $1);
  };

func_body:
  const_decl_rec var_decl_rec stmts
  {
    $$ = template("%s%s%s", $1, $2, $3);
  };

func_end:
  KEYWORD_ENDDEF SEMICOLON
  {
    $$ = "}\n";
  };



/*
*                  VARIABLES
* */
var_decl:
  var_decl_list COLON primitive_dt SEMICOLON
  {
    $$ = template("%s %s;", $3, $1);
  }
  | var_decl_list COLON IDENTIFIER SEMICOLON
  {
    $$ = template("%s %s = ctor_%s;", $3, $1, $3);
  };

var_decl_list:
  var_name
  | var_decl_list COMMA var_name
  {
    $$ = template("%s, %s", $1, $3);
  };

var_name:
  IDENTIFIER
  | IDENTIFIER LBRACKET expr RBRACKET
  {
    $$ = template("%s[%s]", $1, $3);
  };

var_type:
  primitive_dt
  | IDENTIFIER



/*
*                  DATA TYPES
* */
primitive_dt:
  KEYWORD_SCALAR
  {
    $$ = "double";
  };
  | KEYWORD_INTEGER
  {
    $$ = "int";
  };
  | KEYWORD_STR
  {
    $$ = "char*";
  };
  | KEYWORD_BOOL
  {
    $$ = "int";
  };

bool_dt:
  KEYWORD_TRUE
  {
    $$ = "1";
  };
  | KEYWORD_FALSE
  {
    $$ = "0";
  };



/*
*                  COMP TYPE
* */
comp_decl:
  KEYWORD_COMP IDENTIFIER COLON
  comp_var_decl_rec
  comp_func_decl_rec
  KEYWORD_ENDCOMP SEMICOLON
  {
    char* type_name = $2;
    char* vars = $4;
    char* funcs = $5;
    $$ = template("#define SELF struct %s *self\n", type_name);
    strcat($$, template("typedef struct %s {\n", type_name));
    strcat($$, template("%s\n", vars));

    if (next_avail > 0) {
      for (int i = 0; i < next_avail; i++) {
        strcat($$, template("%s\n", comp_func_headers[i]));
      }
      strcat($$, template("} %s;\n", type_name));
      strcat($$, template("%s\n", funcs));
      strcat($$, template("const %s ctor_%s = {", type_name, type_name));
      for (int i = 0; i < next_avail; i++) {
        strcat($$, template(".%s = %s", comp_func_names[i], comp_func_names[i]));
        if (i == next_avail-1) break;
        strcat($$, ", ");
      }
      strcat($$, template("};", type_name, type_name));
    }
    strcat($$, "\n#undef SELF\n");
    next_avail = 0;
  };

comp_func_decl_rec:
  %empty
  {
    $$ = "";
  };
  | comp_func_decl_rec comp_func_decl
  {
    $$ = template("%s\n%s\n", $1, $2);
  };

comp_func_decl:
  comp_func_header comp_func_body func_end
  {
    $$ = template("%s%s%s", $1, $2, $3);
  };

comp_func_body:
  const_decl_rec var_decl_rec comp_stmts
  {
    $$ = template("%s%s%s", $1, $2, $3);
  };

comp_func_header:
  KEYWORD_DEF IDENTIFIER LPAREN comp_func_param_list RPAREN COLON
  {
    $$ = template("void %s(SELF%s) {\n", $2, $4);
    comp_func_names[next_avail] = $2;
    comp_func_headers[next_avail] = template("void (*%s) (SELF%s);\n", $2, $4);
    next_avail++;
  };
  | KEYWORD_DEF IDENTIFIER LPAREN comp_func_param_list RPAREN MINUS GT var_type COLON
  {
    $$ = template("%s %s(SELF%s) {\n", $8, $2, $4);
    comp_func_names[next_avail] = $2;
    comp_func_headers[next_avail] = template("%s (*%s) (SELF%s);\n", $8, $2, $4);
    next_avail++;
  };

comp_func_param_list:
  %empty
  {
    $$ = "";
  };
  | func_arg
  {
    $$ = template(", %s", $1);
  };
  | comp_func_param_list COMMA func_arg
  {
    $$ = template("%s, %s", $1, $3);
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
  comp_var_decl_list COLON comp_var_type SEMICOLON
  {
    $$ = template("%s %s;", $3, $1);
  };

comp_var_type:
  primitive_dt
  | IDENTIFIER
  {
//    comp_func_names[next_avail] = concat("ctor_", strdup($1));
//    next_avail++;
  };


comp_var_decl_list:
  comp_var_name_
  | comp_var_decl_list COMMA comp_var_name_
  {
    $$ = template("%s, %s", $1, $3);
  };

comp_var_name_:
  HASHTAG var_name
  {
    $$ = template("%s", $2);
  };

comp_var_name:
  HASHTAG IDENTIFIER
  {
    $$ = template("self->%s", $2);
  };
  | var_name
  | HASHTAG IDENTIFIER LBRACKET comp_expr RBRACKET
  {
    $$ = template("self->%s[self->%s]", $2, $4);
  };

comp_var_name_extended:
  comp_var_name
  | comp_var_name_extended PERIOD comp_var_name
  {
    $$ = template("%s.%s", $1, $3);
  };

comp_stmts:
  comp_stmt
  {
    $$ = template("%s", $1);
  };
  | comp_stmts comp_stmt
  {
    $$ = template("%s%s", $1, $2);
  };

comp_stmt:
  empty_stmt
  | comp_if_stmt
  | comp_func_call SEMICOLON
  {
    $$ = template("%s;\n", $1);
  };
  | comp_return_stmt
  | break_stmt
  | continue_stmt
  | comp_while_stmt
  | comp_for_stmt
  | comp_assign_stmt
  | comp_range_comprehension
  | comp_arr_comprehension

comp_range_comprehension:
  comp_var_name COLON_ASSIGN LBRACKET comp_expr KEYWORD_FOR comp_var_name COLON INTEGER RBRACKET COLON var_type SEMICOLON
  {
    char* new_array = $1;
    char* expr = $4;
    char* elm = $6;
    char* size = $8;
    char* new_type = $11;
    $$ = template("%s* %s = (%s*)malloc(%s * sizeof(%s));\n", new_type, new_array, new_type, size, new_type);
    strcat($$, template("for (int %s = 0; %s < %s; ++%s)\n", elm, elm, size, elm));
    strcat($$, template("\t%s[%s] = %s;\n", new_array, elm, expr));
  };

comp_arr_comprehension:
  comp_var_name COLON_ASSIGN LBRACKET comp_expr KEYWORD_FOR comp_var_name COLON var_type KEYWORD_IN comp_var_name KEYWORD_OF INTEGER RBRACKET COLON var_type SEMICOLON
  {
    char* new_array = $1;
    char* expr = $4;
    char* elm = $6;
    char* type = $8;
    char* array = $10;
    char* array_ = strdup(array);
    strcat(array_, "[array_i]");
    char* size = $12;
    char* new_type = $15;
    $$ = template("%s* %s = (%s*)malloc(%s * sizeof(%s));\n", new_type, new_array, new_type, size, new_type);
    strcat($$, template("for (int array_i "));
    strcat($$, template("= 0; array_i < %s; ++array_i)\n", size));
    strcat($$, template("\t%s[array_i] = %s;\n", new_array, replaceWord(expr, elm, array_)));
  };

comp_for_stmt:
  KEYWORD_FOR comp_var_name KEYWORD_IN LBRACKET comp_expr COLON comp_expr COLON comp_expr RBRACKET COLON comp_stmts KEYWORD_ENDFOR SEMICOLON
  {
    $$ = template("for (int %s = %s; %s < %s; %s += %s) {\n%s}\n", $2, $5, $2, $7, $2, $9, $12);
  };
  | KEYWORD_FOR comp_var_name KEYWORD_IN LBRACKET comp_expr COLON comp_expr RBRACKET COLON comp_stmts KEYWORD_ENDFOR SEMICOLON
  {
    $$ = template("for (int %s = %s; %s < %s; %s++) {\n%s}\n", $2, $5, $2, $7, $2, $10);
  };

comp_while_stmt:
  KEYWORD_WHILE LPAREN comp_expr RPAREN COLON comp_stmts KEYWORD_ENDWHILE SEMICOLON
  {
    $$ = template("while (%s) {\n%s}\n", $3, $6);
  };

comp_assign_stmt:
  comp_var_name ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s = %s;\n", $1, $3);
  }
  | comp_var_name PLUS_ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s += %s;\n", $1, $3);
  }
  | comp_var_name MINUS_ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s -= %s;\n", $1, $3);
  }
  | comp_var_name MULT_ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s *= %s;\n", $1, $3);
  }
  | comp_var_name DIV_ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s /= %s;\n", $1, $3);
  }
  | comp_var_name MOD_ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s %%= %s;\n", $1, $3);
  }
  | comp_var_name COLON_ASSIGN comp_expr SEMICOLON
  {
    $$ = template("%s := %s;\n", $1, $3);
  };

comp_return_stmt:
  KEYWORD_RETURN SEMICOLON
  {
    $$ = "return;\n";
  };
  | KEYWORD_RETURN comp_expr SEMICOLON
  {
    $$ = template("return %s;\n", $2);
  };

comp_if_stmt:
  KEYWORD_IF LPAREN comp_expr RPAREN COLON comp_stmts KEYWORD_ENDIF SEMICOLON
  {
    $$ = template("if (%s) {\n%s}\n", $3, $6);
  };
  | KEYWORD_IF LPAREN comp_expr RPAREN COLON comp_stmts KEYWORD_ELSE COLON comp_stmts KEYWORD_ENDIF SEMICOLON
  {
    $$ = template("if (%s) {\n%s}\nelse {\n%s}\n", $3, $6, $9);
  };

comp_func_call:
  comp_var_name_extended LPAREN comp_expr_list RPAREN
{
//  $$ = template("%s(&self->%s%s)", $1, $1, $3);
  $$ = template("%s(%s)", $1, $3);
};

comp_expr_list:
  %empty
  {
    $$ = "";
  };
  | comp_expr
  | comp_expr_list COMMA comp_expr
  {
    $$ = template("%s, %s", $1, $3);
  };

comp_expr:
  comp_operand
  | comp_expr PLUS comp_expr
  {
    $$ = template("%s + %s", $1, $3);
  };
  | comp_expr MINUS comp_expr
  {
    $$ = template("%s - %s", $1, $3);
  };
  | comp_expr MULT comp_expr
  {
    $$ = template("%s * %s", $1, $3);
  };
  | comp_expr DIV comp_expr
  {
    $$ = template("%s / %s", $1, $3);
  };
  | comp_expr MOD comp_expr
  {
    $$ = template("%s", $1);
    strcat($$, " % ");
    strcat($$, template("%s", $3));
  };
  | comp_expr GT comp_expr
  {
    $$ = template("%s > %s", $1, $3);
  };
  | comp_expr LT comp_expr
  {
    $$ = template("%s < %s", $1, $3);
  };
  | comp_expr GEQ comp_expr
  {
    $$ = template("%s >= %s", $1, $3);
  };
  | comp_expr LEQ comp_expr
  {
    $$ = template("%s <= %s", $1, $3);
  };
  | comp_expr EQ comp_expr
  {
    $$ = template("%s == %s", $1, $3);
  };
  | comp_expr NEQ comp_expr
  {
    $$ = template("%s != %s", $1, $3);
  };
  | comp_expr KEYWORD_AND comp_expr
  {
    $$ = template("%s && %s", $1, $3);
  };
  | comp_expr KEYWORD_OR comp_expr
  {
    $$ = template("%s || %s", $1, $3);
  };
  | KEYWORD_NOT comp_expr
  {
    $$ = template("! %s", $2);
  };
  | PLUS comp_expr
  {
    $$ = template("+%s", $2);
  };
  | MINUS comp_expr
  {
    $$ = template("-%s", $2);
  };
  | comp_expr POW comp_expr
  {
    $$ = template("pow(%s, %s)", $1, $3);
  };
  | LPAREN comp_expr RPAREN
  {
    $$ = template("(%s)", $2);
  };
//  | expr PERIOD expr
//  {
//    $$ = template("%s.%s", $1, $3);
//  };

comp_operand:
  comp_var_name_extended
  | comp_func_call
  | INTEGER
  | FLOAT
  | bool_dt
  | CONST_STRING
  {
    $$ = template("\"%s\"", $1);
  };









/*
*                  CONST
* */
const_decl:
  KEYWORD_CONST IDENTIFIER ASSIGN expr COLON primitive_dt SEMICOLON
  {
    $$ = template("const %s %s = %s;", $6, $2, $4);
  };




/*
*                  EXPRESSIONS - OPERANDS
* */
expr:
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
    $$ = template("%s && %s", $1, $3);
  };
  | expr KEYWORD_OR expr
  {
    $$ = template("%s || %s", $1, $3);
  };
  | KEYWORD_NOT expr
  {
    $$ = template("! %s", $2);
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
    $$ = template("pow(%s, %s)", $1, $3);
  };
  | LPAREN expr RPAREN
  {
    $$ = template("(%s)", $2);
  };
//  | expr PERIOD expr
//  {
//    $$ = template("%s.%s", $1, $3);
//  };

operand:
  var_name
  | func_call
  | INTEGER
  | FLOAT
  | bool_dt
  | CONST_STRING
  {
    $$ = template("\"%s\"", $1);
  };

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
    char* new_array = $1;
    char* expr = $4;
    char* elm = $6;
    char* size = $8;
    char* new_type = $11;
    $$ = template("%s* %s = (%s*)malloc(%s * sizeof(%s));\n", new_type, new_array, new_type, size, new_type);
    strcat($$, template("for (int %s = 0; %s < %s; ++%s)\n", elm, elm, size, elm));
    strcat($$, template("\t%s[%s] = %s;\n", new_array, elm, expr));
  };

arr_comprehension:
  var_name COLON_ASSIGN LBRACKET expr KEYWORD_FOR var_name COLON var_type KEYWORD_IN var_name KEYWORD_OF INTEGER RBRACKET COLON var_type SEMICOLON
  {
    char* new_array = $1;
    char* expr = $4;
    char* elm = $6;
    char* type = $8;
    char* array = $10;
    char* array_ = strdup(array);
    strcat(array_, "[array_i]");
    char* size = $12;
    char* new_type = $15;
    $$ = template("%s* %s = (%s*)malloc(%s * sizeof(%s));\n", new_type, new_array, new_type, size, new_type);
    strcat($$, template("for (int array_i "));
    strcat($$, template("= 0; array_i < %s; ++array_i)\n", size));
    strcat($$, template("\t%s[array_i] = %s;\n", new_array, replaceWord(expr, elm, array_)));
  };

for_stmt:
   KEYWORD_FOR var_name KEYWORD_IN LBRACKET expr COLON expr COLON expr RBRACKET COLON stmts KEYWORD_ENDFOR SEMICOLON
  {
    $$ = template("for (int %s = %s; %s < %s; %s += %s) {\n%s}\n", $2, $5, $2, $7, $2, $9, $12);
  };
  | KEYWORD_FOR var_name KEYWORD_IN LBRACKET expr COLON expr RBRACKET COLON stmts KEYWORD_ENDFOR SEMICOLON
  {
    $$ = template("for (int %s = %s; %s < %s; %s++) {\n%s}\n", $2, $5, $2, $7, $2, $10);
  };

while_stmt:
  KEYWORD_WHILE LPAREN expr RPAREN COLON stmts KEYWORD_ENDWHILE SEMICOLON
  {
    $$ = template("while (%s) {\n%s}\n", $3, $6);
  };

assign_stmt:
  var_name ASSIGN expr SEMICOLON
  {
    $$ = template("%s = %s;\n", $1, $3);
  }
  | var_name PLUS_ASSIGN expr SEMICOLON
  {
    $$ = template("%s += %s;\n", $1, $3);
  }
  | var_name MINUS_ASSIGN expr SEMICOLON
  {
    $$ = template("%s -= %s;\n", $1, $3);
  }
  | var_name MULT_ASSIGN expr SEMICOLON
  {
    $$ = template("%s *= %s;\n", $1, $3);
  }
  | var_name DIV_ASSIGN expr SEMICOLON
  {
    $$ = template("%s /= %s;\n", $1, $3);
  }
  | var_name MOD_ASSIGN expr SEMICOLON
  {
    $$ = template("%s %%= %s;\n", $1, $3);
  }
  | var_name COLON_ASSIGN expr SEMICOLON
  {
    $$ = template("%s := %s;\n", $1, $3);
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
    $$ = template("if (%s) {\n%s}\n", $3, $6);
  };
  | KEYWORD_IF LPAREN expr RPAREN COLON stmts KEYWORD_ELSE COLON stmts KEYWORD_ENDIF SEMICOLON
  {
    $$ = template("if (%s) {\n%s}\nelse {\n%s}\n", $3, $6, $9);
  };

func_call:
  var_name LPAREN expr_list RPAREN
  {
    $$ = template("%s(%s)", $1, $3);
  }
  | var_name PERIOD var_name LPAREN period_expr_list RPAREN
  {
    $$ = template("%s.%s(&%s%s)", $1, $3, $1, $5);
  };

period_expr_list:
  %empty
  {
    $$ = "";
  };
  | expr
  {
    $$ = template(", %s", $1);
  };
  | period_expr_list COMMA expr
  {
    $$ = template(", %s, %s", $1, $3);
  };
%%

int main() {
  if (yyparse() == 0) {}
//    printf("\nAccepted!\n");
  else
    printf("\nRejected!\n");
}

void yyerror(char const *pat, ...) {
  fprintf(stderr, "Syntax error in line %d: %s\n", lineNum, print_line_n(yyin, lineNum));
  yyerror_count++;
}

char *template(const char *pat, ...) {
  sstream S;
  ssopen(&S);

  va_list arg;
  va_start(arg, pat);
  vfprintf(S.stream, pat, arg);
  va_end(arg);

  char *ret = ssvalue(&S);
  ssclose(&S);
  return ret;
}