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
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-c3ow{border-color:inherit;text-align:center;vertical-align:top}
.tg .tg-0pky{border-color:inherit;text-align:left;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">ALU_FUN</th>
    <th class="tg-c3ow" colspan="2">OPERATION</th>
    <th class="tg-0pky">ALU_OUT</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">0000</td>
    <td class="tg-0pky" rowspan="4">Arithmetic</td>
    <td class="tg-0pky">Addition<br></td>
    <td class="tg-0pky"></td>
  </tr>
  <tr>
    <td class="tg-0pky">0001</td>
    <td class="tg-0pky">Subtraction</td>
    <td class="tg-0pky"></td>
  </tr>
  <tr>
    <td class="tg-0pky">0010</td>
    <td class="tg-0pky">Multiplication</td>
    <td class="tg-0pky"></td>
  </tr>
  <tr>
    <td class="tg-0pky">0011</td>
    <td class="tg-0pky">Division</td>
    <td class="tg-0pky"></td>
  </tr>
</tbody>
</table>

## Elaborated Design
The ALU block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/d219f61f-0da8-4ba6-9685-c7f2138eacec)

## Testbench
![TB](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/63fb826a-7104-49c0-b27f-9dce27a377f7)
