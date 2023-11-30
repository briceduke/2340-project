.data
board_numbers:  .word   1, 2, 3, 4, 5, 6,
		.word 	7, 8, 9, 10, 12, 14,
		.word 	15, 16, 18, 20, 21, 24,
		.word 	25, 27, 28, 30, 32, 35,
		.word 	36, 40, 42, 45, 48, 49,
		.word 	54, 56, 63, 64, 72, 81
new_line:   	.asciiz "\n"
last_move:  	.word 0

.text
.globl computer_move
	
computer_move:
	# $t0 = game_board address
	# $t1 = last_move value

	# Generate random move
	li $v0, 42			# bounded random integer
	li $a0, 0
	li $a1, 9			# upper bound is not inclusive
	syscall

	addi $a0, $a0, 1		# move number from 0-8 to 1-9

	mul  $t2, $a0, $t1		# $t2 = product of random number and last move

	sw $a0, last_move		# store last move

	# Load for updating
	la $t3, board_numbers		# $t3 = board_numbers address
	move $t4, $t0			# $t4 = copy of game_board address, mutate this but not $t0
	li $t5, 36			# $t5 = counter

loop:
	lw $t6, 0($t3)			# $t6 = value of current board_numbers address
	beq  $t6, $t2, update
	addi $t3, $t3, 4		# increment board_numbers address
	addi $t4, $t4, 4		# increment game_board copy address
	addi $t5, $t5, -1		# decrement counter
	bnez $t5, loop
	j return			# if there are no valid moves found, just return

update:
	lw $t7, 0($t4)			# $t7 = value of current game_board copy address
	bnez $t7, computer_move		# if $t7 is not zero, it's occupied so regenerate the move

	li $t7, 2			# $t7 = value of computer move
	sw $t7, 0($t4)			# set game_board copy to 2

####################################################
#						   #
#  Below is a temporary board display, ignore it!  #
#						   #
####################################################


display_board:
    	move $t1, $t0
    	li $t2, 36
    	li $t3, 6


print_loop:
	lw $t4, 0($t1)
	move $a0, $t4
	li $v0, 1
	syscall

	li $a0, ' '
	li $v0, 11
	syscall

	addi $t1, $t1, 4
	addi $t2, $t2, -1
	addi $t3, $t3, -1
	bnez $t3, print_loop

	la $a0, new_line
	li $v0, 4
	syscall

	li $t3, 6
	bnez $t2, print_loop

return:
    	# Set last move and board address back to original registers
    	lw $t1, last_move


    	# Return to game loop
	jr $ra
