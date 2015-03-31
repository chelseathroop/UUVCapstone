// ECE412 - CAPSTONE PROJECT
// UUV - SERVICE BUTTON
// Team members: Phu Nguyen, Chelsea Throop, Saida Akhter, Trevor Conant
// This code has been written for Atmega328P microcontroller connected 32 MHz crystal oscillator.



#define F_CPU 32000000UL

#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <avr/interrupt.h>
#include <math.h>

/* Define output port (pin) for button service

Change Sample Rate
1.	Menu  --> Menu1
2.	Fast Forward --> FastForward2
3.	Minus --> Minus
4.	Fast Forward--> FastForward4
5.	Down – 44.1k --> Down
6.	Middle - 48k -->Middle
7.	Up – 96k -->Up
8.	Menu -->Menu8
9.	Menu -->Menu9

Record
1.	Record --> Record
2.	Stop/Home --> Stop

 
*/  

#define Menu1_port				PORTD                  // Menu button
#define Menu1_bit				PORTD0
#define Menu1_ddr				DDRD


#define FastForward2_port		PORTD                   // Fast Forward button 
#define FastForward2_bit		PORTD1
#define FastForward2_ddr		DDRD

#define Minus_port				PORTD                   // Minus button
#define Minus_bit				PORTD2
#define Minus_ddr				DDRD

#define FastForward4_port		PORTD                   // Fast Forward button repeated press
#define FastForward4_bit		PORTD4
#define FastForward4_ddr		DDRD

#define Down_port				PORTD                   // Down button
#define Down_bit				PORTD5
#define Down_ddr				DDRD

#define Middle_port				PORTD                   // Middle button
#define Middle_bit				PORTD6
#define Middle_ddr				DDRD


#define Up_port					PORTD                     // Up button
#define Up_bit					PORTD7
#define Up_ddr					DDRD


#define Menu8_port				PORTC                   // Menu button repeated press in service sequence
#define Menu8_bit				PORTC0
#define Menu8_ddr				DDRC

#define Menu9_port				PORTC                   // Menu button repeated press in service sequence
#define Menu9_bit				PORTC1
#define Menu9_ddr				DDRC


#define Record_port				PORTC	                   // Record button press 
#define Record_bit				PORTC2
#define Record_ddr				DDRC


#define Stop_port				PORTC                   // Stop button press
#define Stop_bit				PORTC3
#define Stop_ddr				DDRC


#define MuxControl1_port		PORTB                   // Mux control line 1 
#define MuxControl1_bit		   PORTB1
#define MuxControl1_ddr			DDRB



#define MuxControl2_port		PORTB                   // Mux control line 2
#define MuxControl2_bit			PORTB2
#define MuxControl2_ddr			DDRB



// Function Prototypes
void lcd_write_4(uint8_t);
void lcd_write_instruction_4d(uint8_t);
void lcd_write_character_4d(uint8_t);
void lcd_write_string_4d(char *);
void lcd_init_4d(void);
 int Round(float myfloat);
 
 
