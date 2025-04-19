# 🏪 Vending Machine Controller - FPGA Verilog Core

![Architecture Diagram](https://via.placeholder.com/800x400?text=System+Architecture+Diagram)  
*Configurable digital IP core for automated retail systems with multi-clock domain operation*

**Key Metrics**  
✅ **Max Items**: 1,024 (Parameterized)  
✅ **Currency Support**: 6 Denominations  
✅ **Clock Domains**: 3 (100MHz Sys, 50MHz Config, 10KHz-50MHz Async)  
✅ **Latency**: <10 clock cycles  

## 📋 Table of Contents
1. [Project Overview](#-project-overview)
2. [Technical Specifications](#-technical-specifications)
3. [Architecture](#-architecture)
4. [Interface Protocol](#-interface-protocol)
5. [Configuration Memory Map](#-configuration-memory-map)
6. [Operation Modes](#-operation-modes)
7. [Simulation Verification](#-simulation-verification)
8. [FPGA Implementation](#-fpga-implementation)
9. [Future Roadmap](#-future-roadmap)

---

## 🚀 Project Overview
**Developed during SURE ProEd VLSI Internship**  
*Authors: Satish D, Nikhil B. Venkat, Devi Prasad, Bhaskar, Gopi, Chetan*

Industrial-grade vending machine controller IP featuring:
- **Multi-Item Inventory**: Track 1024 unique SKUs
- **Smart Currency Handling**: 5/10/15/20/50/100 denominations
- **APB Configuration**: ARM-compatible interface
- **Fail-Safe Operation**: Guaranteed change return

```verilog
module vending_machine #(
    parameter MAX_ITEMS = 1024,
    parameter MAX_CURRENCY = 100
)(
    // [Interface ports...]
);
```
⚙ Technical Specifications
Clock Domains
Domain	Frequency	Purpose
System	100MHz	Main state machine
Config	50MHz	APB register access
Currency	10KHz-50MHz	Async user input
Performance Characteristics
Transaction Latency: 8 cycles (80ns @ 100MHz)

Memory Utilization: 32KB (1024 items × 32b)

Throughput: 12.5M transactions/sec

Supported Features
✔ Dynamic item pricing

✔ Real-time inventory tracking

✔ Invalid currency rejection

✔ Out-of-stock detection

✔ Low-power sleep modes

🏗 Architecture
Block Diagram
Detailed Block Diagram

Core Components:

Finite State Machine

Diagram
Code






Clock Domain Crossing

Dual-stage synchronizers

Glitch-free pulse converters

APB Interface

AMBA 3 compliant

32-bit data bus

15-bit address space

🔌 Interface Protocol
Signal Matrix
Interface	Key Signals	Width	Description
System	clk, rstn	1b	100MHz clock + reset
Currency	currency_valid, value	7b	Async money input
Item Select	item_sel, sel_valid	10b	Product selection
APB Config	paddr, pwdata	15b,32b	Register programming
Dispense	disp_valid, change	1b,7b	Output control
Timing Diagram:
APB Timing

🗄 Configuration Memory Map
Register Hierarchy
Address Range	Register	Access	Description
0x4000_0000	CFG_CTRL	RW	Global control
0x4000_0004	ITEM_CFG[0]	RW	Item 0 config
...	...	...	...
0x4000_0FFC	ITEM_CFG[1023]	RW	Item 1023 config
Item Configuration Format:

31           24 23          16 15           0
+---------------+--------------+---------------+
| Dispensed (RO)| Available (RW)| Price (RW)    |
+---------------+--------------+---------------+
🔄 Operation Modes
Configuration Mode (cfg_mode=1)
python
# Sample APB Write Sequence
write(addr=0x4000_0004, data=0x000A0014) # 10 available, price=20
write(addr=0x4000_0008, data=0x0005001E) # 5 available, price=30
Operation Mode (cfg_mode=0)
Transaction Flow:

User selects product (item_select_valid=1)

Inserts money (currency_valid pulses)

System responds within 80ns:

item_dispense_valid pulse

Product code or EMPTY_ITEM (1023)

Exact change (if any)

📊 Simulation Verification
Test Cases
Case	Description	Expected Result
TC1	Exact payment	Dispense + no change
TC2	Overpayment	Dispense + change
TC3	Invalid currency	Immediate refund
TC4	Out-of-stock	Empty item code
Waveform Example:
Simulation Wave

🔧 FPGA Implementation
Xilinx Artix-7 Utilization
Resource	Used	Available	Utilization
LUTs	1,203	63,400	1.9%
FFs	897	126,800	0.7%
BRAM	8	135	5.9%
Timing Closure:

Worst Negative Slack: 0.312ns

Fmax: 142MHz

🛣 Future Roadmap
Near-Term (Q4 2023)
PCIe interface prototype

Machine learning demand prediction

Mid-Term (2024)
28nm ASIC tapeout

ISO 9001 certification

Long-Term
Blockchain payment integration

AR product visualization

