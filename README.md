# Vending Machine Controller - FPGA Implementation

![Vending Machine Diagram](https://via.placeholder.com/800x400?text=Vending+Machine+Controller+Design)  
*(Example: Add your design diagram here)*

A high-performance vending machine controller implemented in Verilog HDL for FPGA platforms. This project features multi-currency handling, inventory management, and robust error handling with clock domain synchronization.

**Domain**: Digital Design / FPGA Development / Hardware Description Languages

## Mentors
1. [Your Name](https://www.linkedin.com/in/yourprofile) *(if applicable)*
2. [Your Mentor](https://www.linkedin.com/in/mentorprofile) *(if applicable)*

## Team Members
1. [Your Name](https://www.linkedin.com/in/yourprofile) - Team Lead & RTL Designer  
   *B.Tech in Electronics/Computer Engineering*

## Project Duration
Month Year to Month Year *(e.g., September 2023 to December 2023)*

## Table of Contents
1. [Executive Summary](#executive-summary)
2. [Introduction](#introduction)
3. [Features](#key-features)
4. [Technical Specifications](#technical-specifications)
5. [Design Architecture](#design-architecture)
6. [Implementation](#implementation-details)
7. [Results](#results-and-outputs)
8. [Future Scope](#future-scope)
9. [Acknowledgements](#acknowledgements)

## Executive Summary
This project implements a fully functional vending machine controller on FPGA with:
- Multi-denomination currency handling (5, 10, 15, 20, 50, 100 units)
- Real-time inventory management for 1024 items
- Robust clock domain synchronization between:
  - 100MHz system clock
  - 50MHz configuration interface
  - Variable-speed currency input (10KHz-50MHz)
- Immediate change return for invalid transactions
- Configurable via APB (Advanced Peripheral Bus) interface

## Introduction
Modern vending machines require reliable controllers that can handle:
- Asynchronous user inputs
- Precise financial transactions
- Real-time inventory tracking
- Fault-tolerant operation

This Verilog implementation provides a synthesizable core that can be deployed on Xilinx/Intel FPGAs, featuring:
- Three-stage finite state machine
- Dual-clock domain synchronization
- Memory-mapped configuration interface
- Transaction logging capabilities

## Key Features
- **Multi-Currency Support**: Handles 6 standard denominations
- **Inventory Management**: Tracks 1024 items with:
  - Price
  - Available quantity
  - Dispensed count
- **Error Handling**:
  - Invalid currency detection
  - Out-of-stock items
  - Exact change guarantee
- **Configuration Interface**:
  - APB-compatible register access
  - Dynamic pricing updates
  - Inventory replenishment

## Technical Specifications
| Parameter          | Value                          |
|--------------------|--------------------------------|
| Target Technology  | Xilinx Artix-7 FPGA            |
| System Clock       | 100MHz                         |
| Configuration Clock| 50MHz                          |
| Currency Clock     | 10KHz-50MHz (async)            |
| Max Items          | 1024                           |
| Max Currency       | 100 units                      |
| Data Width         | 32-bit APB                     |

## Design Architecture
![Block Diagram](https://via.placeholder.com/600x300?text=System+Block+Diagram)

### Core Components:
1. **Main Controller (FSM)**:
   - Reset State
   - Configuration Mode
   - Operation Mode

2. **Clock Domain Crossing**:
   - 2-stage synchronizers
   - Pulse detectors

3. **Memory Subsystem**:
   - Item price storage
   - Inventory tracking
   - Transaction logs

4. **I/O Interfaces**:
   - Currency input
   - Item selection
   - Dispense mechanism
   - Change return

## Implementation Details
### Verilog Modules:
```verilog
module vending_machine #(
    parameter MAX_ITEMS = 1024,
    parameter MAX_CURRENCY = 100
)(
    input wire clk,          // 100MHz
    input wire currency_clk, // Async
    // [Other ports...]
);
    // FSM states
    localparam RESET = 2'b00;
    localparam CONFIG_MODE = 2'b01;
    localparam OPERATION_MODE = 2'b10;
    
    // [Implementation...]
endmodule
