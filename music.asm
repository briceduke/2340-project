.data
loss_note: .byte 69
win_note: .byte 67

duration: .byte 100
organ: .byte 16
brass: .byte 56
volume: .byte 100

.text
.globl win_sound, loss_sound

# $a0 = pitch (0-127)
# $a1 = duration in milliseconds
# $a2 = instrument (0-127)
# $a3 = volume (0-127)

#########################################################################
#									#
#   Initially load the duration, volume, instrument, and first note,    #
#   then add to the note to get other notes and shift the duration to   #
#   create longer/shorter notes.                                        #
#									#
#########################################################################

win_sound:
	li $v0, 33
	la $a0, win_note
	lbu $a0 0($a0)
	la $a1, duration
	lbu $a1, 0($a1)
	la $a2, brass
	lbu $a2, 0($a2)
	la $a3, volume
	syscall

	addi $a0, $a0, 5
	syscall

	addi $a0, $a0, 4
	syscall

	addi $a0, $a0, 3
	sll $a1, $a1, 1
	syscall

	addi $a0, $a0, -3
	srl $a1, $a1, 1
	syscall

	addi $a0, $a0, 3
	sll $a1, $a1, 3
	syscall

	jr $ra

loss_sound:
	li $v0, 33
	la $a0, loss_note
	lbu $a0 0($a0)
	la $a1, duration
	lbu $a1, 0($a1)
	la $a2, organ
	lbu $a2, 0($a2)
	la $a3, volume
	syscall

	addi $a0, $a0, -2
	syscall

	addi $a0, $a0, 2
	sll $a1, $a1, 4
	syscall

	addi $a0, $a0, -2
	srl $a1, $a1, 4
	syscall

	addi $a0, $a0, -2
	syscall

	addi $a0, $a0, -1
	syscall

	addi $a0, $a0, -2
	syscall

	addi $a0, $a0, -1
	sll $a1, $a1, 2
	syscall

	addi $a0, $a0, 1
	sll $a1, $a1, 1
	syscall

	jr $ra
