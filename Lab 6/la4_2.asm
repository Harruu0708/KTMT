.data
	A:       .word 1, 6, -4, -2, 0, 0, 3
	Aend:    .word 
	mes:     .asciiz "Array after sorting: "
	space:   .asciiz " "
.text
main:
    la $a0, A          # $a0 = Address(A[0])
    la $a1, Aend
    addi $a1, $a1, -4  # $a1 = Address(A[n-1])
    la $t0, A		  # i
    add $t2, $0, $a0   # j
    j insertion            # sort

after_sort:
    la $s0, ($a0)
    li $v0, 4
    la $a0, mes
    syscall  # print message to screen

print_loop: # print array with space between each number
    li $v0, 1
    lw $a0, 0($s0)
    syscall # print each element
    beq $s0, $a1, out
    addi $s0, $s0, 4
    li $v0, 4
    la $a0, space
    syscall # print spaces between each element
    j print_loop
out:
end_main:
    li $v0, 10          # exit
    syscall
    
check_i:
    beq $t0, $a1, done  	# single element list is sorted
    addi $t0, $t0, 4 	# i += 1
    add $t2, $t0, 4 	# set j = i + 1
    j insertion            	# call the insertion procedure

insertion:
	beq $t2, $a0, check_i # if j = 0 then move on to check on i, else continue
	addi $t1, $t2, -4 # $t1 = j -1, $t2 = j
	lw $t3, 0($t1)
	lw $t4, 0($t2)
	slt $t5, $t4, $t3
	beq $t5, 1, swap # if A[j-1] > A[j] then swap
	j check_i
	
after_swap:
	addi $t2, $t2, -4 # j -= 1
	j insertion
	
swap: # swap A[j-1] and A[j]
	sw $t3, 0($t2)
	sw $t4, 0($t1)
	j after_swap
	
done:
	j after_sort
