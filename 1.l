title 1a : Lex Pgm to count number of words lines and chars
%{
#include<stdio.h>
int w=0,l=0,c=0,s=0;
%}
%%
[^ \t\n#] {w++;c+=yyleng;}
\n {l++;}
[ ] {s++;}
\t {s+=4;}
# {return 0;}
%%
int yywrap()
{
return 1;
}
int main()
{
printf("enter string \n");
yylex();
printf("words %d,line %d,char %d,space %d",w,l,c,s);
return 0;
}

 --------------------------
title 1b : YACC pgm to recognize a^n b^(m+n)c^n
%{
#include "y.tab.h"
%}
%%
"a" {return 'a';}
"b" {return 'b';}
"c" {return 'c';}
. {return yytext[0];}
\n {return 0;}
%%
int yywrap()
{
return 1;
}
 --------------------------
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int error=0;
int yyerror(char *s);
int yylex();
%}
%%
S:A B
;
A:'a'A'b';
|
;
B:'b'B'c';
|
;

%%

int main()
{
printf("enter string \n");
yyparse();
if(error){
printf("invalid");
}
else{
printf("valid");
}
return 0;
}
int yyerror(char *s)
{
error=1;
return 1;
}
================================================
title 2a : Lex pgm to count +ive and -ive integers / fractions
%{
#include<stdio.h>
int pi=0,ni=0,pf=0,nf=0;
%}
%%
[+]?[0-9]+ {pi++;}
[-][0-9]+ {ni++;}
[0-9]*[.][0-9]+ {pf++;}
[-][0-9]*[.][0-9]+ {nf++;}
[0-9]*[.]*[0-9]+[/][0-9]*[.]*[0-9]+ {pf++;}
[-][0-9]*[.]*[0-9]+[/][-][0-9]*[.]*[0-9]+ {pf++;}
[-][0-9]*[.]*[0-9]+[/][0-9]*[.]*[0-9]+ {nf++;}
[0-9]*[.]*[0-9]+[/][-][0-9]*[.]*[0-9]+ {nf++;}
\n {return 0;}
%%
int yywrap(){
return 1;
}
int main(){
printf("enter fraction");
yylex();
printf("Positive integers: %d\n", pi);
printf("Negative integers: %d\n", ni);
printf("Positive fractions: %d\n", pf);
printf("Negative fractions: %d\n", nf);
return 0;
}
 --------------------------
title 2b : YACC to validate  evaluate an arithmetic expression
%{
#include "y.tab.h"
%}
%%
[0-9]+ {yylval=atoi(yytext);return NUM;}
[-+*/] {return yytext[0];}
. {return yytext[0];}
\n {return 0;}
%%

int yywrap()
{
return 1;
}

 --------------------------
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int error=0;
int yyerror();
int yylex();
%}
%token NUM
%left '+' '-'
%left '/' '*'

%%
S:I {printf("res is %d",$$);}
;
I:I'+'I {$$=$1+$3;}
|I'-'I {$$=$1-$3;}
|I'*'I {$$=$1*$3;}
|I'/'I {if($3==0) {yyerror();}
else {$$=$1/$3;}}
|'('I')' {$$=$2;}
|NUM {$$=$1;}
|'-'NUM {$$=-$1;}
;
%%

int main()
{
printf("enter exp\n");
yyparse();
if(error){
printf("invalid");
}
else{
printf("valid");
}
return 0;
}
int yyerror()
{

error=1;
return 0;
}
================================================
title 3a : Lex to count comment lines and remove into another file
%{

#include<stdio.h>

int flag=0;

int c=0;

int flg=0;

%}

%%

"//".* {
if(flag==1) {
fprintf(yyout," ");
flg--;
}
else{
c++;
fprintf(yyout," ");
flg++;
}
}

"/*".*\n?"*/"? {
if(flg==1){
fprintf(yyout," ");
}
else {
flag++;
fprintf(yyout," ");
c++;}}

.*"*/" {if(flag==1){ fprintf(yyout," "); c++;flag--;}}

%%

int main()

{

yyin= fopen("v.txt","r");

yyout = fopen("v1.txt","w");

yylex();

printf("Number of comment lines=%d",c);

}
int yywrap()

{
return 1;
}
 --------------------------
title 3b : Yacc to recognize / count Nested FOR loops
%{

#include "y.tab.h"

%}

