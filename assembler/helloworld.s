#actual start of the main program
#to print "Hello World"
	.globl main
main:				#main has to be a global label
	addu	$s7, $zero, $ra	#save the return address in a global register
	
			#Output the string "Hello World" on separate line 
			
	.data
	
	.globl	hello
hello:	.asciiz "\nHey there\n"	#string to print

	.text
	li	$v0, 4		#print_str (system call 4)
	la	$a0, hello	# takes the address of string as an argument 
	syscall	

                       #Usual stuff at the end of the main
	addu	$ra, $zero, $s7	#restore the return address
	j	main		#return to the main program
	add	$0, $0, $0	#nop
