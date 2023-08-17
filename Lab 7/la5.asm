.data
	large_mes: .asciiz "Lagerst element and its index is "
	small_mes: .asciiz "\nSmallest element and its index is "
	and_mes: .asciiz " and "
.text
main:
initialize:
	li $s0, 1
	li $s1, 6
	li $s2, 0
	li $s3, -3
	li $s4, -4
	li $s5, -1
	li $s6, 9
	li $s7, 4
	jal max_min
print_result:
	# Print max value and its index
	li $v0, 4
	la $a0, large_mes
	syscall
	li $v0, 1
	la $a0, ($t0)
	syscall
	li $v0, 4
	la $a0, and_mes
	syscall
	li $v0, 1
	la $a0, ($t1)
	syscall 
	
	# Print min value and its index
	li $v0, 4
	la $a0, small_mes
	syscall
	li $v0, 1
	la $a0, ($t2)
	syscall
	li $v0, 4
	la $a0, and_mes
	syscall
	li $v0, 1
	la $a0, ($t3)
	syscall
	
	# Terminate the program
	li $v0, 10
	syscall 
	
max_min:
	la $t0, ($s0) # max
	li $t1, 0 # max's index
	la $t2, ($s0) # min
	li $t3, 0 # min's index
	add $fp, $sp, $0
	addi $sp, $sp, -32
	sw $s0, 28($sp) # push $s0 to $s7 into the stack
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)
pop_element:
	lw $t4, 0($sp) # pop $s[i] in $t4
	addi $sp, $sp, 4 # point to the next element
check_max:
	slt $t5, $t0, $t4
	beq $t5, 0, check_min # if current max < $s[i] then 
						 # current max = $s[i] and index = i
	la $t0, ($t4)
	sub  $t1, $fp, $sp
	srl $t1, $t1, 2
	j finish_check # if $s[i] > current max then 
				  # $s[i] < current min can't happen
check_min:
	sgt $t5, $t2, $t4
	beq $t5, 0, finish_check  # if current min > $s[i] then 
						 	 # current min = $s[i] and index = i
	la $t2, ($t4)
	sub $t3, $fp, $sp
	srl $t3, $t3, 2
	
finish_check:
	beq $sp, $fp, done # if $sp = $fp then finish
	j pop_element
	
done:
	jr $ra
	