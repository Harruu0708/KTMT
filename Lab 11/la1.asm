#------------------------------------------------------
# col 0x1 col 0x2 col 0x4 col 0x8 
#
# row 0x1 0 1 2 3 
# 0x11 0x21 0x41 0x81 
#
# row 0x2 4 5 6 7
# 0x12 0x22 0x42 0x82
#
# row 0x4 8 9 a b 
# 0x14 0x24 0x44 0x84
#
# row 0x8 c d e f
# 0x18 0x28 0x48 0x88
#
#------------------------------------------------------
# command row number of hexadecimal keyboard (bit 0 to 3)
# Eg. assign 0x1, to get key button 0,1,2,3
# assign 0x2, to get key button 4,5,6,7
# NOTE must reassign value for this address before reading,
# eventhough you only want to scan 1 row
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
# receive row and column of the key pressed, 0 if not key pressed 
# Eg. equal 0x11, means that key button 0 pressed.
# Eg. equal 0x28, means that key button D pressed.
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.text
main: li $s1, IN_ADRESS_HEXA_KEYBOARD
 li $s2, OUT_ADRESS_HEXA_KEYBOARD
 li $t0, 0x01 # check row 1 with key 0, 1, 2, 3
 li $t4, 0x10
polling: 
 sb $t0, 0($s1) # must reassign expected row
 lb $a0, 0($s2) # read scan code of key button
 beq $a0, $0, sleep_row
print: li $v0, 34 # print integer (hexa)
 syscall
 li $v0, 11
 li $a0, 10
 syscall
 j sleep_matrix
sleep_row: li $a0, 10 # sleep 100ms
 li $v0, 32
 syscall 
 sll $t0, $t0, 1
 beq $t0, $t4, reset
 j polling
reset: li $t0, 0x01
 j polling
sleep_matrix:li $a0, 100 # sleep 100ms
 li $v0, 32
 syscall 
back_to_polling: j polling # continue polling
