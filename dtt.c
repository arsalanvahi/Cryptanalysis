#include <stdio.h>
#include <stdlib.h>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */
	
	unsigned char sbox[16]= {14,4,12,1,2,15,11,8,3,10,6,12,5,9,0,7};
	unsigned char dtt[16][16];

int main(int argc, char *argv[]) {
	//initialization
	unsigned char xPrim,yPrim; 
	unsigned char y; //Sbox output
	unsigned char x,deltaX; // x: SBox input 
	unsigned char deltaY;
	int i,j; // counter variables
	
	
	for(x=0;x<16;x++){
		for(deltaX=0;deltaX<16;deltaX++){
			xPrim = x ^ deltaX;
			//printf("%d\t",xPrim);
			yPrim = sbox[xPrim];
			//printf("%d\t",yPrim);
			y = sbox[x];
			deltaY = yPrim ^ y;
			//printf("%d\t",deltaY);
			dtt[deltaX][deltaY]++;
			
		}
	}
	for(i=0;i<16;i++){
		for(j=0;j<16;j++){
			printf("%4d",dtt[i][j]);
		}
		printf("\n");
	
		
	}
	
	return 0;
}
