`timescale 1ns/1ps
`include "risc_v.sv"

module risc_v_tb;
logic [31:0] CPUOut, CPUIn;
logic Reset, CLK;

risc_v dut(CPUOut, CPUIn, Reset, CLK);

initial begin // Generate clock signal with 20 ns period
CLK = 0;
forever #10 CLK = ~CLK;
end

initial begin // Apply stimulus

$dumpfile("risc_v_tb.vcd");
        $dumpvars(0, risc_v_tb);
        
        // Apply initial reset and stimulus
        Reset = 1;
        CPUIn = 32'h7B;
        #40;           // Hold reset high for 40 ns

        Reset = 0;    // Release reset
        // Wait a few cycles for the CPU to start running
        #100;
        
        // Stimulate CPUIn if your design uses it for I/O operations
        CPUIn = 32'h7B;
        
        // Let the simulation run long enough to observe multiple instructions.
        #10000;
        
        $finish;
    end

always @ (negedge CLK)
$display ("t = %3d, CPUIn = %h, CPUOut = %h, Reset = %b, PCSrc = %b PC = %d, PCTarget = %h, ImmExt = %h, Instr = %h, ALUResult = %d", $time, CPUIn, CPUOut, Reset, dut.PCSrc, dut.PC, dut.PCTarget, dut.ImmExt, dut.Instr, dut.ALUResult);

endmodule
