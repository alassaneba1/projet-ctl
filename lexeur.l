%{
    #include "parseur.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
%}

int_type            "int"
return_instr        "return"
main_func           {int_type}{tab}+"main()"{tab}*
if_inst             "if"
else_instr          "else"
while_instr         "while"
entier              0|[1-9][0-9]*
tab                 [ \t]
new_line            [\n]
ident               [a-zA-Z_]*[a-zA-Z]+[a-zA-Z0-9_]*
leq                 "<="
geq                 ">="
eq                  "=="
and                 "&&"
or                  "||"

%%

{or}                {return OR;}
{and}               {return AND;}
{leq}               {return LEQ;}
{geq}               {return GEQ;}
{eq}                {return EQ;}
{if_inst}           {return IF;}
{int_type}          {return INT;}
{return_instr}      {return RETURN;}
{else_instr}        {return ELSE;}
{while_instr}       {return WHILE;}
{main_func}         {return MAIN;}
{entier}            {yylval.int_val = atoi(yytext); return ENTIER;}
{ident}             {strcpy(yylval.string_val, yytext); return IDENT;}
{tab}               ;
{new_line}          {yylineno++;}
.                   {return yytext[0];}

%%
 