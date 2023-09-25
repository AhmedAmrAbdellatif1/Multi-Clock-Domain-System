# RTL to GDS Implementation of Low Power Configurable Multi Clock Digital System
Design of Multi Clock Domain System using Verilog HDL from RTL Design to Implementation.

It is responsible of receiving commands through UART receiver to do different system functions as register file reading/writing or doing some processing using ALU block and send result using 4 bytes frame through UART transmitter communication protocol
# Low Power Configurable Multi-Clock Digital System

## Overview

Welcome to the comprehensive readme of the Low Power Configurable Multi-Clock Digital System. This document provides an in-depth understanding of the system, its architecture, and functionality, from RTL (Register-Transfer Level) design to GDS (Graphic Design System) implementation.

## Introduction

The Low Power Configurable Multi-Clock Digital System is a sophisticated digital design realized in Verilog HDL. It serves as a versatile platform, receiving commands through a UART (Universal Asynchronous Receiver-Transmitter) receiver. It executes a wide range of system functions, including register file operations and complex computations via the ALU (Arithmetic Logic Unit) block. Subsequently, the system transmits results using a 4-byte frame through UART communication.

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

For detailed design files and implementation, please refer to the repository linked below.

[GitHub Repository]([repository-link](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/f0ffc176a911d5b889440c45f0cda5d3c369ddea/System%20Top)https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/f0ffc176a911d5b889440c45f0cda5d3c369ddea/System%20Top)
