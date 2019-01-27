%{
   #include<stdio.h>
   #include<stdlib.h>
   #include<string.h>
   int space = 0;
   char var_datatype[30]; 
   void give_t_space()
   {
      int t = space;
      while(t--)
      {
      printf(" ");
      }
   }
%}

%union {
  int ival;
  float fval;
  char *sval;
}

%token <sval> HEADER
%token <sval> DATATYPE
%token <sval> ARGUMENT
%token <sval> FOR
%token <sval> DO
%token <sval> BLOCK_TYPE
%token <sval> SWITCH
%token <sval> CASE
%token <sval> NAME
%token <sval> BREAK
%token <sval> DEFAULT
%token <sval> LE
%token <sval> GE
%token <sval> EQ
%token <sval> NE
%token <sval> OR
%token <sval> ELSE
%token <sval> AND
%token <sval> NUMBER
%token <sval> CALL_ARGUMENT
%token <sval> FOR_ARGUMENT
%token <sval> BLOCK_ARGUMENT

%right "="
%left OR AND
%left '>' '<' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right UMINUS
%left '!'

%%
S         : HEAD | {exit(0);};

HEAD       : HEADER {printf("%s\n",$1);} S
           | DATATYPE {printf("%s ",$1);} NAME {printf("%s",$1);} ARGUMENT {printf("%s",$1);} FUNC_TYPE
           ;
FUNC_TYPE  : ';' {printf(";\n");} S
           |  BODY S
           ;
BODY       : '{' { printf("\n"); give_t_space(); printf("{\n");space = space + 4; } 
              INNERBODY 
             '}'  {space = space-4;give_t_space();printf("}\n"); } 
           ;

INNERBODY : DATATYPE {strcpy(var_datatype,$1);} DECL_TYPE INNERBODY
          | NAME {give_t_space();printf("%s",$1);} C ';' INNERBODY
          | FOR {give_t_space();printf("%s",$1);} FOR_ARGUMENT {printf("%s",$1);} BODY INNERBODY
          | BLOCK_TYPE {give_t_space();printf("%s",$1);} CALL_ARGUMENT {printf("%s",$1);} BODY INNERBODY
          | DO {give_t_space();printf("%s",$1);} BODY 
            BLOCK_TYPE {give_t_space();printf("%s",$1);} CALL_ARGUMENT {printf("%s ;\n",$1);} ';'INNERBODY
          | ELSE {give_t_space();printf("%s",$1);} BODY INNERBODY
          | BREAK {give_t_space();printf("%s ;\n",$1);}';' INNERBODY
          | SWITCH {give_t_space();printf("switch");} CALL_ARGUMENT {printf("%s",$1);} SWITCH_BODY INNERBODY
          |  
          ;
C         : '=' NUMBER {printf(" = %s;\n",$2);}
          | CALL_ARGUMENT {printf("%s ;\n",$1);}
          | ARGUMENT {printf("%s ;\n",$1);}
          ;
SWITCH_BODY  :  '{' { printf("\n"); give_t_space(); printf("{\n");space = space + 4; } 
                SWITCH_INNERBODY 
                '}'  {space = space-4;give_t_space();printf("}\n"); } 
            ;
SWITCH_INNERBODY : CASE NUMBER {give_t_space();printf("case %s :\n",$1);space = space + 4;}':' 
                  INNERBODY {space = space -4;} SWITCH_INNERBODY
                 | DEFAULT ':' {give_t_space();printf("default :\n");space = space + 4;} INNERBODY {space = space -4;}
                 |
                 ;
DECL_TYPE : NAME {give_t_space(); printf("%s %s ;\n",var_datatype,$1);} TERMINATE
          | NAME {give_t_space(); printf("%s %s ",var_datatype,$1);} '=' NUMBER {printf("= %s;\n",$1);} TERMINATE
          ;
TERMINATE : ',' DECL_TYPE
          | ';'
          ;


%%
#include "lex.yy.c"
extern int yylex();
main() {
    yyparse();
}
