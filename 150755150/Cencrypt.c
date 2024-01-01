// version 1.0 11/12/2022
#include <stdio.h>
#include "cipher.h"

#ifdef MYENCRYPT_C
TODO("using Cencrypt.c");

int
encrypt(char *iobuf, char *bookbuf, int cnt)
{
	unsigned int iotemp;       
	unsigned int booktemp;      
	unsigned int buftemp=0;     
	unsigned int res=0;         /* the final reversed bits*/
	int eight_bits=8;
	int move;
	/* iterate through all the characters in iobuf*/
	for (int i=0; i<cnt; i++){
		/* Iterate through all the bits in character*/
		for (int j=0; j<eight_bits; j++){
			buftemp = 1<<j;
			iotemp = (unsigned int)*(iobuf +i);
			/*check if stored bit is shifted correctly*/
			if ((move  =eight_bits-1 -2*j)>0)
				res |= ((iotemp & buftemp) << move);
			else
				res |= ((iotemp & buftemp) >> (move * -1));
		}
		/* set booktemp*/
		booktemp = (unsigned int)*(bookbuf +i);
		res ^= booktemp;
		/* Replace iobuf*/
		*(iobuf +i)= (char)res;
		res =0;
	}
    return cnt;
}

#elif defined MYENCRYPT_S
TODO("using encrypt.S");
#else
TODO("using solution encrypt");
#endif
