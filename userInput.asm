.data
prompt: .asciiz "Enter a number (1-9): "
error_msg: .asciiz "Invalid input. Enter a number between 1 and 9.\n"

.text
.globl get_user_input, input_error

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

