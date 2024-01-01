// version 1.0 11/12/2022
#include <stdio.h>
#include "cipher.h"

#ifdef MYDECRYPT_C
TODO("using Cdecrypt.c");

int
decrypt(char *iobuf, char *bookbuf, int cnt)
{
	unsigned int iotemp;
	unsigned int booktemp;
	unsigned int buftemp;
	unsigned int res;
	int seven_bits = 7;     /* size of character (seven bits)*/
	int eight_bits = 8;     /* size of character (eight bits)*/

	/* iterate through all the characters in iobuf*/
	for (int i=0; i<cnt; i++){
		res=0;
		buftemp=0;
		iotemp= ((unsigned int)*(iobuf +i));
		booktemp= ((unsigned int)*(bookbuf +i));
		iotemp = (iotemp^booktemp);
		/* iterate through all the bits in character*/
		for (int j=0; j<eight_bits; j++){
			if (j!=0)
				buftemp = iotemp>>j;
			else
				buftemp= iotemp;
			
			buftemp =( buftemp&1);
			if(j != seven_bits){
				buftemp = buftemp<<(seven_bits-j);
			}
			res = res+ buftemp;
		}
		/* replace iobuf*/
		*(iobuf +i)= (unsigned char) res;

	}
    return cnt;
}

#elif defined MYDECRYPT_S
TODO("using decrypt.S");
#else
TODO("using solution decrypt");
#endif
