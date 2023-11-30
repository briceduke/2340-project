.data
array:      .word 1, 1, 1, 1, 0, 0,
            .word 2, 2, 2, 2, 0, 0,
            .word 0, 0, 0, 0, 0, 0,
            .word 0, 0, 0, 0, 0, 0,
            .word 0, 0, 0, 0, 0, 0,
            .word 0, 0, 0, 0, 0, 0

newline:    .asciiz "\n"
result1:    .asciiz "4 consecutive 1's in a row or column\n"
result2:    .asciiz "4 consecutive 2's in a row or column\n"
result3:    .asciiz "Neither 1's nor 2's in a row or column\n"

.text
main:
    la $t0, array         # Load the base address of the array
    li $t1, 6             # Number of rows
    li $t2, 6             # Number of columns

    # Check rows
    jal check_rows

    # Check columns
    #jal check_columns

    # Print the result
    li $v0, 4              # Print string syscall code
    la $a0, result3         # Load the result string address
    syscall

    # Exit program
    li $v0, 10             # Exit syscall code
    syscall

check_rows:
    li $t3, 0              # Counter for consecutive occurrences
    li $t4, 4              # Number of consecutive occurrences needed
row_loop:
    beq $t3, $t4, row_found  # If 4 consecutive occurrences found, branch to row_found
    li $t5, 0              # Reset column index to 0 for each row
column_loop:
    lw $t6, 0($t0)         # Load element at the current position
    beq $t6, 1, increment1  # If the element is 1, branch to increment1
    beq $t6, 2, reset1      # If the element is 2, branch to reset1
    j reset2               # Otherwise, branch to reset2

increment1:
    addi $t3, $t3, 1       # Increment consecutive occurrences counter for 1
    j next_column          # Jump to next column

reset1:
    li $t3, 0              # Reset consecutive occurrences counter for 1
    j next_column          # Jump to next column

reset2:
    li $t3, 0              # Reset consecutive occurrences counter for 2

next_column:
    addi $t0, $t0, 4       # Move to the next column
    addi $t5, $t5, 1       # Increment column index
    bne $t5, $t2, column_loop  # If not at the end of the row, repeat the loop

    # If reached here, move to the next row
    addi $t1, $t1, -1      # Decrement row index
    beq $t1, $zero, no_row_found  # If at the end of the array, branch to no_row_found
    j row_loop             # Repeat the loop for the next row

row_found:
    li $v0, 4              # Print string syscall code
    la $a0, result1        # Load the result1 string address
    syscall
    j end_check_rows

no_row_found:
    j end_check_rows

end_check_rows:
    jr $ra                 # Return from the function

