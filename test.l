%{
#include <stdio.h>
int a[]={1, 2};
	
%}
%option noyywrap
%%
[\t]|[\n]|[ ]		;
%.*			{ printf("Found a comment: %s\n", yytext);}
program		{ if(a[1]>0)
			printf("Found a keyword PROGRAM: %s\n", yytext);
		else
			printf("Found a keyword Program: %s\n", yytext);
		}
if			{ printf("Found a keyword if: %s\n", yytext);}
then			{ printf("Found a keyword then as: %s\n", yytext);}
else			{ printf("Found a keyword else as: %s\n", yytext);}
begin			{ printf("Found a keyword begin as: %s\n", yytext);}
end			{ printf("Found a keyword end as: %s\n", yytext);}
while			{ printf("Found a keyword while as: %s\n", yytext);}
do			{ printf("Found a keyword do as: %s\n", yytext);}
as			{ printf("Found a keyword as as: %s\n", yytext);}
int			{ printf("Found a keyword int: %s\n", yytext);}
bool			{ printf("Found a keyword bool as: %s\n", yytext);}
writeInt			{ printf("Found a procedue WRITEINT as: %s\n", yytext);}
readInt			{ printf("Found a procedure READINT as: %s\n", yytext);}
true			{ printf("Found a keyword true: %s\n", yytext);}
false			{ printf("Found a keyword false: %s\n", yytext);}
var			{ printf("Found a keyword var: %s\n", yytext);}
;			{ printf("Found a symbol SC as: %s\n", yytext);}
:=			{ printf("Found a symbol ASGN as: %s\n", yytext);}
\(			{ printf("Found a symbol LP as: %s\n", yytext);}
\)			{ printf("Found a symbol RP as: %s\n", yytext);}
\*				{ printf("Found a symbol OP2 as: %s\n", yytext);}
^div$				{ printf("Found a symbol OP2 as: %s\n", yytext);}
^mod$				{ printf("Found a symbol OP2 as: %s\n", yytext);}
\+						{ printf("Found a symbol OP3 as: %s\n", yytext);}
\-						{ printf("Found a symbol OP3 as: %s\n", yytext);}
=			{ printf("Found a symbol OP4 as: %s\n", yytext);}
!=			{ printf("Found a symbol OP4 as: %s\n", yytext);}
\<			{ printf("Found a symbol OP4 as: %s\n", yytext);}
\>			{ printf("Found a symbol OP4 as: %s\n", yytext);}
\<=			{ printf("Found a symbol OP4 as: %s\n", yytext);}
\>=			{ printf("Found a symbol OP4 as: %s\n", yytext);}
[1-9][0-9]*|0		{ printf("Found a number: %s\n", yytext); }
[A-Z][A-Z0-9]*		{ printf("Found an identifier as: %s\n", yytext); }
%%
main() {
	// open a file handle to a particular file:
	FILE *myfile = fopen("test.txt", "r");
	// make sure it's valid:
	if (!myfile) {
		printf("I can't open a.snazzle.file!");
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// lex through the input:
	yylex();
}