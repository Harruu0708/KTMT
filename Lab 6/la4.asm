.data
	A: .word 1, 6, -4, -2, 0, 0, 3
	n: .word 7
	mes_before: .asciiz "Array before sorting: "
	mes_after: .asciiz "\nArray after sorting: "
	space: .asciiz " "
.text
main:
	la $s0, A # array A
	lw $s1, n # number of intergers in A
	li $v0, 4
	la $a0, mes_before
	syscall
	li $t0, 0 # i
	subi $s2, $s1, 1 # $s2 = n -1
print_loop_before:
	li $v0, 1
	add $t1, $t0, $t0
	add $t1, $t1, $t1 # $t1 = 4i
	add $t2, $t1, $s0 # $t2 = address(A[i])
	lw $a0, 0($t2) # $a0= A[i]
	syscall #print A[i]
	beq $t0, $s2, end_of_print_loop_before
	addi $t0, $t0, 1
	li $v0, 4
	la $a0, space
	syscall # print " " to see the result better
	j print_loop_before
end_of_print_loop_before:
	j initialize
after_sort:
	li $v0, 4
	la $a0, mes_after
	syscall
	li $t0, 0 # i
print_loop_after:
	li $v0, 1
	add $t1, $t0, $t0
	add $t1, $t1, $t1 # $t1 = 4i
	add $t2, $t1, $s0 # $t2 = address(A[i])
	lw $a0, 0($t2) # $a0= A[i]
	syscall #print A[i]
	beq $t0, $s2, end_of_print_loop_after
	addi $t0, $t0, 1
	li $v0, 4
	la $a0, space
	syscall # print " " to see the result better
	j print_loop_after
end_of_print_loop_after:
end_of_main: j end_of_program

initialize:
	li $t0, 0 # i
insertion_sort:
	add $t2, $t0, $t0
	add $t2, $t2, $t2 # $t2 = 4i
	add $t3, $t2, 4 # $t3 = 4i + 4 = j
	add $t6, $t3, $s0 # $t6 = address(A[j])
insert_loop:
check_j:
	beq $t3, 0, check_i
	subi $t8, $t6, 4
	lw $t4, 0($t8)
	lw $t5, 0($t6) # $t5 = A[j]
	slt $t7, $t5, $t4
	beq $t7, 1, swap # if A[j-1] > A[j] then swap, else end the current loop
					# and move to the next loop
	j end_of_swap 
swap: # swap A[j-1] and A[j]
	sw $t5, 0($t8)
	sw $t4, 0($t6)
	subi $t3, $t3, 4
	subi $t6, $t6, 4
	j check_j
end_of_swap:
check_i:
	beq $t0, $s2, end_of_insertion_sort
	addi $t0, $t0, 1
	j insertion_sort
end_of_insertion_sort:
	j after_sort
end_of_program:
