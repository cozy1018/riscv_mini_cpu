module alu (output logic signed [31:0] ALUResult,
            output logic Zero, Negative,
            input logic signed [31:0] SrcA, SrcB,
            input logic [4:0] ALUControl);

// For shift operations, extract lower 5 bits.
  logic [4:0] shift_amount;
  assign shift_amount = SrcB[4:0];

  // For LUI, extract lower 20 bits.
  logic [19:0] lui_immediate;
  assign lui_immediate = SrcB[19:0];

  always_comb begin
    case (ALUControl)
      // Addition operations (for add, addi, lw, sw, jal, jalr)
      5'b00010: ALUResult = SrcA + SrcB;

      // Subtraction operations (for sub, beq, bne)
      5'b00001: ALUResult = SrcA - SrcB;

      // OR operations (for or, ori)
      5'b00111: ALUResult = SrcA | SrcB;

      // AND operations (for and, andi)
      5'b00011: ALUResult = SrcA & SrcB;

      // Shift Left Logical (for sll, slli)
      5'b00000: ALUResult = SrcA << shift_amount;

      // Shift Right Logical (for srl, srli)
      5'b10000: ALUResult = SrcA >> shift_amount;

      // Set Less Than (for slt, slti, blt)
      5'b01010: ALUResult = (SrcA < SrcB) ? 32'd1 : 32'd0;

      // Branch Greater or Equal (for bge)
      5'b01001: ALUResult = (SrcA >= SrcB) ? 32'd1 : 32'd0;

      // Load Upper Immediate (lui)
      5'b11111: ALUResult = {lui_immediate, 12'b0};

      default:  ALUResult = 32'd0;
    endcase
  end

  // Flags
  assign Zero     = (ALUResult == 32'd0);
  assign Negative = ALUResult[31];

endmodule