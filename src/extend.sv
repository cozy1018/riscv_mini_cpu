module extend (
    output logic [31:0] ImmExt,
    input logic [31:0] Instr,
    input logic [2:0] ImmSrc
);

// Sign bit extraction
logic sign_bit;
assign sign_bit = Instr[31];

// Immediate generation using separate assign statements
assign ImmExt = (ImmSrc == 3'b000) ? {{20{sign_bit}}, Instr[31:20]} :  // I-Type (addi, lw, jalr)
                (ImmSrc == 3'b001) ? {{20{sign_bit}}, Instr[31:25], Instr[11:7]} :  // S-Type (sw)
                (ImmSrc == 3'b010) ? {{19{sign_bit}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0} :  // B-Type (beq, bne, blt, bge)
                (ImmSrc == 3'b011) ? {Instr[31:12], 12'b0} :  // U-Type (lui)
                (ImmSrc == 3'b100) ? {{11{sign_bit}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0} :  // J-Type (jal) (Fixed sign extension)
                32'b0;  // Default case to prevent latch inference

endmodule
