module control_unit (output logic [1:0] PCSrc, 
                    output logic [1:0] ResultSrc,
                    output logic MemWrite, ALUSrc, RegWrite,
                    output logic [4:0] ALUControl,
                    output logic [2:0] ImmSrc,
                    input logic [31:0] Instr,
                    input logic Zero, Negative);

// Extract fields from the instruction
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic       funct7_bit;
  
  assign opcode    = Instr[6:0];    // opcode field
  assign funct3    = Instr[14:12];  // funct3 field
  assign funct7_bit= Instr[30];     // funct7[5] bit (for add/sub distinction)

  always_comb begin
    // Default control signal values:
    PCSrc     = 2'b00;      // Next instruction (PC+4)
    ResultSrc = 2'b00;      // Default: ALU result
    MemWrite  = 0;
    ALUSrc    = 0;          // Default: use register operand
    RegWrite  = 0;
    ALUControl= 5'b00010;   // Default: addition (5'b00010)
    ImmSrc    = 3'b000;     // Default: I-Type immediate

    case (opcode)
      // R-Type Instructions (Register-Register ALU operations)
      7'b0110011: begin 
          RegWrite = 1;
          ALUSrc   = 0; // use register operands
          case (funct3)
            3'b000: ALUControl = (funct7_bit) ? 5'b00001 : 5'b00010; // SUB if funct7=1, ADD if not
            3'b110: ALUControl = 5'b00111; // OR
            3'b111: ALUControl = 5'b00011; // AND
            3'b001: ALUControl = 5'b00000; // SLL
            3'b101: ALUControl = 5'b10000; // SRL
            3'b010: ALUControl = 5'b01010; // SLT
            default: ALUControl = 5'b00010; // Default to addition
          endcase
      end

      // I-Type Instructions (Immediate ALU operations & Loads)
      7'b0010011: begin 
          RegWrite = 1;
          ALUSrc   = 1; // immediate
          ImmSrc   = 3'b000; // I-Type immediate
          case (funct3)
            3'b000: ALUControl = 5'b00010; // ADDI: addition
            3'b110: ALUControl = 5'b00111; // ORI
            3'b111: ALUControl = 5'b00011; // ANDI
            3'b001: ALUControl = 5'b00000; // SLLI: shift left
            3'b101: ALUControl = 5'b10000; // SRLI: shift right logical
            3'b010: ALUControl = 5'b01010; // SLTI: set less than
            default: ALUControl = 5'b00010;
          endcase
      end

      // Load Word (LW)
      7'b0000011: begin 
          RegWrite = 1;
          ALUSrc   = 1;      // Use immediate offset
          ImmSrc   = 3'b000; // I-Type immediate
          ResultSrc= 2'b01;  // Data from memory
          ALUControl = 5'b00010; // Addition for address calculation
      end

      // Store Word (SW)
      7'b0100011: begin 
          MemWrite = 1;
          ALUSrc   = 1;      // Use immediate offset
          ImmSrc   = 3'b001; // S-Type immediate
          ALUControl = 5'b00010; // Addition for address calculation
      end

      // Branch Instructions (BEQ, BNE, BLT, BGE)
      7'b1100011: begin 
          ALUSrc   = 0;       // Compare registers
          ImmSrc   = 3'b010;   // B-Type immediate
          ALUControl = 5'b00001; // Subtraction for comparison
          case (funct3)
            3'b000: if (Zero) PCSrc = 2'b01; // BEQ: branch if equal
            3'b001: if (!Zero) PCSrc = 2'b01; // BNE: branch if not equal
            3'b100: if (Negative) PCSrc = 2'b01; // BLT: branch if less than
            3'b101: if (!Negative || Zero) PCSrc = 2'b01; // BGE: branch if greater or equal
            default: PCSrc = 2'b00;
          endcase
      end

      // Jump and Link (JAL)
      7'b1101111: begin 
          PCSrc    = 2'b01;   // Jump to target address
          RegWrite = 1;       // Write PC+4 to register
          ResultSrc= 2'b10;   // Use PC+4 as write-back data
          ImmSrc   = 3'b100;   // J-Type immediate
          ALUControl = 5'b00010; // Addition (for PC+4 calculation)
      end

      // Jump and Link Register (JALR)
      7'b1100111: begin 
          PCSrc    = 2'b10;   // Jump to computed address
          RegWrite = 1;       // Write PC+4 to register
          ResultSrc= 2'b10;   // Use PC+4 as write-back data
          ImmSrc   = 3'b000;   // I-Type immediate
          ALUControl = 5'b00010; // Addition (for PC+4 calculation)
      end

      // Load Upper Immediate (LUI)
      7'b0110111: begin 
          RegWrite = 1;
          ImmSrc   = 3'b011;   // U-Type immediate
          ResultSrc= 2'b11;    // Load immediate directly
          ALUControl = 5'b11111; // For LUI, the ALU just outputs the immediate shifted
      end

      default: begin
          // Keep default values
      end
    endcase
  end
endmodule