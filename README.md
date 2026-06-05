# Synchronous FIFO Memory Block

A hardware implementation of a **Synchronous FIFO (First-In, First-Out) Memory Buffer** designed in synthesizable Verilog HDL and verified using Xilinx Vivado. This core manages reliable data transmission boundaries across uniform clock domains.

## 🛠️ Architecture & Core Components

The architecture utilizes a dual-port RAM block coupled with pointer counters to execute single-cycle write and read manipulations:

* **Dual-Port Memory Matrix:** A parameterized $16 \times 8$ bit internal RAM block allocating stable storage lines for data tracking.
* **Pointer Counters:** Independent binary increment addresses managing write allocation lines (`wr_ptr`) and read depletion tracks (`rd_ptr`). Counters are designed with an extra MSB bit to clearly distinguish between 'completely full' and 'completely empty' memory states.
* **Status Flags:** Combinational control flags (`full`, `empty`) preventing internal data overwrite or underflow reading violations.

## 📂 Project Structure

```text
├── RTL/
│   └── syn_fifo.v       # Main Core Synchronous FIFO Logic
├── TESTBENCH/
│   └── syn_fifo_tb.v    # Simulation Verification Testbench
└── waveform.png         # Behavioral Simulation Timing Diagram
