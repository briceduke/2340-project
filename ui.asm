.data
new_line:   	.asciiz "\n"
x:		.asciiz "P "
o:		.asciiz "C "
board_numbers:  .word 1, 2, 3, 4, 5, 6,
		.word 7, 8, 9, 10, 12, 14,
		.word 15, 16, 18, 20, 21, 24,
		.word 25, 27, 28, 30, 32, 35,
		.word 36, 40, 42, 45, 48, 49,
		.word 54, 56, 63, 64, 72, 81

.text
.globl display_board

display_board:
	la $t5, board_numbers
    	move $t1, $t0
    	li $t2, 36
    	li $t3, 6

print_loop:
	lw $t4, 0($t1)
	lw $t6, 0($t5)
	bne $t4, $zero, print_played
	j print_num
print_played:
	li $t7, 1
	beq $t4, $t7, print_one
	j print_two
print_one:
	la $a0, x
	li $v0, 4
	syscall
	j finish_print
print_two:
	la $a0, o
	li $v0, 4
	syscall
	j finish_print
print_num:
	move $a0, $t6
	li $v0, 1
	syscall

	li $t8, 10
	blt $t6, $t8, print_extra_space
	j finish_print

print_extra_space:
	li $a0, ' '
	li $v0, 11
	syscall
finish_print:
	li $a0, ' '
	li $v0, 11
	syscall

	addi $t1, $t1, 4
	addi $t5, $t5, 4
	addi $t2, $t2, -1
	addi $t3, $t3, -1
	bnez $t3, print_loop

	la $a0, new_line
	li $v0, 4
	syscall

	li $t3, 6
	bnez $t2, print_loop
	
	jr $ra