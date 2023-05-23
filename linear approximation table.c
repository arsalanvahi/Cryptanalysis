#include <stdio.h>

/*When masking, counting number of zeros has no importance. Your aim is 
to calculate the XOR of the masked bits.

Example:
Let input value be 1111 and mask is 1110
Then you AND these two values: 1111 AND 1110 = 1110
Then you XOR all these values: 1 XOR 1 XOR 1 XOR 0 = 1

Then you do the same thing for the output mask and check if the result 
(which can be either 0 or 1) is the same.

As you can see, this has nothing to do with the number of zeros.

Best regards,*/

int sBox[16] = {9, 11, 12, 4, 10, 1, 2, 6, 13, 7, 3, 8, 15, 14, 0, 5};
int linApproxTable[16][16];
int mask(unsigned char input, unsigned char msk) //count the number of 0's
{
    unsigned char maskedValue = input & msk;
    int mskResult = 0;
    
    while(maskedValue > 0)
    {
        unsigned char tmp = maskedValue % 2;    
        maskedValue /= 2;
        mskResult = mskResult ^ tmp;
        
    }
    return mskResult;   
}
int main(){
	int i,j;
	unsigned char x, xMask,yMask;
	for(yMask=0;yMask<16;yMask++){
		for(xMask=0;xMask<16;xMask++){
			for(x=0;x<16;x++){
				if(mask(x,xMask) == mask(sBox[x],yMask))
					linApproxTable[xMask][yMask]++;
			}
		}
	}
	
	for(i=0;i<16;i++){
		for(j=0;j<16;j++){
			printf("%4d",linApproxTable[i][j]-8);
		
		}
		printf("\n");
	}
	return 0;
}
