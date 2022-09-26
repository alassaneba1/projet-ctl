#ifndef __TPK_TAB_SYMBOL_H__
#define __TPK_TAB_SYMBOL_H__

typedef enum {C_FONCTION, C_GLOBAL, C_ARG, C_LOCAL} classe_t; 
typedef	enum {T_ENTIER, T_TABLEAU} type_t;
typedef enum {ADR_GLOB, ADR_LOC} curseur_adr_t; // curseur sur l'adresse d'une variable globale ou locale

typedef struct { 	/* selon cm-table-symboles.pdf */
	char *identif; 	/* en général un léxème */
	classe_t classe; /* C_FONCTION, ou contexte de variable : C_GLOBAL, C_LOCAL, C_ARG */
	type_t type; /* source K augmenté de tableaux : T_ENTIER, T_TABLEAU */
	int adresse; 
	int complement; /* ex.: nombre d'argument d'une fonction */
} ENTREE_TSYMB;

#define TAILLE_INITIALE_TSYMB	50 
#define INCREMENT_TAILLE_TSYMB	25

/* Variables globales */
ENTREE_TSYMB *tsymb; 
int maxTSymb, sommet, base;
int adresse_courant[2];
classe_t contexte;
type_t typeVar;
curseur_adr_t curseur;

/* prototypes */
void creerTSymb(void) ;
void agrandirTSymb(void) ;
int erreurFatale(char *message) ; 
void ajouterEntree(char *identif, int classe, int type, int adresse, int complement) ;
int existe(char * id);
void afficheTSymb(void);
void sortie_fonction();
void ajouterVariable(char *identif);
int ajouterFonction(char *identif, int nb_params);

#endif