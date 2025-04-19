# FPGA Vending Machine Controller - Verilog Implementation

![Vending Machine Block Diagram](https://via.placeholder.com/800x400?text=Vending+Machine+Block+Diagram)  
*High-performance digital IP core for vending machines with multi-item support*

**Domain**: Digital Design / FPGA Development / ASIC Prototyping  
**Technology**: Verilog HDL / FPGA (Xilinx/Intel)  
**Compliance**: APB Interface Standard  

## Project Specification
Developed during SURE ProEd Integrated VLSI Internship  
**Authors**:  
- Satish D, Nikhil B. Venkat  
- Devi Prasad, Bhaskar, Gopi, Chetan  

## Table of Contents
1. [Introduction](#introduction)
2. [Key Features](#key-features)
3. [Architecture](#architecture)
4. [Interfaces](#interfaces)
5. [Configuration](#configuration)
6. [Operation Modes](#operation-modes)
7. [Implementation](#implementation)
8. [Simulation Results](#simulation-results)
9. [Future Scope](#future-scope)

## Introduction
This Verilog implementation provides a configurable digital IP core for vending machine controllers with:

- Multi-item support (up to 1024 items)
- Flexible currency handling
- Real-time inventory management
- APB configuration interface
- Robust clock domain synchronization

## Key Features
| Feature | Specification |
|---------|--------------|
| System Clock | 100MHz |
| Configuration Clock | 50MHz (APB) |
| Currency Input Clock | 10KHz-50MHz (async) |
| Max Items Supported | 1024 (parameterized) |
| Max Currency Value | 100 units (parameterized) |
| Transaction Latency | <10 system clocks |
| Supported Denominations | 5, 10, 15, 20, 50, 100 |

**Advanced Capabilities**:
- Item-specific pricing
- Dispensed/available item tracking
- Empty item indication (reserved item code)
- Invalid currency rejection
- Low-latency response (<100ns)

## Architecture
### Block Diagram
![Detailed Block Diagram](https://via.placeholder.com/600x400?text=Detailed+Architecture)

### Core Components:
1. **Main FSM Controller**:
   ```verilog
   localparam RESET = 2'b00;
   localparam CONFIG_MODE = 2'b01; 
   localparam OPERATION_MODE = 2'b10;
