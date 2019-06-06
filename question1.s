	AREA question1, CODE, READONLY
	ENTRY
			ADR r0, UPC ; getting address of the UPC code so we can start reading it

		
Loop		LDRB r1, [r0], #1 ;read in the UPC code
			SUB r1, r1, #48 ;Subtract the ASCII padding of numbers away from the read in value to get the true numerical value
			CMP r3, #1 ;Check to see if we are on a even index
			BNE Odd ;if we are not then go to the odd summation 
			ADD r4, r4,r1 ;else we add the read in number to the even index summation
			MOV r3, #0 ;change the flag so that the next index is odd
			BEQ Done ;skip ahead to increment the index value
Odd			ADD r5, r5,r1 ; add the read in number to the odd index summation
			MOV r3, #1 ;change the flag so that the next index is even
		
Done		ADD r2, r2, #1 ;increment the index by 
			CMP r2, #12 ;make sure the index is still within UPC code length -1 
			BNE Loop ;if it is within the UPC code length loop back to the top
			
			MOV r7,r5 ;Making a copy of the riginal value of the odd summation so we can multiply by 3 
			LSL r5,#1 ;Shifting odd summation to multiply by 2
			ADD r5, r5, r7 ; adding orginal summation to multiplied to act as multiplying by 3
			ADD r0,r4,r5 ; add the new odd summation to the even summation
			
Divide		SUBS r0, r0, #10 ;subtract by 10 so we can check if the total summation is a mutliple of it 
			MOVEQ r0, #1 ;if the last operation is equal to 0 we know that it is a mutliple of 10 and we know that there is no error
			BEQ Finished ;so we are done if that is equal 
			BPL Divide; if the number is greater then 0 that means we havent yet found out if its a multiple or not. So keep looping 
			
			MOV r0, #2 ;if we get to here that means we have reached a negative number when sub 10 from the summation, therefore is not a multiple and there exists an error

Finished	B Finished	;Program is finished.

UPC 		DCB "013800150738" ;UPC String 
	END ;