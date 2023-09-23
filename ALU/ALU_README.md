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

<table class="tg" style="undefined;table-layout: fixed; width: 563px">
<colgroup>
<col style="width: 151.2px">
<col style="width: 125.2px">
<col style="width: 158.2px">
<col style="width: 128.2px">
</colgroup>
<thead>
  <tr>
    <th class="tg-c3ow">ALU_FUN</th>
    <th class="tg-c3ow" colspan="2">OPERATION</th>
    <th class="tg-c3ow">ALU_OUT</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-c3ow">0000</td>
    <td class="tg-c3ow" rowspan="4">Arithmetic<br></td>
    <td class="tg-c3ow">Addition</td>
    <td class="tg-c3ow">A+B</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0001</td>
    <td class="tg-c3ow">Subtraction</td>
    <td class="tg-c3ow">A-B</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0010</td>
    <td class="tg-c3ow">Multiplication</td>
    <td class="tg-c3ow">A*B</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0011</td>
    <td class="tg-c3ow">Division</td>
    <td class="tg-c3ow">A/B</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0100</td>
    <td class="tg-c3ow" rowspan="4">Logic<br></td>
    <td class="tg-c3ow">AND</td>
    <td class="tg-c3ow">A&amp;B</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0101</td>
    <td class="tg-c3ow">OR</td>
    <td class="tg-c3ow">A|B</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0110</td>
    <td class="tg-c3ow">NAND</td>
    <td class="tg-c3ow">~(A&amp;B)</td>
  </tr>
  <tr>
    <td class="tg-c3ow">0111</td>
    <td class="tg-c3ow">NOR</td>
    <td class="tg-c3ow">~(A|B)</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1000</td>
    <td class="tg-c3ow" rowspan="4">Compare<br></td>
    <td class="tg-c3ow">NOP</td>
    <td class="tg-c3ow">0</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1001</td>
    <td class="tg-c3ow">if A==B ?</td>
    <td class="tg-c3ow">1 : 0</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1010</td>
    <td class="tg-c3ow">if A &gt; B ?</td>
    <td class="tg-c3ow">2 : 0</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1011</td>
    <td class="tg-c3ow">if A &lt; B ?</td>
    <td class="tg-c3ow">3 : 0</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1100</td>
    <td class="tg-c3ow" rowspan="4">Shift<br></td>
    <td class="tg-c3ow">LSR to A</td>
    <td class="tg-c3ow">A &gt;&gt; 1</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1101</td>
    <td class="tg-c3ow">LSL to A</td>
    <td class="tg-c3ow">A &lt;&lt; 1</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1110</td>
    <td class="tg-c3ow">LSR to B</td>
    <td class="tg-c3ow">B &gt;&gt; 1</td>
  </tr>
  <tr>
    <td class="tg-c3ow">1111</td>
    <td class="tg-c3ow">LSL to B</td>
    <td class="tg-c3ow">B &lt;&lt; 1</td>
  </tr>
</tbody>
</table>

## Elaborated Design
The ALU block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/d219f61f-0da8-4ba6-9685-c7f2138eacec)

## Testbench
![TB](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/63fb826a-7104-49c0-b27f-9dce27a377f7)
