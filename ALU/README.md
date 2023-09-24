# Arithmetic Logic Unit (ALU) Block

## Overview
The Arithmetic Logic Unit (ALU) is a fundamental component of our multi-clock domain system. It plays a critical role in executing various arithmetic and logic operations, enabling the processor to perform tasks such as addition, subtraction, logical AND, logical OR, and more.

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
  - `OUT_VALID`: Status flag to indicate that the `ALU OUT` is ready
 
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/ca19d944-33e8-4f8c-ac82-8a3f3bc50937)

> For a better understanding of how the ALU block is implemented in RTL (Register-Transfer Level) code, please refer to the [`ALU.v`](./ALU.v) file in this repository.

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
    <th class="tg-baqh">ALU_FUN</th>
    <th class="tg-baqh" colspan="2">OPERATION</th>
    <th class="tg-baqh">ALU_OUT</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-baqh">0000</td>
    <td class="tg-baqh" rowspan="4">Arithmetic<br></td>
    <td class="tg-baqh">Addition</td>
    <td class="tg-baqh">A+B</td>
  </tr>
  <tr>
    <td class="tg-baqh">0001</td>
    <td class="tg-baqh">Subtraction</td>
    <td class="tg-baqh">A-B</td>
  </tr>
  <tr>
    <td class="tg-baqh">0010</td>
    <td class="tg-baqh">Multiplication</td>
    <td class="tg-baqh">A*B</td>
  </tr>
  <tr>
    <td class="tg-baqh">0011</td>
    <td class="tg-baqh">Division</td>
    <td class="tg-baqh">A/B</td>
  </tr>
  <tr>
    <td class="tg-baqh">0100</td>
    <td class="tg-baqh" rowspan="4">Logic<br></td>
    <td class="tg-baqh">AND</td>
    <td class="tg-baqh">A&amp;B</td>
  </tr>
  <tr>
    <td class="tg-baqh">0101</td>
    <td class="tg-baqh">OR</td>
    <td class="tg-baqh">A|B</td>
  </tr>
  <tr>
    <td class="tg-baqh">0110</td>
    <td class="tg-baqh">NAND</td>
    <td class="tg-baqh">~(A&amp;B)</td>
  </tr>
  <tr>
    <td class="tg-baqh">0111</td>
    <td class="tg-baqh">NOR</td>
    <td class="tg-baqh">~(A|B)</td>
  </tr>
  <tr>
    <td class="tg-baqh">1000</td>
    <td class="tg-baqh" rowspan="4">Compare<br></td>
    <td class="tg-baqh">NOP</td>
    <td class="tg-baqh">0</td>
  </tr>
  <tr>
    <td class="tg-baqh">1001</td>
    <td class="tg-baqh">if A==B ?</td>
    <td class="tg-baqh">1 : 0</td>
  </tr>
  <tr>
    <td class="tg-baqh">1010</td>
    <td class="tg-baqh">if A &gt; B ?</td>
    <td class="tg-baqh">2 : 0</td>
  </tr>
  <tr>
    <td class="tg-baqh">1011</td>
    <td class="tg-baqh">if A &lt; B ?</td>
    <td class="tg-baqh">3 : 0</td>
  </tr>
  <tr>
    <td class="tg-baqh">1100</td>
    <td class="tg-baqh" rowspan="4">Shift<br></td>
    <td class="tg-baqh">LSR to A</td>
    <td class="tg-baqh">A &gt;&gt; 1</td>
  </tr>
  <tr>
    <td class="tg-baqh">1101</td>
    <td class="tg-baqh">LSL to A</td>
    <td class="tg-baqh">A &lt;&lt; 1</td>
  </tr>
  <tr>
    <td class="tg-baqh">1110</td>
    <td class="tg-baqh">LSR to B</td>
    <td class="tg-baqh">B &gt;&gt; 1</td>
  </tr>
  <tr>
    <td class="tg-baqh">1111</td>
    <td class="tg-baqh">LSL to B</td>
    <td class="tg-baqh">B &lt;&lt; 1</td>
  </tr>
</tbody>
</table>

## Elaborated Design

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/d219f61f-0da8-4ba6-9685-c7f2138eacec)

## [Testbench](./ALU_tb.v)
![TB](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/63fb826a-7104-49c0-b27f-9dce27a377f7)

```
[PASSED] TESTCASE- 1: ADDITION
[PASSED] TESTCASE- 2: SUBTRACTION
[PASSED] TESTCASE- 3: MULTIPLICATION
[PASSED] TESTCASE- 4: DIVISION
[PASSED] TESTCASE- 5: LOGICAL AND
[PASSED] TESTCASE- 6: LOGICAL OR
[PASSED] TESTCASE- 7: LOGICAL NAND
[PASSED] TESTCASE- 8: LOGICAL NOR
[PASSED] TESTCASE- 9: NOP
[PASSED] TESTCASE-10: EQUALITY
[PASSED] TESTCASE-11: GREATER THAN
[PASSED] TESTCASE-12: LESS THAN
[PASSED] TESTCASE-13: A-SHIFT RIGHT
[PASSED] TESTCASE-14: A-SHIFT LEFT
[PASSED] TESTCASE-15: B-SHIFT RIGHT
[PASSED] TESTCASE-16: B-SHIFT LEFT
[PASSED] TESTCASE-17: RESET
```
