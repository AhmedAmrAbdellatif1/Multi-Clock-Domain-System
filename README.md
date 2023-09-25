# RTL to GDS Implementation of Low Power Configurable Multi Clock Digital System

It is responsible of receiving commands through UART receiver to do different system functions as register file reading/writing or doing some processing using ALU block and send result using up to 4 bytes frame through UART transmitter communication protocol

## Introduction

The Low Power Configurable Multi-Clock Digital System is a sophisticated digital design realized in Verilog HDL. It serves as a versatile platform, receiving commands through a UART (Universal Asynchronous Receiver-Transmitter) receiver. It executes a wide range of system functions, including register file operations and complex computations via the ALU (Arithmetic Logic Unit) block. Subsequently, the system transmits results using a 4-byte frame through UART communication.

## Overview
### The system receives a UART Frame from the UART RX block, the first frame determines the needed command, the system offers 4 different operations:
1. Register File Write command
2. Register File Read command
3. ALU Operation command with operand
4. ALU Operation command with No operand
  
**The UART RX parallel data undergoes synchronization before being sent to the System Controller due to the discrepancy in clock domains.**
**The System Controller operates on a 50 MHz REF CLK, while the UART RX functions on a 3.6864 MHz clock.**
 **Synchronizing the data is crucial in ensuring its integrity during transfer.**

After synchronization, the data enters the System Controller, which determines the required operation and configures the necessary control signals. Here's how the System Controller manages different tasks:

1. Register File Write Operation (0xAA):
   
   -It enables the `WrEn` signal of the Register File, indicating a write operation.
   
   -The desired `Address` for writing is specified.
  
2. Register File Read Operation (0xBB):

   -It enables the `RdEn` signal of the Register File, indicating a read operation.

   -The desired `Address` for reading is specified.

   -The data is retrieved from the Register File and sent to the UART TX.

> **However, the UART TX operates on a different clock frequency, specifically 115.2 KHz. To prevent data loss due to clock domain crossing (CDC), a `FIFO` (First-In-First-Out) buffer is strategically placed just before the UART TX. This buffer ensures the orderly transmission of data without loss or corruption.**

3. ALU (Arithmetic Logic Unit) Operation (0xCC):

   -It activates the `ALU_EN` signal of the ALU, signaling the start of an ALU operation.

   -The `CLK GATE` is enabled to activate the `ALU CLK`, synchronizing it with the ALU operation.

   -The operands required for the operation are obtained from the Register File at the predefined addresses.

   -The desired function for the ALU operation is conveyed using the `ALU_FUN` signal.

   -The result of the ALU operation (`ALU_OUT`) is passed to the System Controller.

   -From there, it is sent to the FIFO for subsequent transmission to the UART TX and, ultimately, to the master.

4. ALU Operation without Operand Change (0xDD): 

   -This configuration allows the ALU to perform an operation without altering the operands previously defined in the Register File.

*These well-defined steps ensure efficient data management and processing within the Low Power Configurable Multi-Clock Digital System, even when dealing with disparate clock frequencies and multiple operations.*

### To address the presence of multiple clock domains within the system, we have implemented synchronizers.
As mentioned earlier, a [Data Synchronizer](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/405196392bf892d5c6059fc183e1ec9a1a9db0ec/Data%20Synchronizer) is introduced after the UART RX stage. This addition is essential to prevent the occurrence of metastability in the output byte from the UART RX when it interfaces with the SYS CTRL block.

Furthermore, to mitigate metastability issues during the de-assertion of the reset signal, we have incorporated two [Reset Synchronizers](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/24d94171fbf92b36649f055d8c104d8afbe419e2/Reset%20Synchronizer). Each of these synchronizers is integrated into its respective clock domain group, ensuring that reset signals are effectively synchronized across the system.

### Clock dividers
to 

## System Architecture

This system consists of ten distinct blocks, each contributing to its overall functionality. Let's delve into these blocks:

### Clock Domain 1 (REF_CLK)

#### 1. RegFile (Register File)

The RegFile block serves as a data storage unit, facilitating efficient data storage and retrieval operations.

#### 2. ALU (Arithmetic Logic Unit)

The ALU is the computational powerhouse of the system, capable of executing a variety of arithmetic and logic operations.

#### 3. Clock Gating

The Clock Gating block optimizes power consumption by controlling clock signals during idle periods, reducing dynamic power consumption.

#### 4. SYS_CTRL (System Controller)

SYS_CTRL acts as the central hub of the system. It receives external commands, orchestrates operations across different blocks, and communicates results.

### Clock Domain 2 (UART_CLK)

#### 5. UART_TX (UART Transmitter)

UART_TX is responsible for transmitting data to an external device or master via UART communication.

#### 6. UART_RX (UART Receiver)

UART_RX receives incoming data and commands from external sources, facilitating communication with the system.

#### 7. PULSE_GEN (Pulse Generator)

PULSE_GEN generates pulse signals as needed within the system, contributing to various internal operations.

#### 8. Clock Dividers

Clock Dividers are essential for generating clocks with different frequencies and ratios, enabling precise control over timing.

### Data Synchronizers

#### 9. RST Synchronizer

The RST Synchronizer ensures synchronous de-assertion of asynchronous reset signals, addressing timing challenges during system operation.

#### 10. Data Synchronizer

The Data Synchronizer employs a unique synchronization scheme to address Clock Domain Crossing challenges, ensuring reliable data transfer between different clock domains.

## Reserved Registers

This system includes several reserved registers, each serving specific functions:

1. **REG0 (Address: 0x0) - ALU Operand A**
2. **REG1 (Address: 0x1) - ALU Operand B**
3. **REG2 (Address: 0x2) - UART Configuration**
   - Bit 0: Parity Enable (Default: 1)
   - Bit 1: Parity Type (Default: 0)
   - Bits 7-2: Prescale (Default: 32)
4. **REG3 (Address: 0x3) - Divisor Ratio**
   - Bits 7-0: Division ratio (Default: 32)

## System Operation

The system's operation is driven by commands received via UART_RX. It supports a wide range of operations, including ALU operations such as addition, subtraction, multiplication, division, logic operations, comparisons, and shifts. Additionally, it handles register file operations, including read and write commands.

### Supported Commands

1. Register File Write Command (3 frames)
2. Register File Read Command (2 frames)
3. ALU Operation Command with Operand (4 frames)
4. ALU Operation Command with No Operand (2 frames)

## System Specifications

- Reference Clock (REF_CLK): 50 MHz
- UART Clock (UART_CLK): 3.6864 MHz
- Clock Divider: Always enabled (clock divider enable = 1)

This system represents a remarkable achievement in digital design, combining versatility, efficiency, and precise control over multi-clock domains. Its wide range of supported operations makes it a valuable asset in various applications.

