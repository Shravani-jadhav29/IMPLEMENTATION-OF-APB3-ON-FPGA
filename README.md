
# Implementation of APB3 Protocol on FPGA

An implementation and verification environment for the **AMBA Advanced Peripheral Bus 3 (APB3)** protocol targeted for FPGA synthesis and testing.

---

## 📌 Overview
The Advanced Peripheral Bus (APB3) is part of the ARM AMBA protocol family designed for low-bandwidth, low-power peripheral communication. This repository contains the Verilog/SystemVerilog RTL implementation of an APB3 Master and Slave interface, complete with testbenches and FPGA implementation files.

---

## ✨ Features
* **Full APB3 Compliance:** Implements `PSEL`, `PENABLE`, `PWRITE`, `PADDR`, `PWDATA`, `PRDATA`, `PREADY`, and `PSLVERR`.
* **Wait State Support:** Handles slave stall scenarios using the `PREADY` signal.
* **Error Detection:** Supports error reporting via `PSLVERR`.
* **Synthesis Ready:** Designed for implementation on Xilinx/Altera FPGA platforms.
* **Verification:** Includes testbenches for read/write transactions with timing simulations.

---

## 🏗 System Architecture

### APB3 State Machine
1. **IDLE:** Default state; no active transfer (`PSEL = 0`, `PENABLE = 0`).
2. **SETUP:** Transfer initiated; address and control signals driven (`PSEL = 1`, `PENABLE = 0`).
3. **ACCESS:** Transfer completed on clock edge when `PREADY = 1` (`PSEL = 1`, `PENABLE = 1`).

---

## 📁 Repository Structure
```text
├── rtl/                # RTL source code (Master, Slave, Top)
├── tb/                 # Testbenches and simulation scripts
├── fpga/               # Constraints files (.xdc/.qsf) and synthesis scripts
├── docs/               # Waveforms, timing diagrams, and documentation
└── README.md           # Project overview.


----

##🚀 Getting Started
```text
Prerequisites
Simulation: ModelSim / EDA Playground / Vivado Simulator

Synthesis: Xilinx Vivado / Intel Quartus Prime

Simulation
To run the testbench in Vivado:

# Launch simulation using Vivado CLI
vivado -mode batch -source scripts/run_sim.tcl