%%

"for" { return FOR; }

"(" { return LPAREN; }

")" { return RPAREN; }

"{" { return LF; }

"}" { return RF; }

"=" { return '='; }

"-" { return '-'; }

"+" { return '+'; }

">" { return '>'; }

"<" { return '<'; }

";" { return ';'; }

"==" { return EQ; }

"<=" { return LE; }

">=" { return GE; }

"+=" { return ADDEQ; }

"-=" { return SUBEQ; }

"++" { return INC; }

"--" { return DEC; }

[a-zA-Z]+ { return ALPH; }

[0-9]+ { return NUM; }

[ \t] { /* Ignore */ }

\n { return 0; }

. { /* Ignore */ }

%%

int yywrap(){

return 1;

}
 --------------------------
%{

#include <stdio.h>
#include <stdlib.h>
int yylex();
int count = 0;
int error=0;
int yyerror();

%}

%token FOR LPAREN RPAREN LF RF ALPH NUM EQ LE GE ADDEQ SUBEQ INC DEC

%%
S : I
;
I : FOR A B { count++; }
;
A : LPAREN E ';' E ';' E RPAREN
;
E : ALPH Z NUM
| ALPH Z ALPH
| ALPH U
| /* empty */ /* Handling space as an empty rule

*/

;

Z : '='

| '>'

| '<'
| LE /* Placeholder for '<=' */
| GE /* Placeholder for '>=' */
| EQ /* Placeholder for '==' */
| ADDEQ /* Placeholder for '+=' */
| SUBEQ /* Placeholder for '-=' */
;
U : INC /* Placeholder for '++' */
| DEC /* Placeholder for '--' */
;
B : LF B RF
| I
| ALPH
| ALPH I
| /* empty */
;
%%
int main() {
yyparse();
if(error){
printf("error");
}
else{
printf("valid");
}
printf("Number of nested FOR's are: %d\n", count);
return 0;
}

int yyerror() {
error=1;
return 0;
}
================================================
title 4a : Lex to count indetifiers operators and keywords


%{

#include<stdio.h>

int i=0,k=0,op=0;

%}

%%

auto|break|case|char|continue|do|default|const|double|else|enum|extern|for|if|goto|float|int|long|register|return|signed|static|sizeof|short|struct|switch|typedef|union|void|while|volatile|unsigned { }

