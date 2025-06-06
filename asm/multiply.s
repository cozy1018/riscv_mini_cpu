    .option norvc                # Disable compressed instructions (for clarity)
    .section .text
    .globl _start                # Make _start a global entry point

_start:
    lui     x31, 0x80000         # x31 = 0x80000000
    addi    x31, x31, -4         # x31 = 0x7FFFFFFC
    addi    s0, zero, 8          # s0 = 8  (multiplicand)
    addi    s1, zero, 9          # s1 = 9  (multiplier)

    addi    s2, zero, 0          # s2 = 0  (P)
    addi    t0, zero, 0          # t0 = 0  (i)

Loop:
    andi    t1, s1, 1            # t1 = (s1 & 1)
    beq     t1, zero, Skip       # if LSB == 0, skip adding s0 to partial product

    add     s2, s2, s0

Skip:
    slli    s0, s0, 1            # s0 <<= 1
    srli    s1, s1, 1            # s1 >>= 1

    addi    t0, t0, 1            # i = i + 1
    addi    t1, zero, 8
    bne     t0, t1, Loop         # if i != 8, continue loop

    sw      s2, 0(x31)           # CPUOut = s2

Stop:
    j       Stop