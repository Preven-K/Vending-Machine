# FPGA Vending Machine Controller - Digital IP Core

![Vending Machine System Diagram](https://via.placeholder.com/800x400?text=Vending+Machine+System+Architecture)  
*Configurable digital controller IP for commercial vending machines*

**Domain**: VLSI Design / FPGA Development / Embedded Systems  
**Technology**: Hardware Description Language (HDL)  
**Compliance**: AMBA APB Protocol  

## Project Specification
Developed during SURE ProEd Integrated VLSI Internship  
**Technical Leads**:  
- Satish D, Nikhil B. Venkat  
- Devi Prasad, Bhaskar, Gopi, Chetan  

## Table of Contents
1. [Introduction](#introduction)
2. [Key Features](#key-features)
3. [System Architecture](#system-architecture)
4. [Interface Specifications](#interface-specifications)
5. [Configuration Protocol](#configuration-protocol)
6. [Operational States](#operational-states)
7. [Performance Metrics](#performance-metrics)
8. [Future Enhancements](#future-enhancements)

## Introduction
This digital IP core provides a complete control solution for modern vending machines, featuring:

- Multi-item inventory management (1024 unique products)
- Flexible currency handling with six standard denominations
- Real-time stock tracking (dispensed/available counts)
- Secure APB configuration interface
- Robust synchronization across asynchronous clock domains

## Key Features

### Core Specifications
| Parameter | Value |
|-----------|-------|
| System Clock Frequency | 100MHz ±5% |
| Configuration Interface Speed | 50MHz |
| Currency Input Range | 10KHz - 50MHz |
| Maximum Items Supported | 1024 (configurable) |
| Maximum Currency Value | 100 units |
| Transaction Latency | ≤10 clock cycles |
| Supported Denominations | 5, 10, 15, 20, 50, 100 units |

### Advanced Functionality
- **Dynamic Inventory Control**:
  - Per-item pricing
  - Real-time stock monitoring
  - Reserved "empty item" indication (code 1023)

- **Financial Integrity**:
  - Exact change calculation
  - Immediate refund for invalid currency
  - Overpayment handling

- **Reliable Operation**:
  - Three-stage state machine
  - Metastability-protected inputs
  - Fail-safe reset behavior

## System Architecture

### Block Diagram
![Detailed Component Diagram](https://via.placeholder.com/600x400?text=Controller+Block+Diagram)

### Functional Units
1. **Central Controller**  
   - Finite State Machine (Reset/Config/Operational modes)
   - Transaction processing engine
   - Error handling subsystem

2. **Memory Organization**  
   - 32-bit wide configuration registers
   - Dual-port inventory memory (1024 entries)
   - Write-protected dispense counters

3. **Clock Domain Bridges**  
   - Currency input synchronization
   - APB interface timing control
   - Pulse width adaptation

## Interface Specifications

### Control Interfaces
| Signal | Direction | Description |
|--------|-----------|-------------|
| clk | Input | 100MHz system clock |
| rstn | Input | Asynchronous active-low reset |
| cfg_mode | Input | Configuration mode selector |

### Transaction Interfaces
**Currency Input**:
- `currency_valid`: Single-cycle pulse in currency clock domain
- `currency_value`: Binary encoded denomination (3-7 bits)

**Product Selection**:
- `item_select`: Encoded product ID (10 bits)
- `item_select_valid`: Selection acknowledgement pulse

### APB Configuration Bus
| Signal | Function |
|--------|----------|
| pclk | 50MHz configuration clock |
| paddr | 15-bit register address |
| pwdata | 32-bit write data |
| prdata | 32-bit read data |
| pready | Transfer ready indicator |

## Configuration Protocol

### Memory Map
| Address Range | Function |
|--------------|----------|
| 0x4000_0000 | Global configuration |
| 0x4000_0004 - 0x4000_0FFC | Item configurations (1024 entries) |

### Register Structure
**Item Configuration Format**:
| Bit Range | Field | Access | Description |
|-----------|-------|--------|-------------|
| 31-24 | dispensed_count | RO | Total units sold |
| 23-16 | available_count | RW | Current stock |
| 15-0 | item_price | RW | Current price |

## Operational States

### 1. Reset Mode
- Initializes all registers to default values
- Holds outputs in safe state
- Maintains low-power profile

### 2. Configuration Mode
**Vendor Workflow**:
1. Activate cfg_mode signal
2. Load item prices via APB writes
3. Set initial stock levels
4. Deactivate cfg_mode to begin operations

**Typical Sequence**:
- Address: 0x4000_0004 (Item 0)
- Data: 0x000A0014 (10 available, price 20)

### 3. Operation Mode
**Customer Transaction Flow**:
1. Product selection (item_select + valid pulse)
2. Currency insertion (multiple denominations accepted)
3. System response:
   - Successful: Product dispense + change
   - Out-of-stock: Empty code + refund
   - Invalid currency: Immediate refund

## Performance Metrics

### Timing Characteristics
| Parameter | Value | Condition |
|-----------|-------|-----------|
| Config Write Latency | 2 cycles | APB interface |
| Currency Validation | 3 cycles | Metastability protection |
| Decision Latency | ≤8 cycles | Worst-case scenario |


## Future Enhancements

### Feature Roadmap
1. **Payment Expansion**:
   - NFC/RFID payment support
   - Biometric authentication

2. **Smart Features**:
   - Machine learning demand prediction
   - Remote inventory monitoring
   - Dynamic pricing engine

---
*Developed as part of SURE ProEd's VLSI Design Internship Program*  
*Documentation Rev 1.2 • Updated: April 2025*

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
