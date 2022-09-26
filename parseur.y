%{
    #include "tpK-tabSymbol.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int nbre_params = 0, nbre_args = 0, adresse_save, return_adresse_save = 0;
    extern int yylineno;
    int yyerror(const char*);
    int yylex(void);
%}


%union {int int_val; char string_val[48];}
%token LEQ GEQ EQ AND OR INT RETURN IF ELSE WHILE MAIN
%token <string_val> IDENT
%token <int_val> ENTIER
%left '+' '-'
%left '*' '/'
%nonassoc MOINSU PLUSU

%start program /* axiom */

%%

program             : liste_dec liste_def
                    | liste_def
                    ;

liste_dec           : une_dec 
                    | une_dec liste_dec
                    ;

une_dec             : prototype {
                            contexte = C_GLOBAL; 
                            curseur = ADR_GLOB;
                        }
                    | liste_dec_var ';'
                    ;

liste_dec_var       : INT IDENT ',' {ajouterVariable($2);} liste_dec_var
                    | INT IDENT {ajouterVariable($2);}
                    ;

prototype           : INT IDENT {
                            adresse_save = sommet; 
                            return_adresse_save = ajouterFonction($2, 0);
                        } liste_param_func {
                                if(return_adresse_save)
                                    tsymb[adresse_save].complement = nbre_params;
                            } ';' 
                    ;

liste_param_func    : '(' ')' {nbre_params = 0;}
                    | '(' {
                            contexte = C_LOCAL;
                            curseur = ADR_LOC;
                            nbre_params = 0;
                        } liste_param ')' {contexte = C_GLOBAL;}
                    ;

liste_def           : MAIN {
                            contexte = C_FONCTION;
                            curseur = ADR_GLOB;
                            ajouterVariable("main");
                            base = sommet;
	                        adresse_courant[ADR_LOC] = 0;
                            contexte = C_LOCAL;
                            curseur = ADR_LOC;
                        } bloc {sortie_fonction();} liste_def_func
                    | MAIN {
                            contexte = C_FONCTION;
                            curseur = ADR_GLOB;
                            ajouterVariable("main");
                            base = sommet;
	                        adresse_courant[ADR_LOC] = 0;
                            contexte = C_LOCAL;
                            curseur = ADR_LOC;
                        } bloc {sortie_fonction();}
                    ;

liste_param         : INT IDENT {
                            nbre_params++;
                            contexte = C_LOCAL;
                            curseur = ADR_LOC;
                            ajouterVariable($2);
                        } ',' liste_param
                    | INT IDENT {
                            nbre_params++;
                            contexte = C_LOCAL;
                            curseur = ADR_LOC;
                            ajouterVariable($2);
                        }
                    ;

bloc                : '{' liste_instr '}'
                    | '{' bloc '}'
                    | '{' '}'
                    ;

liste_def_func      : une_def_func liste_def_func
                    | une_def_func
                    | /* empty */
                    ;

une_def_func        : INT IDENT {
                            base = sommet;
	                        adresse_courant[ADR_LOC] = 0;
                        } liste_param_func bloc {
                            if(adresse_courant[ADR_LOC] > 0){
                                int tmp = nbre_params - adresse_courant[ADR_LOC];
                                if(tmp < 0) tmp = - tmp;
                            }
                            sortie_fonction();
                        }
                    ;

liste_instr         : une_instr liste_instr
                    | une_instr
                    ;

une_instr           : ';'
                    | liste_dec_var ';'
                    | IDENT '=' exp ';'  
                    | RETURN exp ';'      
                    | appel_func ';'            // appel de fonction
                    | if_else                   // conditionnelle
                    | while_loop                // boucle while
                    | bloc
                    ;

if_else             : IF '(' exp_bool ')' une_instr ELSE une_instr
                    ;

while_loop          : WHILE '(' exp_bool ')' une_instr
                    ;

exp                 : exp_arith
                    | exp_bool
                    ;

exp_arith           : terme '+' exp_arith
                    | terme '-' exp_arith
                    | terme
                    ;

terme               : facteur '*' terme
                    | facteur '/' terme
                    | facteur
                    ;

facteur             : '(' exp_arith ')'
                    | '-' facteur %prec MOINSU
                    | '+' facteur %prec PLUSU
                    | ENTIER
                    | IDENT 
                    | appel_func
                    ;

appel_func          : IDENT '(' ')' {nbre_args = 0;}
                    | IDENT '(' {nbre_args = 0;} args ')'
                    ;

args                : exp {nbre_args++;} ',' args
                    | exp {nbre_args++;}
                    ;

exp_bool            : cond AND exp_bool
                    | cond OR exp_bool
                    | '(' exp_bool ')'
                    | cond
                    ;

cond                : cond_2 '<' cond
                    | cond_2 '>' cond
                    | cond_2 '+' cond
                    | cond_2 '-' cond
                    | cond_2 '*' cond
                    | cond_2 '/' cond
                    | cond_2 LEQ cond
                    | cond_2 GEQ cond
                    | cond_2 EQ cond
                    | cond_2
                    ;

cond_2              : '!' cond_2 
                    | exp_arith
                    ;

%%

int yyerror(const char* msg){
    printf("\nParsing :: Syntax ERROR\n");
    return 1;
}

int yywrap(void){
    return 1;
}