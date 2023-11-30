.data
board:
    .word 1, 2, 3, 4, 5, 6                # First row
    .word 7, 8, 9, 10, 12, 14             # Second row
    .word 15, 16, 18, 20, 21, 24          # Third row
    .word 25, 27, 28, 30, 32, 35          # Fourth row
    .word 36, 40, 42, 45, 48, 49          # Fifth row
    .word 54, 56, 63, 64, 71, 81          # Sixth row
newline: .asciiz "\n"
space: .asciiz " "
prompt: .asciiz "Enter a number (1-9): "
error_msg: .asciiz "Invalid input. Enter a number between 1 and 9.\n"

.text
.globl get_user_input, input_error

main:
    # Display the board
    jal display_board

    # Get user input
    jal get_user_input

    # Exit the program
    li $v0, 10
    syscall

display_board:
    la $a1, board                  # Load base address of the board into $a1
    li $t0, 0                      # Initialize row counter to 0
    li $t1, 6                      # Total number of rows is 6

display_rows:
    beq $t0, $t1, end_display
    li $t3, 0                      # Initialize column counter to 0
    li $t4, 6                      # Total number of columns is 6

display_columns:
    beq $t3, $t4, next_row         
    lw $t5, 0($a1)                 # Load the value from the board into $t5
    move $a0, $t5                  # Move the value to $a0 to print it
    li $v0, 1                      # System call for print_int
    syscall

    # Print a space
    li $v0, 4
    la $a0, space
    syscall

    addiu $a1, $a1, 4              # Move to the next cell in the same row
    addiu $t3, $t3, 1              # Increment column counter
    j display_columns              # Loop back to display the next column

next_row:
    li $v0, 4                      # Print new line
    la $a0, newline
    syscall

    addiu $t0, $t0, 1              # Increment row counter
    sll $t6, $t0, 2                # Calculate the byte offset for one row (row number * 4 bytes/word)
    mul $t6, $t6, $t4              # Adjust for the number of columns (6 words per row)
    la $a1, board                  # Reload the base address of the board
    add $a1, $a1, $t6              # Add the row offset to the base address
    j display_rows                 # Loop back to display the next row

end_display:
    jr $ra                         # Return from display_board


get_user_input:
    # Prompt user for input
    li $v0, 4
    la $a0, prompt
    syscall

    # Read the input number
    li $v0, 5
    syscall

    # Store the input value in $t0
    move $t2, $v0

    blt $t2, 1, input_error       # If input is less than 1, jump to input_error
    bgt $t2, 9, input_error       # If input is greater than 9, jump to input_error

    jr $ra                         # Return from get_user_input

input_error:
   
    li $v0, 4
    la $a0, error_msg
    syscall

    # Jump back to get_user_input to try again
    j get_user_input             

