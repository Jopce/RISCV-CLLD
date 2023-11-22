.section .text
.globl _start

_start:
	# "R" 82=0x52
	addi a0, zero, 0x52
	jal ra, alloc_node

	blt a0, zero, terminate
	
	# I will store the R (head) in the s1 exclusively
	add s1, zero, a0

	# "V" 86=0x56
	addi a0, zero, 0x56
	jal ra, alloc_node

	blt a0, zero, terminate
	
	add a1, zero, a0
	add a0, zero, s1
	jal ra, add_tail

	# "I" 74=0x49
	addi a0, zero, 0x49
        jal ra, alloc_node

	blt a0, zero, terminate

	add a1, zero, a0
	add a0, zero, s1
	jal ra, add_tail

	# "S" 83=0x53
	add a0, zero, 0x53
	jal ra, alloc_node

	blt a0, zero, terminate

	add a1, zero, a0
	add a0, zero, s1
	jal ra, add_tail

	# "C" 67=0x43
        add a0, zero, 0x43
        jal ra, alloc_node

	blt a0, zero, terminate

        add a1, zero, a0
        add a0, zero, s1
        jal ra, add_tail
	
	add t5, zero, zero	
	add a0, zero, s1
	jal ra, print_list

	blt a0, zero, terminate

	# V is next from head
	ld t0, 8(s1)
	add a1, zero, t0
	add a0, zero, s1
	jal ra, del_node

	blt a0, zero, terminate

	# print is only before del. as per requirements
	# add t5, zero, zero
	# add a0, zero, s1
        # jal ra, print_list
	
	addi a0, zero, 0
        addi a7, zero, 93
        ecall

# args: a0: val
alloc_node:
	add t0, zero, a0

	# 222 is syscall for mmap args: mmap(0, LEN (3*8B), 0x3, 0x22, -1, 0)
	addi a7, zero, 222
	
	addi a0, zero, 0
	addi a1, zero, 24
	addi a2, zero, 0x3
	addi a3, zero, 0x22
	addi a4, zero, -1
	addi a5, zero, 0

	ecall

	blt a0, zero, alloc_err

	# add 0xA and shift by 7Bytes to MSB
	addi t1, zero, 0x0A
	slli t1, t1, 56
	or t0, t0, t1

	# set the val and next/prev to itself
	sd t0, 0(a0)
	sd a0, 8(a0)
	sd a0, 16(a0)

	# returns address in a0
	jalr zero, ra, 0

	alloc_err:
		addi a0, zero, -1
		jalr zero, ra, 0

# args: a0: address of head node
# a1: address of the new node
add_tail:
	# tail before
	ld t0, 16(a0)

	# update head and old tail
	sd a1, 8(t0)
	sd t0, 16(a1)
	
	sd a0, 8(a1)
	sd a1, 16(a0)

	jalr zero, ra, 0 

# args: a0: head node
# a1: node to be deleted
del_node:
	ld t0, 16(a1) 
	ld t1, 8(a1)

	sd t1, 8(t0)
	sd t0, 16(t1)

	# munmap(addr, len, 0)
	addi a7, zero, 215
	add a0, zero, a1
	addi a1, zero, 8
	add a2, zero, zero 
	ecall
	
	blt a0, zero, del_error
	
	add a0, zero, s1
	jalr zero, ra, 0
	
	del_error:
		addi a0, zero, -1
		jalr zero, ra, 0 

# args: a0: head node
print_list:
	add t0, zero, a0

	# write(1, addr, len)
	addi a7, zero, 64
	addi a0, zero, 1
	add a1, zero, t0
	addi a2, zero, 8
	ecall

	blt a0, zero, print_err

	ld a0, 8(t0)
	addi t5, t5, 8
	bne a0, s1, print_list

	# returns -1 if print failed
        # else returns number of Bytes written
	add a0, zero, t5
	jalr zero, ra, 0

	print_err:
		addi a0, zero, -1
		jalr zero, ra, 0

terminate:
	addi a7, zero, 93
	addi a0, zero, 125  
	ecall
