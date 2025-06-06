`timescale 1ns/1ps
`include "extend.sv"

// extend_tb.sv - Testbench for extend
module extend_tb;
    logic [31:0] Instr;
    logic [2:0] ImmSrc;
    logic [31:0] ImmExt;
   
    extend dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );
   
    initial begin
        $dumpfile("extend_tb.vcd");
        $dumpvars(0, extend_tb);
        $monitor("t = %3d | Instr = %h | ImmSrc = %b | ImmExt = %h", $time, Instr, ImmSrc, ImmExt);
       
        // Test I-Type Immediate (ADDI)
        Instr = 32'h03200093; ImmSrc = 3'b000; // addi x1, x0, 50
        #10;

        // Test S-Type Immediate (SW)
        Instr = 32'hfe302e23; ImmSrc = 3'b001; // sw x3, -4(x0)
        #10;

        // Test B-Type Immediate (BEQ)
        Instr = 32'h00000063; ImmSrc = 3'b010; // beq x0, x0, 0
        #10;

        // Test U-Type Immediate (LUI)
        Instr = 32'h00001037; ImmSrc = 3'b011; // lui x2, 1
        #10;

        // Test J-Type Immediate (JAL)
        Instr = 32'h000000ef; ImmSrc = 3'b100; // jal x1, 0
        #10;

        // End Simulation
        $display("All tests completed.");
        $finish;
    end
endmodule
