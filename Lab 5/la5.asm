.data
string: .space 50
Message1: .asciiz "Nhap xau:\n"
Message2: .asciiz "Do dai xau la "
Message3: .asciiz "\nXau sau khi dao nguoc la: "
.text
main:
get_string: # TODO
 li $v0, 4
 la $a0, Message1
 syscall
 li $v0, 8
 la $a0, string
 li $a1, 50
 syscall
get_length: la $s0, string # s0 = Address(string[0])
 xor $v0, $zero, $zero # v0 = length = 0
 xor $t0, $zero, $zero # t0 = i = 0
check_char: add $t1, $s0, $t0 # t1 = s0 + t0 
 #= Address(string[0]+i) 
 lb $t2, 0($t1) # t2 = string[i]
 beq $t2,$zero,end_of_str # Is null char? 
 addi $v0, $v0, 1 # v0=v0+1->length=length+1
 addi $t0, $t0, 1 # t0=t0+1->i = i + 1
 j check_char
end_of_str: 
end_of_get_length:
 li $v0 4
 la $a0, Message3
 syscall
reverse_str:
 add $t1, $s0, $t0 	# t1 = s0 + t0 
 					#= Address(string[0]+i)  
 li $v0, 11
 lb $a0, 0($t1)
 syscall
 beq $t0,$zero,end_of_reverse # Is it the end?
 subi $t0, $t0, 1 # t0=t0+1->i = i - 1
 j reverse_str
end_of_reverse:
