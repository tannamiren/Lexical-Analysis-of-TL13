%{
#define _XOPEN_SOURCE 500 /* Enable certain library functions (strdup) on linux.  See feature_test_macros(7) */
 
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <string.h>
 int x=0;
 int i;
 int z=0;

struct entry_s {
	char *key;
	char *value;
	struct entry_s *next;
};
 
typedef struct entry_s entry_t;
 
struct hashtable_s {
	int size;
	struct entry_s **table;	
};
 
typedef struct hashtable_s hashtable_t;
 
 
hashtable_t *hashtable;  
 
 

%}
%option noyywrap
%%
[\t]|[\n]|[ ]		;
%.*			{ printf("Found a comment: %s\n", yytext); z++;show();}
program		{ printf("Found a keyword Program: %s\n", yytext); x=5; ht_set( hashtable, yytext, "keyword" ); }
if			{ printf("Found a keyword if: %s\n", yytext);}
then			{ printf("Found a keyword then as: %s\n", yytext);}
else			{ printf("Found a keyword else as: %s\n", yytext);}
begin			{ printf("Found a keyword begin as: %s\n", yytext);}
end			{ printf("Found a keyword end as: %s\n", yytext);z++;show();}
while			{ printf("Found a keyword while as: %s\n", yytext);z++;show();}
do			{ printf("Found a keyword do as: %s\n", yytext);}
as			{ printf("Found a keyword as as: %s\n", yytext);}
int			{ printf("Found a keyword int: %s\n", yytext);}
bool			{ printf("Found a keyword bool as: %s\n", yytext);}
writeInt			{ printf("Found a procedue WRITEINT as: %s\n", yytext);}
readInt			{ printf("Found a procedure READINT as: %s\n", yytext);}
true			{ printf("Found a keyword true: %s\n", yytext);}
false			{ printf("Found a keyword false: %s\n", yytext);}
var			{ printf("Found a keyword var: %s\n", yytext);z++;show();}
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
[1-9][0-9]*|0		{ show();
printf("Found a number: %s\n", yytext); 
sscanf(yytext, "%d", &i);
printf("Number is: %d ", i);
}
[A-Z][A-Z0-9]*		{ printf("Found an identifier as: %s\n", yytext); }
%%
void show(){
printf("hello world***********************____%d", z);
}

/* Create a new hashtable. */
hashtable_t *ht_create( int size ) {
 
	hashtable_t *hashtable = NULL;
	int i;
 
	if( size < 1 ) return NULL;
 
	/* Allocate the table itself. */
	if( ( hashtable = malloc( sizeof( hashtable_t ) ) ) == NULL ) {
		return NULL;
	}
 
	/* Allocate pointers to the head nodes. */
	if( ( hashtable->table = malloc( sizeof( entry_t * ) * size ) ) == NULL ) {
		return NULL;
	}
	for( i = 0; i < size; i++ ) {
		hashtable->table[i] = NULL;
	}
 
	hashtable->size = size;
 
	return hashtable;	
}

/* Hash a string for a particular hash table. */
int ht_hash( hashtable_t *hashtable, char *key ) {
 
	unsigned long int hashval;
	int i = 0;
 
	/* Convert our string to an integer */
	while( hashval < ULONG_MAX && i < strlen( key ) ) {
		hashval = hashval << 8;
		hashval += key[ i ];
		i++;
	}
 
	return hashval % hashtable->size;
}
 
/* Create a key-value pair. */
entry_t *ht_newpair( char *key, char *value ) {
	entry_t *newpair;
 
	if( ( newpair = malloc( sizeof( entry_t ) ) ) == NULL ) {
		return NULL;
	}
 
	if( ( newpair->key = strdup( key ) ) == NULL ) {
		return NULL;
	}
 
	if( ( newpair->value = strdup( value ) ) == NULL ) {
		return NULL;
	}
 
	newpair->next = NULL;
 
	return newpair;
}
 
/* Insert a key-value pair into a hash table. */
void ht_set( hashtable_t *hashtable, char *key, char *value ) {
	int bin = 0;
	entry_t *newpair = NULL;
	entry_t *next = NULL;
	entry_t *last = NULL;
 
	bin = ht_hash( hashtable, key );
 
	next = hashtable->table[ bin ];
 
	while( next != NULL && next->key != NULL && strcmp( key, next->key ) > 0 ) {
		last = next;
		next = next->next;
	}
 
	/* There's already a pair.  Let's replace that string. */
	if( next != NULL && next->key != NULL && strcmp( key, next->key ) == 0 ) {
 
		free( next->value );
		next->value = strdup( value );
 
	/* Nope, could't find it.  Time to grow a pair. */
	} else {
		newpair = ht_newpair( key, value );
 
		/* We're at the start of the linked list in this bin. */
		if( next == hashtable->table[ bin ] ) {
			newpair->next = next;
			hashtable->table[ bin ] = newpair;
	
		/* We're at the end of the linked list in this bin. */
		} else if ( next == NULL ) {
			last->next = newpair;
	
		/* We're in the middle of the list. */
		} else  {
			newpair->next = next;
			last->next = newpair;
		}
	}
}
 
/* Retrieve a key-value pair from a hash table. */
char *ht_get( hashtable_t *hashtable, char *key ) {
	int bin = 0;
	entry_t *pair;
 
	bin = ht_hash( hashtable, key );
 
	/* Step through the bin, looking for our value. */
	pair = hashtable->table[ bin ];
	while( pair != NULL && pair->key != NULL && strcmp( key, pair->key ) > 0 ) {
		pair = pair->next;
	}
 
	/* Did we actually find anything? */
	if( pair == NULL || pair->key == NULL || strcmp( key, pair->key ) != 0 ) {
		return NULL;
 
	} else {
		return pair->value;
	}
	
}

main() {
	// open a file handle to a particular file:
	show();
 hashtable  = ht_create( 65536 );

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

printf("%d\n", x);
	ht_set( hashtable, "key1", "inky" );
	ht_set( hashtable, "key2", "pinky" );
	ht_set( hashtable, "key3", "blinky" );
	ht_set( hashtable, "key4", "floyd" );
 
	printf( "%s\n", ht_get( hashtable, "key1" ) );
	printf( "%s\n", ht_get( hashtable, "key2" ) );
	printf( "%s\n", ht_get( hashtable, "key3" ) );
	printf( "%s\n", ht_get( hashtable, "key4" ) );
 	printf( "%s\n", ht_get( hashtable, "program" ) );
 
	return 0;

}