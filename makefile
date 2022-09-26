projet_ctl: parseur.tab.o lex.yy.o tpK-tabSymbol.o main.o
	gcc -o projet_ctl parseur.tab.o lex.yy.o tpK-tabSymbol.o main.o

lex.yy.c: lexeur.l
	flex lexeur.l

parseur.tab.c: parseur.y
	bison -d parseur.y

ley.yy.o: lex.yy.c
	gcc -c -Wall lex.yy.c

parseur.tab.o: parseur.tab.c parseur.tab.h
	gcc -c -Wall parseur.tab.c

tpK-tabSymbol.o: tpK-tabSymbol.h tpK-tabSymbol.c
	gcc -c -Wall tpK-tabSymbol.c

main.o: main.c tpK-tabSymbol.h
	gcc -c -Wall main.c

all: 
	projet_ctl

clean:
	rm -f *.o projet_ctl lex.yy.c parseur.tab.*

exec_projet_ctl:
	./projet_ctl < tmp.txt 