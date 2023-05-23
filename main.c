#include <stdio.h>
#include <stdlib.h>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */
unsigned char sbox[16] = {14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7};
int main(int argc, char *argv[]) {
	int counter = 0;
	unsigned char xprim, yprim;
	unsigned char x, y, lambda,mu1,mu2;
	for(lambda=1;lambda<16;lambda++)
		for(y=0;y<16;y++)
			for(x=0;x<16;x++){
				xprim = x ^ lambda;
				yprim = y ^ lambda;
				mu1 = sbox[x] ^ sbox[y];
				mu2 = sbox[xprim] ^ sbox[yprim];
				if(((mu1) != 0) &&  ((mu2) !=0))
					if((mu1) == (mu2)){
						counter++;
						printf("x = %d y = %d lambda = %d and mu1 is = %d\n",x,y,lambda,mu1);

				}
			}
				
	printf("\ncounter = %d",counter);	
	return 0;
}
