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

## Block Interface

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/52fd0d94-32a6-4a23-ad48-1a7345c30097)
> Not all the ports are included in the photo

### Inputs

The System Controller block receives the following inputs:

- **Clock and Reset Signals:**
  - `CLK`: The Clock Signal.
  - `RST`: Active Low Reset.

- **ALU Inputs:**
  - `ALU_OUT`: ALU Result Bus (Width: ALU_WIDTH).
  - `OUT_Valid`: ALU Result Valid Signal.

- **UART_RX Inputs:**
  - `RX_P_Data`: UART_RX Data Bus (Width: DATA_BUS_WIDTH).
  - `RX_D_VLD`: RX Data Valid Signal.

- **Register File Inputs:**
  - `RdData`: Read Data Bus (Width: DATA_BUS_WIDTH).
  - `RdData_Valid`: Read Data Valid Signal.

- **Clock Divider and Prescale Configuration:**
  - `Prescale_RX`: Configuration for Prescale Values (Width: DATA_BUS_WIDTH-3).
  - `FIFO_FULL`: FIFO Full Flag Signal.

- **ALU Control Signals:**
  - `ALU_EN`: ALU Enable Signal.
  - `ALU_FUN`: ALU Function Signal (Width: ALUFN_WIDTH).

- **Clock Management:**
  - `CLK_EN`: Clock Gate Enable Signal.

- **Address and Memory Access:**
  - `Address`: Address Bus (Width: ADDR_WIDTH).
  - `WrEn`: Write Enable Signal.
  - `RdEn`: Read Enable Signal.

### Outputs

The System Controller block provides the following outputs:

- **Data Transfer:**
  - `WrData`: Write Data Bus (Width: DATA_BUS_WIDTH).
  - `TX_P_Data`: UART_TX Data Bus (Width: DATA_BUS_WIDTH).
  - `TX_D_VLD`: TX Data Valid Signal.

- **Clock Divider Control:**
  - `clk_div_en`: Clock Divider Enable Signal.

- **Clock Divider Output:**
  - `ClkDiv_RX`: Clock Divider Ratio for RX (Width: DATA_BUS_WIDTH-3).
