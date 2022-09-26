#include "tpK-tabSymbol.h"
#include <stdio.h>
#include <stdlib.h>

int yyparse();

int main(void){

    adresse_courant[ADR_GLOB] = adresse_courant[ADR_LOC] = 0;
    typeVar = T_ENTIER;
    contexte = C_GLOBAL;
    curseur = ADR_GLOB;

    creerTSymb();

    if(yyparse()==0){
        printf("\nParsing :: Syntax OK\n");
    }

    afficheTSymb();

    free(tsymb);

    exit(EXIT_SUCCESS);
}
