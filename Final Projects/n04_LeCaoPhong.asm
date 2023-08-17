.eqv HEADING 0xffff8010 	# góc quay 0 den 359
 				# 0 : len
				# 90: sang phai
 				# 180: xuong
 				# 270: trai
.eqv MOVING 0xffff8050 	# Boolean: Marsbot co di chuyen hay khong
.eqv LEAVETRACK 0xffff8020 	# Boolean (0 or non-0):
 				# co de lai vet hay khong
.eqv WHEREX 0xffff8030 	# Integer: vi tri x hien tai
.eqv WHEREY 0xffff8040 	# Integer: vi tri y hien tai
.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.data
postscript1: .word 90,3000,0,180,3000,0,180,6500,1,60,2500,1,30,1500,1,0,1500,1,330,1500,1,300,2500,1,90,8000,0,270,1500,1,240,1500,1,210,1500,1,180,1500,1,150,1500,1,120,1500,1,90,1500,1,90,2000,0,0,5500,1,90,2500,1,180,2500,0,270,2500,1,180,3000,0,90,2500,1,180,1000,0,-1 #DCE
postscript2: .word 90,3000,0,180,3000,0,180,5500,1,90,3000,1,90,5000,0,270,1500,1,300,2000,1,0,3000,1,60,2000,1,90,1500,1,90,3000,0,90,1000,1,120,1000,1,180,1500,1,240,1000,1,270,1000,1,0,2700,1,180,2700,0,180,2700,1,-1#LCP
postscript3: .word 90,3000,0,180,3000,0,180,6000,1,90,6000,0,0,6000,1,270,3000,0,180,3000,1,90,3000,1,0,3000,0,90,3000,0,180,6000,1,90,3000,1,0,6000,1,270,3000,1,90,6000,0,180,6000,1,90,3000,1,0,3000,1,270,3000,1,0,3000,0,90,3000,1,90,1000,0,-1 #1406

.text
main:
	li $t1, IN_ADRESS_HEXA_KEYBOARD	# luu dia chi dau vao DLS
 	li $t2, OUT_ADRESS_HEXA_KEYBOARD
polling: 					#Scan signal on Digital Lab Sim
 reset:						# 0: postscript1 - DCE // 4: postscript2 - LCP // 8: postscript3 - 1406
	li $t3, 0x1 
 loop:	
 	beq $t3, 0x8, reset
 	nop
	sb $t3, 0($t1 )# luu gia tri vao IN
 	lb $a0, 0($t2) # lay gia tri luu o OUT ra
	bnez $a0, select_postscript 
	nop
	sll $t3,$t3,1 #chuyen toi hang tiep
	j loop
	nop
 select_postscript:
 	beq $a0, 0x11, select1 #bam vao 0 chay postscript1
 	nop
 	beq $a0, 0x12, select2 #bam vao 4 chay postscript2
 	nop
 	beq $a0, 0x14, select3 #bam vao 8 chay postscript3
 	nop
 	j reset
 	nop
 select1:
 	la $v1, postscript1
 	j CNC
 	nop
 select2:
 	la $v1, postscript2
 	j CNC
 	nop
 select3:
 	la $v1, postscript3
CNC: 				
 	lw $a1, 0($v1) #lay goc
 	lw $a0, 4($v1) #lay thoi gian cat
 	lw $a2, 8($v1) #cat hay khong
 	addi $v1, $v1, 12 #chuyen toi lenh cat tiep theo
 check_postscript:
 	beq $a1, -1, end_main #bang -1 dung cat
 	nop
 	beq $a0, -1, end_main
 	nop
 	beq $a2, -1, end_main
 	nop
 run_postscript:
 	jal ROTATE  		#Chuyen toi ve goc
 	nop
 	beq $a2, 1, TRACK	#check xem cat hay khong
 	nop
  cont:
  	jal GO			#Marsbot di chuyen
 	nop
 	li $v0, 32		# Thoi gian Marsbot di chuyen
 	syscall
 	jal STOP		#Dung Marsbot
 	nop
 	jal UNTRACK		#ket thuc huong cu, duong cu chuyen sang huong moi duong moi
 	nop
 	j CNC			#Cap nhat quy dao moi cho Marsbot
 	nop
end_main: #dung chuong trinh
	li $v0,10		
	syscall
#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO: 
	li $at, MOVING 
 	addi $k0, $zero,1 # gan logic 1 de di chuyen
 	sb $k0, 0($at) 
 	nop 
 	jr $ra
 	nop
#-----------------------------------------------------------
# STOP procedure, to stop running
# param[in] none
#------------------------------------------------------------
STOP: 
	li $at, MOVING 
 	sb $zero, 0($at) # dung lai
 	nop
 	jr $ra
 	nop
#-----------------------------------------------------------
# TRACK procedure, to start drawing line 
# param[in] none
#----------------------------------------------------------- 
TRACK: 
	li $at, LEAVETRACK 
 	addi $k0, $zero,1 
 	sb $k0, 0($at) # Marsbot cat
 	nop
 	j cont
 	nop 
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#----------------------------------------------------------- 
UNTRACK:
	li $at, LEAVETRACK
 	sb $zero, 0($at) # Marsbor khong cat
 	nop
 	jr $ra
 	nop
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a1, An angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE: 
	li $at, HEADING #
 	sw $a1, 0($at) # Marsbot xoay goc duoc luu tai $a1
 	nop
 	jr $ra
 	nop

	 
