#include <stdio.h>
#include <stddef.h>

//Code for finding undistributed bits of sboxes


void distributedDiffTable(); //produce ddt for the desired sbox
void dttTravers(); //Traversing on the ddt Table
void isUndistributed(); //output the whole undistrubted bits

void distributedDiffTable(unsigned char sbox_arr[], int size, unsigned char dtt_arr[][16], int dtt_row, int dtt_column){
	unsigned char x,y; // x is input and y is ouput
	unsigned char deltaX,deltaY; 
	unsigned char xPrim,yPrim;
	
	for(x=0;x<16;x++){
		for(deltaX=0;deltaX<16;deltaX++){
			xPrim = (x ^ deltaX);
			//printf("%d\t",xPrim);
			yPrim = sbox_arr[xPrim];
			//printf("%d\t",yPrim);
			y = sbox_arr[x];
			deltaY = (yPrim ^ y);
			//printf("%d\t",deltaY);
			dtt_arr[deltaX][deltaY]++;
			
		}
	}
	
}


//************************************************************
void findIndices(unsigned char two_arr[][16], int row, int column, unsigned char one_arr[], int size) {
    int rowIndex;
    int columnIndex[16][16]={0};  // Two-dimensional array to store column indices for each row
    int rowCount[16] = {0};  // Array to store the number of non-zero elements in each row
    int index = 0;
    int k =0;
    int i, j;
    unsigned char matrix[16] = {0};
    
    for (i = 0; i < row; i++) {
        rowIndex = 0;  // Reset the row index counter for each row
        for (j = 0; j < column; j++) {
            if (two_arr[i][j] != 0) {
                one_arr[index] = two_arr[i][j];
                columnIndex[i][rowCount[i]] = j;  // Store the column index for the current row
                rowCount[i]++;
                index++;
            }
		
        }
    }
    
    // Print the column indices for each row
    for (i = 0; i < row; i++) {
        printf("Row %d: ", i);
        index = 0;
        for (j = 0; j < rowCount[i]; j++) {
        	printf("%4d", columnIndex[i][j]);
        }
        
        printf("\n");
    }
    
    for (i = 0; i < row; i++) {
        //printf("Row %d: ", i);
        index = 0;
        for (j = 0; j < rowCount[i]; j++) {
        	matrix[index++] = columnIndex[i][j];
        	//printf("%4d", columnIndex[i][j]);
        	//isUndistributed(matrix,rowCount[i]);
        }
        isUndistributed(matrix,rowCount[i]);
        printf("\n");
    }
    
    
    
   
}




//***********************************************************
void isUndistributed(unsigned char one_arr[], int size ){
	
	
	
	int a[4] = {0}, b[4] = {0};	
	int  xPrim;
	int i=0,j=0,k=0;
	printf("\n");
	//for(i=0;i<size;i++)
	//	printf("%4d",one_arr[i]);
	int x0 = one_arr[0];
	
	int c;
	int counter;
	while(x0!=0){
			a[i] = x0%2;
			x0 = x0/2;
			i++;
		}
		
	
	for(counter=1;counter<size;counter++){
		j = 0;
		xPrim = one_arr[counter];
		if(xPrim == 0)
			break;
		while(xPrim != 0){
			
			b[j] = xPrim%2;
			xPrim = xPrim/2;
			j++; 
		}
		for(k=3;k>=0;k--){
			c = (a[k] ^ b[k]);
			if(c==1)
				a[k] = -1;
		}
	}
	for(i=3;i>=0;i--){
		printf("  %2d",a[i]);
		

	}
	
	
}

//**********************************************************
unsigned char sbox[16] ={0,11,12,5,6,1,9,10,3,15,14,8,13,4,2,7};
unsigned char ddt[16][16] = {0};
unsigned char chunkArray[256] = {0};

int main(){
	int i,j;
	
	distributedDiffTable(sbox, 16, ddt, 16, 16);
	printf("Distributed Table is:\n");
	for(i=0;i<16;i++){
		for(j=0;j<16;j++){
			printf("%4d",ddt[i][j]);
		}
		printf("\n");
	}
		
	printf("\nTraverse Table is:\n");
	/*dttTraverse(ddt,16,16); 
	for(i=0;i<16;i++){
		for(j=0;j<16;j++){
			printf("%4d",ddt[i][j]);
		}
		printf("\n");
	}*/
		
	printf("\nList of undistributed bits:\n");
	findIndices(ddt,16,16,chunkArray,256);
	
	return 0;
}
