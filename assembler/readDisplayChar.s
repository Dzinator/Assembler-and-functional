#####################################
##              text               ##
#####################################
	.text
	.globl main
	
main:
	
	addi $a1, $zero, 10			#I wanna read 10 characters max and save them at array address
	la $a0, array
	jal gets		
	
	#TESTING CODE -- Print the 10 characters I read
	subi $sp, $sp, 12	#I need 10 bytes to store 10 characters but I reserve 12 to respect words boundary: RESERVED SPACE IN STACK MUST ALWAYS BE OF SIZE MULTIPLE OF 4
	la $t0, ($sp)		#save address of $sp in $t0 to manipulate it
	addi $t1, $zero, 10	#To test my puts I put 10 char in stack, $t1 will be the 10 to compare with
	add $t2, $zero, $zero  #$t2 will be my offset in the array
stack:
	lb $t3, array($t2)	#I copy from array to stack and increment both by 1( byte)
	sb $t3, 0($t0)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
	bne $t2, $t1, stack	#if hasnt reached 10 char it loops

	
	add $a0, $t0, $zero	#$t0 contains now the end of the part of stack I use to store my string(s) puts will start at $sp and stop displaying there (equivalent to $fp)
	jal puts		#call function puts to print chars I saved in stack
	
	addi $sp, $sp, 12	# clears stack
	
	j done
#################################################################################################

	
	#MY FUNCTIONS START HERE:	
	
gets:			#takes an adress where to start writin in $a0 and a max nb of char to write in $a1
	subi $sp, $sp, 16	#backup registers that will be used in stack
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	
	addi $t3, $zero, 10	#$t3 holds the Enter key ASCII value
	add $t1, $zero, $zero	#set counter to zero, $t1 will be my counter for the number of char read
	la $t2, ($a0)		#load buffer address where to write in $t2
	
retrieve:
	beq $t1, $a1, finishG	#end if we reached count
	jal GetChar		#read char using GetChar driver
	sb $v0, 0($t2) 		#stro the returned char where I'm now at buffer ($t2)
	addi $t1, $t1, 1	#increment counter
	addi $t2, $t2, 1	#increase buffer address by 1 (char= 1byte)
	bne $v0, $t3, retrieve	#read another char if last was not Enter key 
	
	li $t3, 0		# \0 ASCII value (0)
	sh $t3, 2($t2)		#add \0 ath the end of buffer 

finishG:
	add $v0, $t1, $zero	#saves the read char counter to be returned in $vo
	lw $t3, 12($sp)		#retrieve saved registers
	lw $t2, 8($sp)
	lw $t1, 4($sp)		
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra
	
	
	
		
puts:	#THIS FUNCTION WILL PRINT ALL STRINGS IN STACK UNTIL STACK REACHES AN ADDRESS IN STACK SPECIFIED BY CALLING FUNCTION AT $a0 (prints characters starting from $sp until $a0) 
	subi $sp, $sp, 16	#backup registers that will be used in stack
	sw $ra, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	
	addi $t1, $sp, 16 	# having saved registers and moved $sp I return to beginning of stack as we entered the function and save that in $t1
	addi $t2, $a0, 0	#I save the end address(provided of calling function) in $t2 because I will need $a0 to call PutChar
	add $t3, $zero, $zero	#I'll use $t3 to count the number of characters I displayed
	
send:
	beq $t1, $t2, finishP	#if I reach the provided STOP ADDRESS, I stop printing
	addi $a0, $t1, 0		#provide the address as argument for PutChar
	jal PutChar		#display char at address $t1 ($ao now) using PutChar driver
	addi $t3, $t3, 1	#increment the counter
	addi $t1, $t1, 1	#increment $t1 by size of byte to go to next char
	j send

finishP:
	add $v0, $t3, $zero	#saves the displayed char count to be returned in $vo
	lw $t3, 12($sp)		#retrieve saved registers
	lw $t2, 8($sp)
	lw $t1, 4($sp)		
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra	
	
	
	
	
GetChar:
	lui $a3, 0xffff 	#load address of keyboard
isKReady:
	lw $a2, 0($a3) 		#load device data+control
	andi $a2, $a2, 0x0001 	#isolate the ready bit
	beqz $a2, isKReady 	#if 1 (device ready): continue, else keep checking
	lb $v0, 4($a3)		#load char(byte) to output register
	jr $ra 			#return to calling method
	
	
PutChar:
	lui $a3, 0xffff 	#load address of display
isPReady:
	lw $a1, 8($a3) 		#load device data+control
	andi $a1, $a1, 0x0001 	#isolate the ready bit
	beqz $a1, isPReady 	#if 1 (display ready), continue, else keep checking
	lb $a2, 0($a0)
	sb $a2, 12($a3) 	#save char in display data register
	jr $ra 			#return to calling program	

	
	
	
	
	
#################################################################################################
done:
	li	$v0,10		#**	HERE I CHANGE THE CODE TO END THE PROGRAM WHEN...
	syscall			#...IT HAS FINISHED RUNNING.

	
########################################
##              data                  ##
########################################
	.data
array: .asciiz 	"abcdefghij"	#I initialize the array to be 10 first alphabet letter but the user will input his characters
space: .asciiz " "
endl: .asciiz "\n"

message: .asciiz "Enter 10 numbers, pressing return between each:\n"	#message explaining user how to enter numbers
