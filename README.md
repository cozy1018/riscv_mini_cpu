# RISC-V Mini CPU (SystemVerilog)

This project implements a modular, lightweight RISC-V-compatible processor written in SystemVerilog.  
It supports a subset of RISC-V instructions and simulates full instruction execution, including arithmetic, logic, control flow, and memory operations.

All modules and testbenches were written and verified using Icarus Verilog and GTKWave.

---

## Features

- RTL Modules:
  - ALU (arithmetic and logic unit)
  - Program Counter
  - Control Unit (decoder)
  - Register File
  - Instruction and Data Memory
  - Extend / Immediate decoder
- Instruction Support:
  - R-type, I-type, B-type, J-type, U-type
- Test Programs:
  - Count number of 1s in a byte (looping + conditional)
  - Multiply two values using shift-and-add
- Manual machine code loading into instruction memory
- Testbenches for each module and top-level integration

---

## Project Structure
```
src/        # All SystemVerilog RTL modules  
tb/         # Testbenches for each module  
sim/        # Simulation script and output (e.g. VCD)  
asm/        # RISC-V machine code test programs  
```

---

## How to Simulate

All modules and the top-level CPU were verified using Icarus Verilog (`iverilog`) and GTKWave.

### Example: Run Top-Level CPU Testbench

```bash
iverilog -g2012 -o risc_v_tb ../tb/risc_v_tb.sv ../src/*.sv
vvp risc_v_tb
gtkwave risc_v_tb.vcd