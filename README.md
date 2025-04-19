# 🏗️ FPGA Vending Machine Controller - Digital IP Core

![System Architecture Diagram](/Assets/architecture_diagram.png)  
*High-performance digital IP for automated retail systems*

**Domain**: 🖥️ VLSI Design / 🧮 FPGA Development  
**Technology**: 🔌 Verilog HDL (IEEE 1364-2005)  
**Compliance**: 📜 AMBA APB Protocol (ARM IHI 0024B)  

## 📋 Table of Contents
1. [🚀 Introduction](#introduction)
2. [✨ Key Features](#key-features)
3. [📊 Visual Documentation](#visual-documentation)
4. [🏛️ System Architecture](#system-architecture)
5. [🔌 Interface Specifications](#interface-specifications)
6. [⚙️ Configuration Protocol](#configuration-protocol)
7. [⏱️ Performance Metrics](#performance-metrics)
8. [📈 Results & Validation](#results)
9. [🔮 Future Scope](#future-scope)
10. [🧑💻 Getting Started](#getting-started)

## 🚀 Introduction
This repository contains a production-grade 🎛️ Verilog implementation of a vending machine controller IP core with:

- ⏱️ Multi-clock domain operation:
  - 100MHz system clock (±50ppm stability)
  - 50MHz APB configuration interface
  - 10KHz-50MHz asynchronous currency input
- 📦 1024-item inventory management
- 💰 Six currency denomination support with smart change calculation
- 🔒 Built-in error handling mechanisms

## ✨ Key Features

### 🎯 Core Specifications
| Feature | Specification | Notes |
|---------|--------------|-------|
| 📶 Max Items | 1024 | Parameterized via `MAX_ITEMS` |
| 💵 Max Currency | 100 units | Configurable with `MAX_CURRENCY` |
| ⚡ Transaction Latency | <10 clock cycles | Worst-case scenario |
| 🔢 Supported Denominations | 5, 10, 15, 20, 50, 100 | Hard-coded in FSM |

### 🛡️ Reliability Features
- 🧊 Metastability-protected inputs (2-stage synchronizers)
- 🔄 Automatic inventory reconciliation
- 🚨 Immediate refund for:
  - Invalid currency (non-standard denominations)
  - Out-of-stock items
  - Configuration errors

## 📊 Visual Documentation

### 🏗️ Block Diagram
![System Block Diagram](/Assets/block_diagram.png)  
*Complete data path with clock domain crossings*

### ⏱️ Timing Diagrams
#### ✅ Successful Transaction
![Happy Path Timing](/Assets/timing_normal.png)  
*1. Item selection → 2. Currency insertion → 3. Product dispense*

#### ❌ Error Cases
![Error Handling](/Assets/timing_error.png)  
*Left: Invalid currency | Right: Out-of-stock item*

### 📊 Simulation Outputs
#### 📦 Inventory Management
![Inventory Console](/Assets/inventory_console.png)  
*Real-time stock monitoring output*

#### 💰 Change Calculation
![Change Simulation](/Assets/change_simulation.png)  
*Exact change computation waveform*

## 🏛️ System Architecture

### Finite State Machine
| State Code | Mode | Description |
|------------|------|-------------|
| 00 | RESET | Initialization state, all registers cleared |
| 01 | CONFIG | APB interface active for inventory setup |
| 10 | OPERATION | Normal vending machine operation |

### 📦 Memory Organization
| Memory Block | Size | Function |
|--------------|------|----------|
| Item Config | 1024×32b | Price + stock tracking |
| Transaction Log | 256×64b | Audit trail buffer |
| Currency Buffer | 8×16b | Temporary change storage |

## 🔌 Interface Specifications

### 🎛️ Control Ports
| Signal | Type | Width | Description |
|--------|------|-------|-------------|
| `clk` | Input | 1b | 100MHz ±50ppm |
| `rstn` | Input | 1b | Async active-low reset |
| `cfg_mode` | Input | 1b | Config/operation mode select |

### 💰 Currency Interface
| Signal | Direction | Timing | Description |
|--------|-----------|--------|-------------|
| `currency_valid` | Input | 10KHz-50MHz | Single-cycle pulse |
| `currency_value` | Input | 7b | Encoded denomination |

### 🛒 Item Interface
| Signal | Direction | Condition | Description |
|--------|-----------|-----------|-------------|
| `item_select` | Input | Operation mode | 10-bit encoded product ID |
| `item_select_valid` | Input | Operation mode | Selection validation pulse |

### 📝 APB Configuration
| Signal | Width | Direction | Description |
|--------|-------|-----------|-------------|
| `paddr` | 15b | Input | Register address |
| `pwdata` | 32b | Input | Write data |
| `prdata` | 32b | Output | Read data |
| `pready` | 1b | Output | Transfer ready |

## ⚙️ Configuration Protocol

### Memory Map
| Address Range | Register | Access | Description |
|--------------|----------|--------|-------------|
| 0x4000_0000 | CFG_CTRL | RW | Global control |
| 0x4000_0004 | ITEM_0 | RW | First item config |
| ... | ... | ... | ... |
| 0x4000_0FFC | ITEM_1023 | RW | Last item config |

### Register Format
| Bits | Field | Type | Description |
|------|-------|------|-------------|
| 31-24 | DISPENSED | RO | Items sold count |
| 23-16 | AVAILABLE | RW | Current stock |
| 15-0 | PRICE | RW | Item value |

## ⏱️ Performance Metrics

### 🔧 Resource Utilization (Xilinx Artix-7)
| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| LUTs | 1,243 | 63,400 | 2% |
| FFs | 897 | 126,800 | <1% |
| BRAM | 4 | 135 | 3% |

### ⏲️ Timing Performance
| Path | Slack | Clock Cycles |
|------|-------|--------------|
| Currency to Output | 2.1ns | 3 |
| Config Write | 1.8ns | 2 |
| Item Selection | 3.2ns | 4 |

## 📈 Results & Validation

### ✅ Test Cases
| Scenario | Input | Expected Output | Results |
|----------|-------|-----------------|----------|
| Exact Payment | Item5 (20) + 20 | Dispense5 + 0 | ✔️ |
| Overpayment | Item3 (15) + 20 | Dispense3 + 5 | ✔️ |
| Out-of-Stock | Item10 (0) + 50 | Empty(1023) + 50 | ❌ |
| Invalid Currency | Item2 + 13 | Empty(1023) + 13 | ❌ |

## 🔮 Future Scope
1. **Payment Expansion**
   - 🏧 NFC/RFID interface
   - ₿ Cryptocurrency support
   - 👆 Biometric authentication

2. **Smart Features**
   - 🤖 ML demand prediction
   - 📱 Remote inventory monitoring
   - 💹 Dynamic pricing engine


