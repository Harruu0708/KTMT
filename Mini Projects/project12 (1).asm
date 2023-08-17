#Project 12
.data
	string: .space 100
	Input: .asciiz "Input: "
	Output: .asciiz "Output: "
.text
main:
	li $v0, 4
	la $a0, Input
	syscall
	li $v0, 8
	la $a0, string
	li $a1, 100
	syscall # input string
	jal a_to_i
	li $v0, 4
	la $a0, Output
	syscall
	li $v0, 1
	la $a0, ($s0)
	syscall # print number
	li $v0, 10
	syscall # terminate
	
# Funtion a_to_i: starting address of the string will be in $a0
# and return a 32-bit interger in $s0

a_to_i:
	la $t2, ($a0) # string address
	addi $t0, $a0, -1
find_end: # find the end of string
	addi $t0, $t0, 1
	lb $t1, 0($t0)
	bne $t1, 10, find_end
	li $v0, 1 # 10^i
	li $s0, 0 # number
loop:
	add $t0, $t0, -1
	lb $s1, 0($t0)
	addi $s1, $s1, -48	# ASCII to interger
	mul $s1, $s1, $v0	# $s1 . 10^i
	add $s0, $s0, $s1	# $a0 = $a0 + $s1
	mul $v0, $v0, 10	# 10^(i+1)
	bne $t0, $t2, loop
	jr $ra