("/"[^\"]*"/") { k++;}

("_"|[a-z]|[A-Z])("_"|[a-z]|[A-Z]|[0-9])* {i++;}

"#include".* ;

"#"[a-zA-Z]+.* ;

[;] ;

[ ] ;

[,] ;

[+*%/-] {op++;}

[\n] ;

%%

void main()

{

yyin=fopen("d.c","r");

yylex();

printf("No. of identifiers=%d\n,keywords=%d,operators=%d",i,k,op);

}

int yywrap()

{ return 1;

}
 --------------------------
title 4b : YACC to recognize/ count nested IF statements
%{
#include "y.tab.h"
%}

%%
"if" {return IF;}
"else" {return ELSE;}
[(] {return LPAREN;}
[)] {return RPAREN;}
[{] {return LF;}
[}] {return RF;}
[a-z]* {return EXP;}
[ ]  {return SPACE;}
\n   {return 0;}
%%

 --------------------------
%{
#include<stdio.h>
#include<stdlib.h>
int count=0;
int error=0;
int yyerror();
int yylex();
%}

%token IF ELSE LPAREN RPAREN LF RF EXP SPACE
%%
S:I
;
I:IF E B {count++;}
;
E:LPAREN EXP RPAREN
;
B:LF B RF
|I
|EXP
|EXP SPACE I
|
;

%%
int main()
{
yyparse();
if(error){
printf("no");
}
else{
printf("valid");
printf("no. of nested IF's are: %d\n",count);
}

return 0;

}

int yyerror()
{
error=1;
return 0;
}

================================================
title 5 : YACC to recognize declaration and display variables
%{
#include "y.tab.h"
%}

%%
"int" { return INT; }
"float" { return FLOAT; }
"char" { return CHAR; }
"double" { return DOUBLE; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+ {return NUM;}
"[" { return '['; }
"]" { return ']'; }
"," { return ','; }
";" { return ';'; }
[ \t\n] { /* Ignore whitespace */ }
. { /* Ignore any other characters */ }

%%
int yywrap() {
return 1;
}

 --------------------------
%{
#include <stdio.h>
#include <stdlib.h>
int var_count = 0;
void yyerror(const char *s);
int yylex();
%}

%union {
char *str;
}

%token <str> IDENTIFIER
%token INT FLOAT CHAR DOUBLE NUM

%%
program: declarations
;

declarations: declaration ';'
| declarations declaration ';'
;

declaration: type var_list
;

type: INT
| FLOAT
| CHAR
| DOUBLE
;

var_list: var
| var_list ',' var
;
var: identifier
| identifier '[' ']' // Matches array without size
| identifier '[' NUM ']' // Matches array with size
;
identifier: IDENTIFIER
{
var_count++;
}
;
%%

void yyerror(const char *s) {
fprintf(stderr, "Error: %s\n", s);
}

int main() {
yyparse();
printf("Total number of variables declared: %d\n", var_count);
return 0;
}

================================================
title 8 : YACC to generate assembly language code for arithmentic expn
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

DIGIT [0-9]
ID [a-zA-Z][a-zA-Z0-9]*
WS [ \t\n]
STRING \"[^"]*\"

%%
"int" { return INT; }
"main" { return MAIN; }
"printf" { return PRINTF; }
{STRING} { yylval.str = strdup(yytext); return STRING; }
{ID} { yylval.id = strdup(yytext); return ID;}
{DIGIT}+ { yylval.num = atoi(yytext); return NUM;}
"+" { return ADD; }
"=" { return ASSIGN; }
"(" { return LPAREN; }
")" { return RPAREN; }
";" { return SEMI; }
"," { return COMMA; }
"{" { return LBRACE; }
"}" { return RBRACE; }
{WS} ; /* ignore whitespace */
%%
int yywrap() {
return 1;
}

 --------------------------
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;

void yyerror(const char* s) {
fprintf(stderr, "Error: %s at line %d\n", s,yylineno);
exit(1);
}
%}

%union {
char* id;
int num;
char* str;
}

%token <id> ID
%token <num> NUM
%token <str> STRING
%token INT MAIN PRINTF ADD LPAREN RPAREN SEMI COMMA LBRACE RBRACE ASSIGN
%start program
%%

program:

INT MAIN LPAREN RPAREN LBRACE stmt_list RBRACE

{
printf(".data\n");
printf(".LC0: .string \"Sum %%d\"\n");
printf(".text\n");
printf(".globl main\n");
printf("main:\n");
}
;

stmt_list:

stmt
| stmt_list stmt
;

stmt:

INT ID ASSIGN NUM SEMI {
printf(" movl $%d, %s\n", $4, $2);
}

| ID ASSIGN ID ADD ID SEMI {
printf("movl %s, %%eax\n", $3);
printf("addl %s, %%eax\n", $5);
printf("movl %%eax, %s\n", $1);
}

| PRINTF LPAREN STRING COMMA ID RPAREN SEMI {
printf("movl %s, %%edi\n", $5); 
printf("movl $.LC0, %%rsi\n"); 
printf("call printf\n"); // Call printf function
}
;
%%

int main() {
printf("Assembly code output:\n");
yyparse();
return 0;
}
----------------------------------------------------------------------------------------------------------
Inputs:
3a)//jsdhg/*fjkjhgjghj
fghgfhghg*/
//jhgdjfhgj
/*mndbfjkhk /*m,jhkdf*/ljdfghlk
*/
/*jhgds//jhgdfjgds
hfdkjkg */
kjsdfhkjhkfjh
..............
4a)input file d.c
#include<stdio.h>
#define max 10
int a,b,gfg;
float vbg;//int b;
/*int a*/
char gfhjk,kjhg;
...........
5. Input.txt:
int a[10], b, c;
float x, y;
char name[50];
double z;
.....................
STEPS:
lex 1a.l||cc lex.yy.c || ./a.out
lex 1a.l || yacc -d 1a.y || cc lex.yy.c y.tab.c -ll || ./a.out
lex 1a.l | yacc 1a.y || cc lex.yy.c y.tab.c -ll || gedit input.txt || gcc -o lex.yy.c y.tab.c -lfl || ./parser < input.txt
same till yacc then instead of a/a.out :echo '#int main() { int a=5; int b=10; a=a+b; printf("sum %d\n",a);}' | ./a.out 
