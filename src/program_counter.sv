module program_counter (output logic [31:0] PC, PCPlus4,
                        input logic [31:0] PCTarget, ALUResult,
                        input logic [1:0] PCSrc,
                        input logic Reset, CLK);


logic [31:0] pc_reg; // Internal register to hold PC value

    // PC update logic (synchronous reset and clock edge-triggered)
    always_ff @(posedge CLK) begin
        if (Reset)
            pc_reg <= 32'h00000000; // Reset PC to 0x00000000
        else begin
            case (PCSrc)
                2'b00: pc_reg <= pc_reg + 4;   // Normal increment (for sequential execution)
                2'b01: pc_reg <= PCTarget;     // Branch target address (for beq, bne, blt, bge)
                2'b10: pc_reg <= ALUResult;    // JALR (Jump Register target)
                default: pc_reg <= pc_reg + 4; // Default to sequential execution
            endcase
        end
    end

    // Assign outputs
    assign PC = pc_reg;
    assign PCPlus4 = pc_reg + 4; // Always compute PC + 4

endmodule