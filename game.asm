.data
game_board: .space  144  	# 6 rows x 6 columns x 4 bytes
last_move: .word   0

.text
.globl main
	
main:
	# Initialize game board
    	la $t0, game_board
    	li $t1, 36		# counter
    	li $t2, 0

init_loop: 
	sw $t2, 0($t0)		# set to zero
	addi $t0, $t0, 4    	# move to next element
	addi $t1, $t1, -1   	# decrement counter
	bnez $t1, init_loop

	# Generate first move
    	li $v0, 42		# bounded random integer
	li $a0, 0
	li $a1, 9		# upper bound is not inclusive
	syscall

	addi $a0, $a0, 1

	sw $a0, last_move

game_loop:
	# Player input
	
	# Player move
	
	# Validate game state
	
	# Update UI
	li $v0, 11
	li $a0, '\n'
	syscall
	
	li, $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	# Computer move
	lw $t1, last_move
	la $t0, game_board
	jal computer_move
	
	# Validate game state

	li $v0, 1
	add $a0, $t1, $zero
	syscall
	
	# Update UI
	
	# j game_loop
	
exit:
	li $v0, 10
	syscall
