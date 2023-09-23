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
  - `ALU Func`: 4-bits Control signal specifying the operation to be performed.
  - `Enable`: Control signal enabling the ALU to function and accept the inputs.
  - `CLK`: Clock Signal for sequential elements.
  - `RST`: Active-low Asynchronous reset signal to clear the sequential elements.

- **Outputs:**
  - `ALU OUT`: The 16-bits result of the operation.
  - `VALID`: Status flag to indicate that the ALU OUT is ready
 
    ![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/a6ffe5d3-5075-43a7-8131-ca9e2a48fc57)

> For a better understanding of how the ALU block is implemented in RTL (Register-Transfer Level) code, please refer to the `ALU.v` file in this repository.

## ALU Function Table
|  | ALU_FUN  | OPERATION | ALU_OUT |
| ------------- | ------------- | ------------- | ------------- |
| 0000 | Arithmetic | Content Cell  | Content Cell  |
| 0001 |            | Content Cell  | Content Cell  |
| 0010 |            | Content Cell  | Content Cell  |
| 0011 |            | Content Cell  | Content Cell  |
| 0100 | Logic  | Content Cell  | Content Cell  |
| 0101 |            | Content Cell  | Content Cell  |
| 0110 |            | Content Cell  | Content Cell  |
| 0111 |            | Content Cell  | Content Cell  |
| 1000 | Compare | Content Cell  | Content Cell  |
| 1001 |            | Content Cell  | Content Cell  |
| 1010 |            | Content Cell  | Content Cell  |
| 1011 |            | Content Cell  | Content Cell  |
| 1100 | Shift | Content Cell  | Content Cell  |
| 1101 |            | Content Cell  | Content Cell  |
| 1110 |            | Content Cell  | Content Cell  |
| 1111 |            | Content Cell  | Content Cell  |

## Elaborated Design
The ALU block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/d219f61f-0da8-4ba6-9685-c7f2138eacec)

## Testbench
![TB](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/63fb826a-7104-49c0-b27f-9dce27a377f7)
