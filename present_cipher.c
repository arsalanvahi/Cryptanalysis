#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */
//Presnet cipher
//***************************************************************
void keySchedule(uint8_t key[], uint8_t sBox[], uint8_t round){
	int j;
	static int counter = 1;
	//uint8_t round = roundCounter; 
	uint8_t save1;
	uint8_t save2;
	save1  = key[0];
	save2  = key[1];	
	uint8_t i = 0;
	do	{
		key[i] = key[i+2];
		i++;
	}while(i<8);
	key[8] = save1;
	key[9] = save2;
	i = 0;
	save1 = key[0] & 7;								//61-bit left shift
	do{
		key[i] = key[i] >> 3 | key[i+1] << 5;			
		i++;
	}while(i<9);
	key[9] = key[9] >> 3 | save1 << 5;
	key[9] = sBox[key[9]>>4]<<4 | (key[9] & 0xF);	//S-Box application
	if((round+1) % 2 == 1)							//round counter addition
	key[1] ^= 128;
	key[2] = ((((round+1)>>1) ^ (key[2] & 15)) | (key[2] & 240));
	printf("\n");
	printf("Round key %d is: ",counter++);
	for(j=9;j>=0;j--){
		printf("%02hx",key[j]);
	}
	
}

//****************************************************
void addRoundKey(uint8_t state[], uint8_t key[]){
	uint8_t i=0;
		do
		{
			state[i] = state[i] ^ key[i+2]; //xor with left most 64 bit
			i++;
		}
		while(i<=7);
	
}

//*******************************************************
void doSbox(uint8_t state[], uint8_t sBox[]){
	uint8_t i;
	do
		{
			i--;
			state[i] = sBox[state[i]>>4]<<4 | sBox[state[i] & 0xF];
		}
		while(i>0);
}
//*************************************************************
void doPlayer(uint8_t state[]){
	uint8_t i;
	uint8_t position = 0;
	uint8_t element_source = 0;
	uint8_t bit_source = 0;
	uint8_t element_destination	= 0;
	uint8_t bit_destination	= 0;
	uint8_t temp_pLayer[8];
	for(i=0;i<8;i++)
		{
			temp_pLayer[i] = 0;
		}
		for(i=0;i<64;i++)
		{
			position = (16*i) % 63;						//Artithmetic calculation of the pLayer
			if(i == 63)									//exception for bit 63
				position = 63;
			element_source		= i / 8;
			bit_source 			= i % 8;
			element_destination	= position / 8;
			bit_destination 	= position % 8;
			temp_pLayer[element_destination] |= ((state[element_source]>>bit_source) & 0x1) << bit_destination;
		}
		for(i=0;i<=7;i++)
		{
			state[i] = temp_pLayer[i];
		}
}

//**************************************************************


uint8_t sBox[] = { 0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2};

int main(int argc, char *argv[]) {

	int j;
	uint8_t key[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};  //Master key
	volatile uint8_t state[]	= {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}; //output for each round
	uint8_t ct[] = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00}; //ciphertext
	uint8_t round;
	round = 0;
	do{
		addRoundKey(state,key);
		doSbox(state,sBox);
		doPlayer(state);
		keySchedule(key,sBox,round);
		//printf("\n");
		//for(j=7;j>=0;j--){
		//printf("%02hx",state[j]);
	//}
		
		
		
		round++;
	}while(round<31);
	addRoundKey(state,key);
	printf("\n");
	for(j=7;j>=0;j--){
		printf("%hx",state[j]);
	}
	
	
	
		
	
	
	
	return 0;
}
