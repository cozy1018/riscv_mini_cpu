`timescale 1ns/1ps
`include "program_counter.sv"


// program_counter_tb.sv - Testbench for program_counter
module program_counter_tb;
    logic [31:0] PC, PCPlus4;
    logic [31:0] PCTarget, ALUResult;
    logic [1:0] PCSrc;
    logic Reset, CLK;
   
    // Instantiate the DUT (Device Under Test)
    program_counter dut (
        .PC(PC),
        .PCPlus4(PCPlus4),
        .PCTarget(PCTarget),
        .ALUResult(ALUResult),
        .PCSrc(PCSrc),
        .Reset(Reset),
        .CLK(CLK)
    );
   
    // Clock Generation (10ns period)
    always #5 CLK = ~CLK;
   
    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);
        $monitor("t = %3d, PC = %h, PCPlus4 = %h, PCSrc = %b", $time, PC, PCPlus4, PCSrc);
       
        // Initialize signals
        CLK = 0; 
        Reset = 1; 
        PCSrc = 2'b00; 
        PCTarget = 32'h00000010;
        ALUResult = 32'h00000040;
        
        #10 Reset = 0;  // Release reset

        // Case 1: PCSrc = 00 (Sequential execution)
        #10 PCSrc = 2'b00;
        
        // Case 2: PCSrc = 01 (Branching)
        #10 PCSrc = 2'b01;
        #10 PCTarget = 32'h00000020; // Change target for demonstration
        
        // Case 3: PCSrc = 10 (Jump Register)
        #10 PCSrc = 2'b10;
        #10 ALUResult = 32'h00000040; // Change ALU result for demonstration

        // End simulation
        #10 $finish;
    end
endmodule