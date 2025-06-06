`timescale 1ns/1ps
`include "alu.sv"

// alu_tb.sv - Testbench for ALU
module alu_tb;
    logic signed [31:0] SrcA, SrcB, ALUResult;
    logic Zero, Negative;
    logic [4:0] ALUControl;
    
    // Instantiate the ALU module
    alu dut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Negative(Negative),
        .ALUControl(ALUControl)
    );

    // Generate the waveform file
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    // Apply test cases
    initial begin
        $monitor("t = %3d | SrcA = %d | SrcB = %d | ALUControl = %b | ALUResult = %d | Zero = %b | Negative = %b",
         $time, SrcA, SrcB, ALUControl, ALUResult, Zero, Negative);
        
        // Test 1: Addition (add, addi, lw, sw)
        SrcA = 50; SrcB = 20; ALUControl = 5'b00010;
        #10;

        // Test 2: Subtraction (sub)
        SrcA = 50; SrcB = 20; ALUControl = 5'b01010;
        #10;

        // Test 3: Subtraction (beq - should set Zero flag)
        SrcA = 50; SrcB = 50; ALUControl = 5'b01010;
        #10;

        // Test 4: OR (or, ori)
        SrcA = 32'h0000FFFF; SrcB = 32'hFFFF0000; ALUControl = 5'b00111;
        #10;

        // Test 5: AND (and, andi)
        SrcA = 32'h0000FFFF; SrcB = 32'hFFFF0000; ALUControl = 5'b00011;
        #10;
    end
endmodule
