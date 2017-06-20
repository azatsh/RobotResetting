#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>

unsigned char in;
unsigned char out;
unsigned char PredZ,PredA; // достигнут ли предел оси Z
unsigned char Nz,Nb1,Nb2; // счетчик

unsigned char Alpha = 20; // произвольная константа 
unsigned char Alpha2 = 30;

#define bit(n) (in & (1<<n))

void USART_Init( unsigned int baud )
{
UBRRH = (unsigned char)(baud>>8);
UBRRL = (unsigned char)baud;
UCSRC = (1<<URSEL)|(3<<UCSZ0);
UCSRB = (1<<RXEN)|(1<<TXEN);
}

unsigned char Receive(void)
{
while (!(UCSRA & 0x80)) {};
return UDR;
}

void Trans(unsigned char c)
{
 UDR = c;
}

int main(void)
{

 USART_Init(23);
 sei();

 while (1)
 {
 PredZ = 0;
 Nz = 0;
 in = Receive();
 if (!bit(6)) 
 {
  PredZ = 1;
  Nz = Alpha;
 }

 Nb1 = 0;
 Nb2 = 0;
 if (bit(3))
 {
  Nb1 = Alpha;
  Nb2 = Alpha2;
 }

 if (!bit(2)) Nb2 = Alpha2;

 if (bit(1)) PredA = 1;

 out = 1;
 while (out)
 {
  
  out = 0;
  // C
  if (bit(5))
  {
   if (bit(4)) out = 0;
   if (!bit(4)) out = (1<<4);
  }
  if (!bit(5))
  {
   if (bit(4)) out = 0;
   if (!bit(4)) out = (1<<5);
  }

  // B
  if (!out)
  {
   if (bit(2))
   {
    if (Nb1 == Alpha) out = (1<<3);
    if (Nb1 != Alpha) 
	{
	 if (Nb2 == Alpha2) 
	 {
	  out = (1<<2);
	  Nb1++;
     }
	 if (Nb2 != Alpha2) out = (1<<3);
	 
	}
   }

   
   if (!bit(2))
   {
    if (Nb1 == Alpha)
	{
	 if (Nb2 == Alpha2) out = (1<<2);
	 if (Nb2 != Alpha2) 
	 {
	 out = (1<<3);
	 Nb2++;
	 }
	}
    if (Nb1 != Alpha) 
	{
	 if (Nb2 == Alpha2) out = (1<<2);
	 if (Nb2 != Alpha2) 
	 {
	  out = (1<<3);
	  Nb2++;
	 }
	}
   }

   if (bit(3))
   {
    if (Nb1 == Alpha) 
	{ 
	 if (Nb2 == Alpha2) out = 0;
     if (Nb2 != Alpha2) 
	 {
	  out = (1<<3);
	  Nb2 = 0;
     }
	}
    if (Nb1 != Alpha) 
	{
	 if (Nb2 == Alpha2) out = (1<<2);
     if (Nb2 != Alpha2) out = (1<<3);
	}
   }
  } // end B

  // A
  if (!out)
  {
  if (bit(0))
  {
   if (PredA) out = 1; 
   if (!PredA) out = (1<<1); // назад
  }

  if (!bit(0)) out = (1<<1);

  if (bit(1)) 
  {
   if (PredA) out = 0;
   if (!PredA) out = (1<<1); 
  }

  if (bit(0)&&bit(1))
  {
   PredA = 1;
   out = 1;
  }
  } // end A

  
  // Z
  if (!out)
  {
  if (bit(6)) // положение < нул. точки
  { 
   if (PredZ) out = 0b10000000; // достигнут левый предел 
   if (!PredZ) out = 0b01000000; // иначе вперед
  }

  if (!bit(6)&&(PredZ))
  {
   if (Nz == Alpha) out = 0b01000000; // вперед 
   else
   {
   out = 0b10000000;  
   Nz++;
   }
  }
  
  if (bit(7)) 
  {
   if (PredZ)
   { 
    if (Nz == Alpha) out = 0b00000000; // стоять
	if (Nz != Alpha) out = 0b10000000; // назад
   }

   if (!PredZ) out = 0b01000000; 
  }

  if (bit(6)&&bit(7)) 
  {
  out = 0b10000000; 
  PredZ = 1;
  }

  } // end Z


  Trans(out);
  in = Receive();
 } // while (!out)

 } // while (1)
} // main
