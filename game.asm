.data
game_board: 	.word 0, 0, 0, 0, 0, 0,
	    	.word 0, 0, 0, 0, 0, 0,
            	.word 0, 0, 0, 0, 0, 0,
            	.word 0, 0, 0, 0, 0, 0,
            	.word 0, 0, 0, 0, 0, 0,
            	.word 0, 0, 0, 0, 0, 0

board_numbers:  .word 1, 2, 3, 4, 5, 6,
		.word 7, 8, 9, 10, 12, 14,
		.word 15, 16, 18, 20, 21, 24,
		.word 25, 27, 28, 30, 32, 35,
		.word 36, 40, 42, 45, 48, 49,
		.word 54, 56, 63, 64, 72, 81

last_move: 	.word 0

prev_prompt: 	.asciiz "\nLast Move: "
occupied_msg: 	.asciiz "Space is occupied, try again.\n"

.text
.globl main

main:
	# Initialize game board
    	la $t0, game_board

init_loop: 
	# Generate first move
    	li $v0, 42		# bounded random integer
	li $a0, 0
	li $a1, 9		# upper bound is not inclusive
	syscall

	addi $a0, $a0, 1

	sw $a0, last_move

game_loop:
	jal print_last_move
	
user_input:

	# Player input
	jal get_user_input

	# Load last move and game board
	la $t0, game_board
	lw $t1, last_move

	add $a0, $t2, $zero

	mul $t2, $a0, $t1		# $t2 = product of inputted number and last move
	
	# Load for updating
	la $t3, board_numbers		# $t3 = board_numbers address
	li $t5, 36			# $t5 = counter

loop:
	lw $t6, 0($t3)			# $t6 = value of current board_numbers address
	beq  $t6, $t2, update
	addi $t3, $t3, 4		# increment board_numbers address
	addi $t0, $t0, 4		# increment game_board address
	addi $t5, $t5, -1		# decrement counter
	bnez $t5, loop

update:
	lw $t7, 0($t0)			# $t7 = value of current game_board copy address
	bnez $t7, invalid_input		# if $t7 is not zero, it's occupied so pick another number

	li $t7, 1			# $t7 = value of player move
	sw $t7, 0($t0)			# set game_board to 1
	
	sw $a0, last_move
	
	# Validate game state
	# Check for 4 consecutive 1's
	li $t1, 1
    	la $t0, game_board
    	jal check_consecutive
    	beq $v0, 1, found_ones

	# Update UI
	jal print_last_move
	
	# Computer move
	lw $t1, last_move
	la $t0, game_board

	jal computer_move

	sw $t1, last_move
	
	# Validate game state
	
	# Check for 4 consecutive 2's
    	li $t1, 2
    	la $t0, game_board
    	jal check_consecutive
	beq $v0, 1, found_twos
    
	# Update UI
	
	j game_loop
	
exit:
	li $v0, 10
	syscall
	
print_last_move:
	# Print last move
	li $v0, 4
	la $a0, prev_prompt
	syscall

	li, $v0, 1
	lw $a0, last_move
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	jr $ra

invalid_input:
	li $v0, 4
    	la $a0, occupied_msg
    	syscall
    	
    	j user_input
