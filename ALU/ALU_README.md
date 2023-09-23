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

## Usage
To effectively utilize the ALU block within our mini-processor system, follow these steps:

1. Ensure that the `OpCode` signal is correctly configured to select the desired operation (addition, subtraction, logical AND, etc.).

2. Provide the input data operands (`DataA` and `DataB`) to the ALU.

3. The result of the operation can be obtained from the `Result` output.

4. Monitor the status flags in the `Flags` output to handle conditional branching or to determine the outcome of the operation.

5. Properly synchronize the clocks and handle any potential hazards when interfacing with other blocks in the system due to multi-clock domain operation.

## Example RTL Code
For a better understanding of how the ALU block is implemented in RTL (Register-Transfer Level) code, please refer to the `alu.v` file in this repository.

```verilog
// Sample Verilog code illustrating the ALU functionality
module alu (
  input wire [3:0] OpCode,
  input wire [31:0] DataA,
  input wire [31:0] DataB,
  output wire [31:0] Result,
  output wire [3:0] Flags
);
  // Implementation details go here
  // ...
endmodule

