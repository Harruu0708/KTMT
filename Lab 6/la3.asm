.data
	A: .word 1, 6, -4, -2, 0, 0, 3
	Aend: .word 7
	mes_before: .asciiz "\nArray before sorting: "
	mes_after: .asciiz "\nArray after sorting: "
	space: .asciiz " "
.text
main:
	la $s0, A # array A
	lw $s1, Aend # number of intergers in A
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
print_loop:
	li $v0, 1
	add $t1, $t0, $t0
	add $t1, $t1, $t1 # $t1 = 4i
	add $t2, $t1, $s0 # $t2 = address(A[i])
	lw $a0, 0($t2) # $a0= A[i]
	syscall #print A[i]
	beq $t0, $s2, end_of_print_loop
	addi $t0, $t0, 1
	li $v0, 4
	la $a0, space
	syscall # print " " to see the result better
	j print_loop
end_of_print_loop:
end_of_main: j end_of_program

initialize:
	li $t0, 0 # i
	subi $t1, $s1, 1 # j
	subi $s2, $s1, 1 # $s2 = n -1
bubble_sort:
	add $t3, $t1, $t1
	add $t3, $t3, $t3 # $t3 = 4j
	add $t4, $t3, $s0 # $t4 = address(A[j])
	lw $t7, 0($t4) # $t7 = A[j]
	subi $t5, $t4, 4 # $t5 = address{A[j-1]}
	lw $t6, 0($t5) # $t6 = A[j-1]
	slt $t8, $t7, $t6
	beq $t8, 1, swap # if $t6 > $t7 then swap
	j end_of_swap
swap: # swap $t6 and $t7
	sw $t6, 0($t4)
	sw $t7, 0($t5)
end_of_swap:
check_j:
	addi $s4,$t0,1
	slt $s3,$s4, $t1
	bne $s3, 1, check_i #if j>i+1 then continue to loop, else check on i
	sub $t1, $t1, 1
	j bubble_sort
check_i: 
	beq $t0, $s2 end_of_bubble_sort #if i = n-1 then end sort, else reset j and increase i
	add $t0, $t0, 1
	subi $t1, $s1, 1 # reset j
	j bubble_sort
end_of_bubble_sort:
	j after_sort
end_of_program:
