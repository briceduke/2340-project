.data
matrix: .word 1, 1, 1, 1, 0, 0
        .word 1, 2, 2, 2, 2, 0
        .word 1, 0, 0, 0, 0, 0
        .word 1, 0, 0, 0, 0, 0
        .word 0, 0, 0, 0, 0, 0
        .word 0, 0, 0, 0, 0, 0
result_msg: .asciiz "Neither 1's nor 2's in a row.\n"
ones_msg: .asciiz "4 consecutive 1's in a row or column.\n"
twos_msg: .asciiz "4 consecutive 2's in a row or column.\n"

.text
main:
    la $t0, matrix

    # Check for 4 consecutive 1's
    li $t1, 1
    jal check_consecutive
    beq $v0, 1, found_ones

    # Check for 4 consecutive 2's
    li $t1, 2
    jal check_consecutive
    beq $v0, 1, found_twos

    # No consecutive 1's or 2's found
    li $v0, 4
    la $a0, result_msg
    syscall
    j end_program

found_ones:
    li $v0, 4
    la $a0, ones_msg
    syscall
    j end_program

found_twos:
    li $v0, 4
    la $a0, twos_msg
    syscall
    j end_program

check_consecutive:
    # $t0: base address of the matrix
    # $t1: value to check for (1 or 2)
    # Return: $v0 = 1 if consecutive elements found, 0 otherwise

    li $t2, 0   # Counter for consecutive elements
    li $t3, 4   # Number of consecutive elements to check

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
            sll $t5, $t2, 2    # Calculate the offset (4 * consecutive counter)
            add $t0, $t0, $t5  # Move to the next column
            j end_check

        consecutive_found:
            li $v0, 1
            j end_check

    end_check:
        jr $ra

end_program:
    li $v0, 10   # Exit program
    syscall
