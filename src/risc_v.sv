`include "instruction_memory.sv"
`include "reg_file.sv"
`include "extend.sv"
`include "alu.sv"
`include "data_memory_and_io.sv"
`include "program_counter.sv"
`include "control_unit.sv"

module risc_v(output logic [31:0] CPUOut,
                input logic [31:0] CPUIn,
                input logic Reset, CLK);

logic [31:0] Instr, WD3, RD1, RD2, SrcA, SrcB, ALUResult, WD, RD, Result, ImmExt, PCTarget, PCNext, PC, PCPlus4;
logic [4:0]  A1, A2, A3;
logic        MemWrite, ALUSrc, RegWrite;
logic        Zero, Negative;
logic [4:0]  ALUControl;
logic [2:0]  ImmSrc;
logic [1:0]  ResultSrc;
logic [1:0]  PCSrc;

// Extract register addresses from the instruction:
  assign A1 = Instr[19:15]; // rs1
  assign A2 = Instr[24:20]; // rs2
  assign A3 = Instr[11:7];  // rd

  // Instantiate the Program Counter.
  program_counter pc_inst (
    .PC(PC),
    .PCPlus4(PCPlus4),
    .PCTarget(PCTarget),
    .ALUResult(ALUResult),
    .PCSrc(PCSrc),
    .Reset(Reset),
    .CLK(CLK)
  );

  // Instantiate the Instruction Memory.
  instruction_memory imem_inst (
    .PC(PC),
    .Instr(Instr)
  );

  // Instantiate the Control Unit.
  control_unit cu_inst (
    .PCSrc(PCSrc),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ALUControl(ALUControl),
    .ImmSrc(ImmSrc),
    .Instr(Instr),
    .Zero(Zero),
    .Negative(Negative)
  );

  // Instantiate the Extend Unit.
  extend ext_inst (
    .Instr(Instr),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
  );

  // Instantiate the Register File.
  reg_file rf_inst (
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .WD3(WD3),
    .RD1(RD1),
    .RD2(RD2),
    .WE3(RegWrite),
    .CLK(CLK)
  );

  // ALU operand multiplexers:
  assign SrcA = RD1;
  assign SrcB = (ALUSrc) ? ImmExt : RD2;

  // Instantiate the ALU.
  alu alu_inst (
    .ALUResult(ALUResult),
    .Zero(Zero),
    .Negative(Negative),
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl)
  );

  // Instantiate the Data Memory and I/O module.
  data_memory_and_io dmem_inst (
    .RD(RD),
    .CPUOut(CPUOut),
    .A(ALUResult),
    .WD(RD2),
    .CPUIn(CPUIn),
    .WE(MemWrite),
    .CLK(CLK)
  );

  // Write-back multiplexer for the Register File.
  assign WD3 = (ResultSrc == 2'b00) ? ALUResult :
               (ResultSrc == 2'b01) ? RD :
               (ResultSrc == 2'b10) ? PCPlus4 :
               (ResultSrc == 2'b11) ? ImmExt : 32'd0;

  // Compute the branch/jump target address.
  // Here we simply add ImmExt to the current PC.
  assign PCTarget = PC + ImmExt;

endmodule