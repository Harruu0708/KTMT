.data
FirstMessage: .asciiz "The sum of "
SecondMessage: .asciiz " and "
ThirdMessage: .asciiz " is "
.text
 li $s0, 16
 li $s1, 4
 add $s2,$s0,$s1 #s2 = $s0 + $s1
 
 li $v0, 4
 la $a0, FirstMessage
 syscall #print First Message
 
 li $v0,1
 add $a0,$s0,$0
 syscall #print $s0
 
 li $v0, 4
 la $a0, SecondMessage
 syscall #print Second Message
 
 li $v0,1
 add $a0,$s1,$0
 syscall #print $s1
 
 li $v0, 4
 la $a0, ThirdMessage
 syscall #print Third Message
 
 li $v0,1
 add $a0,$s2,$0
 syscall #print result
 
 
 