/******************************* Main Program Code *************************/
int main(void)
{
	
//******* configure the microprocessor pins for output******

// Sample Rate change
   Menu1_ddr |= (1<<Menu1_bit);                 
   FastForward2_ddr |= (1<<FastForward2_bit);
   Minus_ddr |= (1<<Minus_bit);
   FastForward4_ddr |= (1<<FastForward4_bit);
   Down_ddr|=(1<<Down_bit);
   Middle_ddr|=(1<<Middle_bit);
   Up_ddr|=(1<<Up_bit);	  
   Menu8_ddr|=(1<<Menu8_bit);
   Menu9_ddr|=(1<<Menu9_bit); 
 
 // Record
 	Record_ddr|=(1<<Record_bit);
	Stop_ddr|=(1<<Stop_bit);

 // Mux control line
 
	MuxControl1_ddr |=(1<<MuxControl1_bit);
	MuxControl2_ddr|=(1<<MuxControl2_bit);
	
		
/***** Initilize the outputs***************/

PORTD&=~(1<<Menu1_bit); PORTD&=~(1<<FastForward2_bit);PORTD&=~(1<<Minus_bit); PORTD&=~(1<<FastForward4_bit);
PORTD&=~(1<<Down_bit); PORTD&=~(1<<Middle_bit);PORTD&=~(1<<Up_bit);
PORTC&=~(1<<Menu8_bit); PORTC&=~(1<<Menu9_bit);PORTC&=~(1<<Record_bit); PORTC&=~(1<<Stop_bit);



 
/* 
INTERRUPT DETECTION LOOP SHOULD GO HERE
MCU WAKE-UP CODE HERE
CONDITION LOOPS FOR CHOOSING SD CARD, SAMPLE RATE SHOULD GO HERE 
....
*/


/*************************************************
RECORDING WITH SAMPLE RATE OF 44.1 k AND STORING THE DATA TO FIRST SD CARD

************************************************/

//Select first SD card (00) for storing data
// Important : select the SD card after interrupt and before turning on Tascam

PORTB&=~(1<<MuxControl1_bit) ; PORTB&=~(1<<MuxControl2_bit);

/*******Turn on the Tascam***************/

PORTC|=(1<<Stop_bit);
_delay_ms(5000);
PORTC&=~(1<<Stop_bit);

/******Set the sample rate of 44.1K here******************
1.	Menu  --> Menu1
2.	Fast Forward --> FastForward2
3.	Minus --> Minus
4.	Fast Forward--> FastForward4
5.	Down --> 44.1k --> Down
8.	Menu -->Menu8
9.	Menu -->Menu9
Need to confirm this sequence is correct 

***********************************************************/

PORTD|=(1<<Menu1_bit);
_delay_ms(500);
PORTD&=~(1<<Menu1_bit);

PORTD|=(1<<FastForward2_bit);;
_delay_ms(500);
PORTD&=~(1<<FastForward2_bit);

PORTD|=(1<<Minus_bit);
_delay_ms(500);
PORTD&=~(1<<Minus_bit);

PORTD|=(1<<FastForward4_bit);
_delay_ms(500);
PORTD&=~(1<<FastForward4_bit);

PORTD|=(1<<Down_bit);
_delay_ms(500);
PORTD&=~(1<<Down_bit);

PORTC|=(1<<Menu8_bit);
_delay_ms(500);
PORTC&=~(1<<Menu8_bit);

PORTC|=(1<<Menu9_bit);
_delay_ms(500);
PORTD&=~(1<<Menu9_bit);

// Start recording with sample rate =44.1K for 15 second

PORTC|=(1<<Record_bit);
_delay_ms(500);
PORTC&=~(1<<Record_bit);

_delay_ms(5000);
_delay_ms(5000);
_delay_ms(5000);


//Stop recording, turn off TASCAM

PORTC|=(1<<Stop_bit);
_delay_ms(5000);
PORTC&=~(1<<Stop_bit);

// Switch SD card

PORTB&=~(1<<MuxControl1_bit) ; PORTB|=(1<<MuxControl2_bit);


/******* code for MCU go to sleep here 
....

***********/


/*************************************************
RECORDING WITH SAMPLE RATE OF 44.1 k AND STORING THE DATA TO FIRST SD CARD

************************************************/

/*******Turn on the Tascam***************/

PORTC|=(1<<Stop_bit);
_delay_ms(5000);
PORTC&=~(1<<Stop_bit);


/********************************************************/
/********************************************************/
/******Set the sample rate of 48 K here******************

1.	Menu  --> Menu1
2.	Fast Forward --> FastForward2
3.	Minus --> Minus
4.	Fast Forward--> FastForward4
6.	Middle - 48k -->Middle
8.	Menu -->Menu8
9.	Menu -->Menu9


***********************************************************/

PORTD|=(1<<Menu1_bit);
_delay_ms(500);
PORTD&=~(1<<Menu1_bit);

PORTD|=(1<<FastForward2_bit);;
_delay_ms(500);
PORTD&=~(1<<FastForward2_bit);

PORTD|=(1<<Minus_bit);
_delay_ms(500);
PORTD&=~(1<<Minus_bit);

PORTD|=(1<<FastForward4_bit);
_delay_ms(500);
PORTD&=~(1<<FastForward4_bit);

PORTD|=(1<<Middle_bit);
_delay_ms(500);
PORTD&=~(1<<Middle_bit);

PORTC|=(1<<Menu8_bit);
_delay_ms(500);
PORTC&=~(1<<Menu8_bit);

PORTC|=(1<<Menu9_bit);
_delay_ms(500);
PORTD&=~(1<<Menu9_bit);

// Start recording with sample rate =48K for 15 second

PORTC|=(1<<Record_bit);
_delay_ms(500);
PORTC&=~(1<<Record_bit);

_delay_ms(5000);
_delay_ms(5000);
_delay_ms(5000);


//Stop recording, turn off TASCAM

PORTC|=(1<<Stop_bit);
_delay_ms(5000);
PORTC&=~(1<<Stop_bit);


// Switch SD card

PORTB|=(1<<MuxControl1_bit); PORTB&=~(1<<MuxControl2_bit) ; 




/******* code for MCU go to sleep here
....
***********/


/*************************************************
RECORDING WITH SAMPLE RATE OF 96k AND STORING THE DATA TO THIRD SD CARD

************************************************/

/*******Turn on the Tascam***************/

PORTC|=(1<<Stop_bit);
_delay_ms(5000);
PORTC&=~(1<<Stop_bit);

/********************************************************/
/********************************************************/
/******SEQUENCE FOR Setting up the sample rate of 96K   here******************

1.	Menu  --> Menu1
2.	Fast Forward --> FastForward2
3.	Minus --> Minus
4.	Fast Forward--> FastForward4
7.	Up – 96k -->Up
8.	Menu -->Menu8
9.	Menu -->Menu9


***********************************************************/

PORTD|=(1<<Menu1_bit);
_delay_ms(500);
PORTD&=~(1<<Menu1_bit);

PORTD|=(1<<FastForward2_bit);;
_delay_ms(500);
PORTD&=~(1<<FastForward2_bit);

PORTD|=(1<<Minus_bit);
_delay_ms(500);
PORTD&=~(1<<Minus_bit);

PORTD|=(1<<FastForward4_bit);
_delay_ms(500);
PORTD&=~(1<<FastForward4_bit);

PORTD|=(1<<Up_bit);
_delay_ms(500);
PORTD&=~(1<<Up_bit);

PORTC|=(1<<Menu8_bit);
_delay_ms(500);
PORTC&=~(1<<Menu8_bit);

PORTC|=(1<<Menu9_bit);
_delay_ms(500);
PORTD&=~(1<<Menu9_bit);

// Start recording with sample rate =48K for 15 second

PORTC|=(1<<Record_bit);
_delay_ms(500);
PORTC&=~(1<<Record_bit);

_delay_ms(5000);
_delay_ms(5000);
_delay_ms(5000);


//Stop recording, turn off TASCAM

PORTC|=(1<<Stop_bit);
_delay_ms(5000);
PORTC&=~(1<<Stop_bit);

/**********************/
}
/******************************* End of Main Program Code ******************/
