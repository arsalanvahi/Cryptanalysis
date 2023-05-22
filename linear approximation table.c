#include <stdio.h>
#include <stdlib.h>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */
int sBox[16] = {9, 11, 12, 4, 10, 1, 2, 6, 13, 7, 3, 8, 15, 14, 0, 5};


int approxTable[16][16];

int mask(int value, int mask) //count the number of 0's
{
    int interValue = value & mask;
    int total = 0;
    
    while(interValue > 0)
    {
        int temp = interValue % 2;    
        interValue /= 2;
        
        if (temp == 0) 
            total++;
    } 
    return total;   
}
   


int main(int argc, char *argv[]) {
	int c, m, x; //x: input of the sbox ; m: mask 
    
    for(c = 0; c < 16; c++)                                         //output mask
        for(m = 0; m < 16; m++)                                     //input mask
            for(x = 0; x < 16; x++)                                 //input
                if (mask(x, m) == mask(sBox[x], c))
                    approxTable[m][c]++;  
					  
    for(c = 0; c < 16; c++){
    	 for(m = 0; m < 16; m++){
        	printf("%4d", approxTable[c][m]-8);    
		}
		printf("\n");
	}
	return 0;
}
