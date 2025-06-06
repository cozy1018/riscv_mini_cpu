    .option norvc             # Disable compressed instructions
    .org 0
    .text
    .globl _start             # Define entry point

_start:
    lui     x10, 0x80000       # x10 = 0x80000000
    lw      x2, -4(x10)        # Load CPUIn from 0x7FFFFFFC into x2
    andi    x2, x2, 0xFF       # Mask CPUIn to keep only the lowest 8 bits
    addi    t0, zero, 0        # t0 = bit count = 0
    addi    t1, zero, 0        # t1 = loop counter = 0

Loop:
    andi    t3, x2, 1          # t3 = x2 & 1
    beq     t3, zero, Skip     # If LSB == 0, skip incrementing the count
    addi    t0, t0, 1          # If LSB == 1, increment bit count

Skip:
    srli    x2, x2, 1          # x2 >>= 1
    addi    t1, t1, 1          # Increment loop counter (i++)
    addi    t3, zero, 8        # t3 = 8 (total bits)
    bne     t1, t3, Loop       # If i != 8, repeat the loop
    sw      t0, -4(x10)        # Store t0 into memory at 0x80000000 - 4 = 0x7FFFFFFC

Stop:
    j       Stop               # Infinite loop