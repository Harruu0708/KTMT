.data
	x: .space 50 # destination string x, empty
	y: .space 50 # source string y, ready to be assigned
	message1: .asciiz "Nhap xau: "
	message2: .asciiz "Xau x sau khi da duoc sao chep: "
.text
	li $v0, 4
	la $a0,message1
	syscall #print "Nhap xau:"
	li $v0, 8
	la $a0, y
	li $a1, 50
	syscall
	la $a1, 0($a0)
	la $a0, x
strcpy:
	add $s0,$zero,$zero #s0 = i=0
L1:
	add $t1,$s0,$a1 #t1 = s0 + a1 = i + y[0]
					# = address of y[i]
	lb $t2,0($t1)	#t2 = value at t1 = y[i]
	add $t3,$s0,$a0 #t3 = s0 + a0 = i + x[0] 
 					# = address of x[i]
	sb $t2,0($t3) #x[i]= t2 = y[i]
	beq $t2,$zero,end_of_strcpy #if y[i]==0, exit
	nop
	addi $s0,$s0,1 #s0=s0 + 1 <-> i=i+1
	j L1 #next character
	nop
end_of_strcpy:
	la $t0, 0($a0)
	li $v0, 4
	la $a0, message2
	syscall
	
	li $v0, 4
	la $a0, 0($t0)
	syscall