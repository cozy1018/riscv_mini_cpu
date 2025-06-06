`timescale 1ns/1ps
`include "control_unit.sv"

// control_unit_tb.sv - Testbench for control_unit
module control_unit_tb;
    logic [1:0] PCSrc, ResultSrc;
    logic MemWrite, ALUSrc, RegWrite;
    logic [4:0] ALUControl;
    logic [2:0] ImmSrc;
    logic [31:0] Instr;
    logic Zero, Negative;

    // Instantiate DUT (Device Under Test)
    control_unit dut (
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

    // Test Procedure
    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
        
        $monitor("t = %3d | Instr = %h | PCSrc = %b | ALUControl = %b | ALUSrc = %b | RegWrite = %b | MemWrite = %b | ResultSrc = %b | ImmSrc = %b",
         $time, Instr, PCSrc, ALUControl, ALUSrc, RegWrite, MemWrite, ResultSrc, ImmSrc);
        
        // Test ADDI (Immediate Addition)
        Instr = 32'h03200093; // addi x1, x0, 50
        #10;

        // Test LW (Load Word)
        Instr = 32'hffc02103; // lw x2, -4(x0)
        #10;

        // Test SUB (Subtract)
        Instr = 32'h402081b3; // sub x3, x1, x2
        #10;

        // Test SW (Store Word)
        Instr = 32'hfe302e23; // sw x3, -4(x0)
        #10;

        // Test BEQ (Branch if Equal)
        Instr = 32'h00000063; // beq x0, x0, 0
        Zero = 1; // Assign only when needed
        #10;

        // Test JAL (Jump and Link)
        Instr = 32'h000000ef; // jal x1, offset
        #10;

        // Test JALR (Jump and Link Register)
        Instr = 32'h000100e7; // jalr x1, offset(x2)
        #10;

        // Test LUI (Load Upper Immediate)
        Instr = 32'h00001037; // lui x2, imm
        #10;

        $display("All tests completed.");
        $finish;
    end
endmodule
