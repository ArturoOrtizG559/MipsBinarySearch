.data 
	#Arturo Ortiz Gonzalez Project 2
original_list: .space 100 
sorted_list: .space 100

str0: .asciiz "Enter size of list (between 1 and 25): "
str1: .asciiz "Enter one list element: \n"
str2: .asciiz "Content of original list: "
str3: .asciiz "Enter a key to search for: "
str4: .asciiz "Content of sorted list: "
strYes: .asciiz "Key found!"
strNo: .asciiz "Key not found!"
space:	.asciiz " "
newLine: .asciiz "\n"



.text 

#This is the main program.
#It first asks user to enter the size of a list.
#It then asks user to input the elements of the list, one at a time.
#It then calls printList to print out content of the list.
#It then calls inSort to perform insertion sort
#It then asks user to enter a search key and calls bSearch on the sorted list.
#It then prints out search result based on return value of bSearch
main: 
	addi $sp, $sp -8
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	#read size of list from user
	syscall
	move $s0, $v0
	move $t0, $0
	la $s1, original_list
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	#read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	move $a0, $s1
	move $a1, $s0
	
	jal inSort	#Call inSort to perform insertion sort in original list
	
	sw $v0, 4($sp)
	li $v0, 4 
	la $a0, str2 
	syscall 
	la $a0, original_list
	move $a1, $s0
	jal printList	#Print original list
	li $v0, 4 
	la $a0, str4 
	syscall 
	lw $a0, 4($sp)
	jal printList	#Print sorted list
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	li $v0, 5	#read search key from user
	syscall
	move $a3, $v0
	lw $a0, 4($sp)
	jal bSearch	#call bSearch to perform binary search
	
	beq $v0, $0, notFound
	li $v0, 4 
	la $a0, strYes 
	syscall 
	j end
	
notFound:
	li $v0, 4 
	la $a0, strNo 
	syscall 
end:
	lw $ra, 0($sp)
	addi $sp, $sp 8
	li $v0, 10 
	syscall
	
	
#printList takes in a list and its size as arguments. 
#It prints all the elements in one line.
printList:
	#Your implementation of printList here	
	move $t0,$0
	
	
p_loop:

	move $t2, $0
	move $t1, $0
	sll $t1, $t0, 2
	la $t3,0($a0)
	add $t2, $t3, $t1
	#lw $t3, 0($t2)
	bge $t0, $s0 returnP
	li $v0, 1
	lw $a0, 0($t2)
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 1
	move $a0, $0
	add $a0, $a0, $t3
	j p_loop
	

returnP:
	li $v0, 4
	la $a0,	newLine
	syscall
	jr $ra
	
	
#inSort takes in a list and it size as arguments. 
#It performs INSERTION sort in ascending order and returns a new sorted list
#You may use the pre-defined sorted_list to store the result
inSort:
	#Your implementation of inSort here
	move $t0, $0	#set temp0 to 0
 	la $s3, sorted_list
 	move $t1, $0
 	
 copy:
 	sll $t1, $t0, 2
 	bge $t0, $s0, continue
 	la $t2, 0($s1)
 	la $t4, 0($s3)
 	add $t4, $t4, $t1
 	add $t2, $t2, $t1
 	lw $t3, 0($t2)
 	sw $t3, 0($t4)
 	addi $t0, $t0, 1
 	j copy
 	
 	
 	
 continue:	
 	move $t0, $0
 	move $t1, $0
 	move $t2, $0
 	move $t3, $0
 	move $t4, $0
	addi $t0, $t0, 1
	
	
outer_loop:
	move $t1, $0 #set temp1 to 0
	move $t3,$0
	sll $t3, $t0,2
	
	bge $t0,$s0 end_inSort
	add $t1,$t1, $t0
	la $t4, 0($s3)
	add $t4, $t3, $t4
	lw $t7, -4($t4)
	lw $t6, 0($t4)
while_loop:
	move $t3, $0
	move $t5 ,$0
	sll $t3, $t1, 2
	add $t5, $t3, $s3
	lw $t7, -4($t5)
	lw $t6, 0($t5)
	ble $t1, $0 exit_while_loop
	blt $t7, $t6, exit_while_loop
	
	sw $t7, 0($t5)
	sw $t6, -4($t5)
	sub $t1, $t1, 1
	j while_loop
	
exit_while_loop:
	addi $t0, $t0, 1
	j outer_loop
	
	
end_inSort:
	move $v0, $s3
	jr $ra
	
	
#bSearch takes in a list, its size, and a search key as arguments.
#It performs binary search RECURSIVELY to look for the search key.
#It will return a 1 if the key is found, or a 0 otherwise.
#Note: you MUST NOT use iterative approach in this function.
bSearch:
	#Your implementation of bSearch here
	move $t0, $0
	move $t1, $0
	move $t2, $0
	move $t3, $0
	move $t4, $0
	move $t5, $0
	move $s5, $0	#s4 is high s5 is low
	add $s4, $s0, $0
	
b_iner:

	la $t4, 0($a0)

	move $t5, $0	
	move $t2, $0
	move $s2,$0
	add $t2, $s5, $s4
	sra $t2, $t2,1
	add $t5,$t2, $0 #mid regular value
	sll $t3,$t2,2
	add $s2, $s2, $t3 #mid Shift value
	add $t4,$t4, $s2
	lw $t1, 0($t4) #value at mid
	
	bge $s4,$s5, else0
	j end_loop
	
else0:
	ble $t1, $a3 else1
	add $sp, $sp, -4
	sw $ra, 0($sp)
	sub $t5, $t5, 1
	move $s4,$t5
	jal b_iner
	lw $ra, 0($sp)
	add $sp,$sp, 4
	jr $ra
	
else1:
	bge $t1,$a3, last
	addi $t5, $t5, 1
	move $s5, $t5
	add $sp, $sp, -4
	sw $ra, 0($sp)
	jal b_iner
	lw $ra, 0($sp)
	add $sp,$sp, 4
	jr $ra
	
last:
	li $v0, 1
	jr $ra
	
end_loop:
	li $v0, 0
	jr $ra
	#$a3 holds value to search for and $a0 holds sorted list
	
	
	
	jr $ra
	
