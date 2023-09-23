# Arithmetic Logic Unit (ALU) Block

## Overview
The Arithmetic Logic Unit (ALU) is a fundamental component of our multi-clock domain mini-processor system. It plays a critical role in executing various arithmetic and logic operations, enabling the processor to perform tasks such as addition, subtraction, logical AND, logical OR, and more.

## Block Description
The ALU block is responsible for the following key functions:

- **Arithmetic Operations:** It performs basic arithmetic operations like addition and subtraction on input data.

- **Logical Operations:** It executes logical operations, including AND, OR, NAND, and NOR, to manipulate data.

- **Comparison:** The ALU compares input values and generates flags to indicate conditions such as equality, less than, and greater than.

- **Shift Operations** the ALU also supports shift operations. These operations allow for the movement of bits within data operands. These shift operations are valuable for tasks such as data manipulation and scaling within the processor.

## Block Interface
The ALU block has the following interface:

- **Inputs:**
  - `A` and `B`: Input 8-bits data operands for the selected operation.
  - `ALU Func`: Control signal specifying the operation to be performed.
  - `Enable`: Control signal enabling the ALU to function and accept the inputs.
  - `CLK`: Clock Signal for sequential elements.
  - `RST`: Active-low Asynchronous reset signal to clear the sequential elements.

- **Outputs:**
  - `ALU OUT`: The 16-bits result of the operation.
  - `VALID`: Status flag to indicate that the ALU OUT is ready
 
    ![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/a6ffe5d3-5075-43a7-8131-ca9e2a48fc57)

> For a better understanding of how the ALU block is implemented in RTL (Register-Transfer Level) code, please refer to the `alu.v` file in this repository.


