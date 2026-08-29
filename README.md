# Implementation of APB3 Protocol on FPGA

A complete SystemVerilog/Verilog implementation and verification environment for the **AMBA Advanced Peripheral Bus 3 (APB3)** protocol, featuring modular slave peripherals and hardware output driving on FPGA.

---

## 📌 Overview
This repository contains an FPGA-targeted implementation of the ARM AMBA APB3 bus protocol. The architecture includes an APB3 Master, an Address Decoder, and custom APB3 Slave peripherals (FIFO and PWM generation) along with 7-segment display logic for hardware verification.

---

## ✨ Features
* **Full APB3 Protocol Support:** Implements standard control and data signals including `PSEL`, `PENABLE`, `PWRITE`, `PADDR`, `PWDATA`, `PRDATA`, `PREADY`, and `PSLVERR`.
* **Multi-Peripheral Support:** Decodes addresses to interface with distinct peripherals (FIFO, PWM).
* **Hardware Integration:** Modules included for multiplexed 7-segment display control (`Display.v`, `hex_to_7seg.v`).
* **Modular RTL Architecture:** Easy to add new APB3 compliant slave devices.

---

## 🏗 System Architecture

### 1. Modules Breakdown
* **`top.v`**: Top-level wrapper instantiating the master, address decoder, slave peripherals, and display controller.
* **`APB3_master.v`**: Generates APB read/write transfer sequences (IDLE, SETUP, ACCESS).
* **`APB3_decoder.v`**: Routes select signals (`PSELx`) based on target addresses.
* **`APB3_slave_FIFO.v` & `FIFO_logic.v`**: APB3 wrapper and core logic for synchronous data storage.
* **`APB3_slave_PWM.v`**: APB3 peripheral for duty-cycle and pulse-width generation.
* **`Display.v` & `hex_to_7seg.v`**: Multiplexing and hex decoding to display data on 7-segment FPGA outputs.

### 2. APB3 Bus State Machine
1. **IDLE:** Default state; no active transfer (`PSEL = 0`, `PENABLE = 0`).
2. **SETUP:** Transfer initiated; target address and write data driven (`PSEL = 1`, `PENABLE = 0`).
3. **ACCESS:** Transfer completed on clock edge when `PREADY = 1` (`PSEL = 1`, `PENABLE = 1`).

---

## 📁 Repository Structure
```text
├── APB3_master.v        # APB3 Bus Master Module
├── APB3_decoder.v       # Address Decoder / Peripheral Selector
├── APB3_slave_FIFO.v    # APB3 Slave interface for FIFO
├── APB3_slave_PWM.v     # APB3 Slave interface for PWM
├── FIFO_logic.v         # Core FIFO memory logic
├── Display.v            # 7-Segment Display multiplexer
├── hex_to_7seg.v        # Hexadecimal to 7-segment decoder
├── top.v                # Top-level system integration module
└── README.md            # Project documentation
