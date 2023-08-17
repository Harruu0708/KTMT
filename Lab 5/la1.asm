.data
test: .asciiz "Le Quang Minh"
.text
 li $v0, 4
 la $a0, test
 syscall 
 