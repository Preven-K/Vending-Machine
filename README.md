<div align="center">
   <img src='https://user-images.githubusercontent.com/73131499/166115643-d3187f47-d38f-41b2-ae42-5ecbbc60de14.png' />


<h3 align="center">SURE ProEd (SURE Trust) - Skill Upgradation for Rural-youth Empowerment Trust</h3>
  <h2> G3 Integerated VLSI </h2>
</div>

# PREVEN-K-G3-Integrated-VLSI

## FPGA Vending Machine Controller

**Domain**: 🖥️ VLSI Design / 🧮 FPGA Development  
**Technology**: 🔌 Verilog  
**Compliance**: 📜 APB Protocol 

## 📋 Table of Contents
1. [🚀 Introduction](#-introduction)
2. [✨ Key Features](#-key-features)
3. [📊 Visual Documentation](#-visual-documentation)
4. [🏛️ System Architecture](#-system-architecture)
5. [🔌 Interface Specifications](#-interface-specifications)
6. [⚙️ Configuration Protocol](#️-configuration-protocol)
7. [📈 Results & Validation](#-results--validation)
8. [🔮 Future Scope](#-future-scope)

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


<div align="center">
  <img src="https://github.com/Preven-K/Vending-Machine/blob/main/Architecture/General%20Block%20Diagram.png?raw=true" width="600">
</div>

### 🛡️ Reliability Features
- 🧊 Metastability-protected inputs (2-stage synchronizers)
- 🔄 Automatic inventory reconciliation
- 🚨 Immediate refund for:
  - Invalid currency (non-standard denominations)
  - Out-of-stock items
  - Configuration errors

## 📊 Visual Documentation

### 🏗️ Block Diagram
![System Block Diagram](https://github.com/Preven-K/Vending-Machine/blob/main/Architecture/Block%20Diagram.png?raw=true)


### ⏱️ Timing Diagrams
![Timing Diagram](https://github.com/Preven-K/Vending-Machine/blob/main/Architecture/Timing_Diagram1.jpg?raw=true)
![image alt](https://github.com/Preven-K/Vending-Machine/blob/main/Architecture/Timing_Diagram2.jpg?raw=true)

## 🏛️ System Architecture
### Finite State Machine
| State Code | Mode | Description |
|------------|------|-------------|
| 00 | RESET | Initialization state, all registers cleared |
| 01 | CONFIG | APB interface active for inventory setup |
| 10 | OPERATION | Normal vending machine operation |

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


## 📈 Results & Validation
### ✅ Test Cases
| Scenario | Input | Expected Output | Results |
|----------|-------|-----------------|----------|
| Exact Payment | Item5 (20) + 20 | Dispense5 + 0 | ✔️ |
| Overpayment | Item3 (15) + 20 | Dispense3 + 5 | ✔️ |
| Out-of-Stock | Item10 (0) + 50 | Empty(1023) + 50 | ❌ |
| Invalid Currency | Item2 + 13 | Empty(1023) + 13 | ❌ |

### 📊 Simulation Outputs

#### 📦 Test Plan
![Test Plan](https://github.com/Preven-K/Vending-Machine/blob/main/Outputs/Test%20Plan.png?raw=true)
#### 💰 Results 
![Output Simulation](https://github.com/Preven-K/Vending-Machine/blob/main/Outputs/Simulation%20Output.png?raw=true)

## 🔮 Future Scope
   - 🏧 NFC/RFID interface
   - 📱 Remote inventory monitoring
   - 💹 Dynamic pricing engine
