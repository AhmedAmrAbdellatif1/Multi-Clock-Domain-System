# System Controller Block

## Overview
The System Controller is the central hub of our Low Power Configurable Multi-Clock Digital System. It orchestrates various operations based on commands received from the master via the UART_RX interface and ensures the results are communicated back to the master through the UART_TX interface. This versatile component handles a wide range of operations, including ALU and Register File operations.

## Block Description
The System Controller is the brain behind our digital system, responsible for interpreting and executing a multitude of commands from the master. These commands encompass ALU operations, Register File operations, and more.

## Supported Operations
The System Controller supports a comprehensive set of operations, including but not limited to:
- Arithmetic and Logic Unit (ALU) Operations:
  - Addition
  - Subtraction
  - Multiplication
  - Division
  - Logical Operations (AND, OR, NAND, NOR, XOR, XNOR)
  - Comparisons (A = B, A > B)
  - Bit Shifting (A >> 1, A << 1)
  - Register File Operations:
  - Register File Write
  - Register File Read

## Supported Commands
To execute these operations, the System Controller interprets various commands, including:
1. Register File Write Command (3 frames)
2. Register File Read Command (2 frames)
3. ALU Operation Command with Operand (4 frames)
4. ALU Operation Command with No Operand (2 frames)

## Operation Workflow
The workflow of the System Controller is as follows:
1. The master (testbench) sends different commands (Register File Operations, ALU Operations) via UART_RX.
2. The System Controller receives these command frames.
3. The System Controller processes the commands, performing the requested operations using the ALU and Register File.
4. Once the operation is completed, the System Controller sends the result back to the master through UART_TX.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/0db4d45d-85cf-496c-ba73-9b877d364de6)

