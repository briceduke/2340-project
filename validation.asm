.data
matrix: .word 1, 1, 1, 0, 0, 0
        .word 1, 2, 2, 2, 0, 0
        .word 1, 0, 0, 0, 0, 0
        .word 1, 0, 1, 1, 0, 0
        .word 0, 0, 0, 0, 0, 0
        .word 0, 0, 0, 0, 0, 0
result_msg: .asciiz "Neither 1's nor 2's in a row.\n"
ones_msg: .asciiz "4 consecutive 1's in a row or column.\n"
twos_msg: .asciiz "4 consecutive 2's in a row or column.\n"

.text
.globl check_consecutive, found_ones, found_twos, result_msg

found_ones:
    li $v0, 4
    la $a0, ones_msg
    syscall
    jal win_sound
    j end_program

found_twos:
    li $v0, 4
    la $a0, twos_msg
    syscall
    jal loss_sound
    j end_program

check_consecutive:
    # $t0: base address of the matrix
    # $t1: value to check for (1 or 2)
    # Return: $v0 = 1 if consecutive elements found, 0 otherwise
    
    la $t9, ($t0)

    li $t2, 0   # Counter for consecutive elements
    li $t3, 4   # Number of consecutive elements to check
    li $t6, 36

    # Loop through each row
    row_loop:
        li $t2, 0   # Reset consecutive counter

        # Loop through each column
        col_loop:
            lw $t4, 0($t0)   # Load matrix element
            beq $t4, $t1, inc_counter
            j reset_counter

        inc_counter:
            addi $t2, $t2, 1   # Increment consecutive counter
            bge $t2, $t3, consecutive_found   # Check if 4 consecutive elements found
            j next_column

        reset_counter:
            li $t2, 0   # Reset consecutive counter

        next_column:
            beqz $t6, consecutive_not_found
	    #sll $t5, $t2, 2    # Calculate the offset (4 * consecutive counter)
            addi $t0, $t0, 4  # Move to the next column
            add $t6, $t6, -1
            j col_loop

        consecutive_found:
            li $v0, 1
            j end_check

       	consecutive_not_found:
       		li $t7, -1

    column_loop:
    	la $t0, ($t9)
        li $t2, 0   # Reset consecutive counter
	li $t6, 6
	
	beq $t7, 6, c_not_found
	
	addi $t7, $t7, 1
	
	sll $t8, $t7, 2
	
	add $t0, $t0, $t8
	
        # Loop through each column
        r_loop:
            lw $t4, 0($t0)   # Load matrix element
            beq $t4, $t1, i_counter
            j r_counter

        i_counter:
            addi $t2, $t2, 1   # Increment consecutive counter
            bge $t2, $t3, c_found   # Check if 4 consecutive elements found
            j next_row

        r_counter:
            li $t2, 0   # Reset consecutive counter

        next_row:
            beqz $t6, column_loop
            addi $t0, $t0, 24  # Move to the next row
            add $t6, $t6, -1
            j r_loop

        c_found:
            li $v0, 1
            j end_check

       	c_not_found:
            j end_check

    end_check:
        jr $ra

end_program:
    li $v0, 10   # Exit program
    syscall
