.data
	input_mes: .asciiz "Input: "
	bin_mes: .asciiz "Binary: "
	string_bin: .space 32
	hex_mes: .asciiz "\nHeximal: "
	string_hex: .space 8
.text
	li $v0, 4
	la $a0, input_mes
	syscall
	li $v0, 5
	syscall
	la $t0, string_bin
	add $t1, $0, 0x1
	add $s1, $s0, 49	#Ascii 1
	add $s2, $s0, 48	#Ascii 0
convert_binary:
	and $t2, $t1, $v0	#convert to binary
        beqz $t2, its_zero
	sb $s1, 0($t0)		#store 1 to address $t0
	j condition
its_zero: sb $s2, 0($t0)	#store 2 to address $t0
condition:
	add $t0, $t0, 1    
	sll $t1, $t1, 1		#dich trai $t1 1 bit
	beq $t1, 0, print_binmes  
	j convert_binary
print_binmes:
	li $v0, 4
	la $a0, bin_mes		#print Binary
	syscall
	la $s0, string_bin
	li $v0, 11
	add $t0, $t0, -1
	add $t5, $0, $t0	#$t5 luu dia chi cua bit cuoi cung duoc luu o $t0
print_binary:
	lb $a0, 0($t0)		#print after converted to Binary
	syscall
	beq $t0, $s0, end_binary
	add $t0, $t0, -1
	j print_binary
end_binary:
	li $v0, 4
	la $a0, hex_mes		#print Heximal
	syscall
	la $s0, string_bin
	li $v0, 11
convert_hex:
	lb $t1, 0($t5)	#lay ra 4 bit duoc luu cuoi cung tai $t0
	lb $t2, -1($t5)
	lb $t3, -2($t5)
	lb $t4, -3($t5)
	add $t1, $t1, -48	#chuyen chung ve 0 va 1 
	add $t2, $t2, -48
	add $t3, $t3, -48
	add $t4, $t4, -48
	mul $t1, $t1, 8
	mul $t2, $t2, 4
	mul $t3, $t3, 2
	mul $t4, $t4, 1
	add $t1, $t1, $t2
	add $t3, $t3, $t4
	add $t1, $t1, $t3	#$t1= gia tri o he 10 cua 4 bit duoc lay ra
	blt $t1, 10, normal
	add $a0, $t1, 55	#$t1>=10 thi chuyen thanh A,B,...F ASCII
	j print_hex
normal:	add $a0, $t1, 48	#chuyen ve ASCII
print_hex:
	syscall
	add $t5, $t5, -4
	bge $t5, $s0, convert_hex 	#$t5<$s0 ket thuc vong lap
end:	li $v0, 10		#exit
	syscall