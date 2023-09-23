# UART RX (Receiver) Block

## Overview
The UART RX (Receiver) block is a pivotal component in our multi-clock domain system, responsible for receiving UART frames and ensuring data integrity. It plays a crucial role in receiving and processing data from a master device through the UART interface.

## Block Description
The UART RX block serves several essential functions:

- **Receiving UART Frames:** It receives UART frames on the `RX_IN` input and processes them for data extraction.

- **Oversampling Support:** UART RX supports oversampling by 8, 16, or 32, ensuring accurate data reception even at different clock speeds.

- **Data Validation:** The block checks the received frame for correctness and integrity. If the frame is corrupted, it raises error flags (`PAR_ERR` for parity error and `STP_ERR` for stop bit error).

- **Data Extraction:** Once the received frame is verified as correct and not corrupted, data is extracted and sent through the `P_DATA` bus, accompanied by the `DATA_VLD` signal.

- **Consecutive Frame Acceptance:** UART_RX can accept consecutive frames without any gap, ensuring smooth data reception.

## Block Interface
The UART RX block has the following interface:

- **Inputs:**
  - `i_clk`: Clock signal for sequential elements.
  - `i_rst_n`: Active-low asynchronous reset signal to clear registers.
  - `i_prescale`: Configuration signal for oversampling (8, 16, or 32 times).
  - `i_serial_data`: Input for the UART frame data.
  - `i_parity_enable`: Configuration signal to enable/disable the frame parity bit (0 for disable, 1 for enable).
  - `i_parity_type`: Configuration signal for parity type (0 for even, 1 for odd).

- **Outputs:**
  - `o_data_valid`: Signal indicating the validity of the received data.
  - `o_parity_error`: Signal indicating a parity error in the received frame.
  - `o_stop_error`: Signal indicating a stop bit error in the received frame.
  - `o_parallel_data`: Output bus for the extracted data from the received frame.
  
 ![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/81dea622-5264-48af-b763-43da86bb2410)

> For a better understanding of how the ALU block is implemented in RTL (Register-Transfer Level) code, please refer to the [`UART_RX.v`](./UART_RX.v) file in this repository.

## Specifications
To effectively use the UART RX block, consider the following specifications:

- UART RX receives UART frames on the `RX_IN` input.

- It supports oversampling by 8, 16, or 32 times, ensuring accurate data reception at different clock speeds.

- The `RX_IN` input is high in the IDLE case (No transmission).

- The `PAR_ERR` signal is high when the calculated parity bit does not match the received frame's parity bit, indicating a corrupted frame.

- The `STP_ERR` signal is high when the received stop bit is not equal to 1, indicating a corrupted frame.

- Data is extracted from the received frame and sent through the `P_DATA` bus, accompanied by the `DATA_VLD` signal, only after verifying that the frame is received correctly and not corrupted (`PAR_ERR = 0` and `STP_ERR = 0`).

- UART_RX can accept consecutive frames without any gap, ensuring smooth data reception.

- The block is cleared using the asynchronous active low reset signal `i_rst_n`.

- Configuration:
  - `i_parity_enable` (Parity Configuration):
    - 0: Disables the frame parity bit.
    - 1: Enables the frame parity bit.
  - `i_parity_type` (Parity Type Configuration):
    - 0: Specifies even parity.
    - 1: Specifies odd parity.

- The prescale value determines the clock speed of UART_RX to the speed of UART_TX.

## Elaborated Design
The UART RX block is composed of several essential components, each serving a unique function:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/770cb745-842c-40b8-8467-7777ac143f86)

### 1. Deserializer
The Deserializer converts the incoming serial data into parallel data, making it accessible for further processing within the block.

### 2. Edge Bit Counter
The Edge Bit Counter is used to determine the sampling time at the mid-time of each bit, ensuring accurate data sampling.

### 3. Data Sampling
Data Sampling is responsible for the actual sampling of the received data, ensuring that the data is captured accurately.

### 4. Parity Check
The Parity Check component verifies the parity bit in the received frame, ensuring data integrity. If the parity bit does not match, a `PAR_ERR` signal is raised.

### 5. Start Bit Check
Start Bit Check verifies the start bit of the received frame to ensure that data reception begins correctly.

### 6. Stop Bit Check
Stop Bit Check ensures that the stop bit of the received frame is set to 1, indicating the end of data transmission. If the stop bit is incorrect, an `STP_ERR` signal is raised.

### 7. Data Validation
Data Validation checks that the received frame is error-free (no parity or stop bit errors) before forwarding the data to the `P_DATA` bus, accompanied by the `DATA_VLD` signal.

## [Testbench](./UART_RX_tb.v)

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/96a602f0-0e24-40df-8d85-d0f30d61d1f3)

```
# /*********************** Prescale Testcases *************************/
# Prescale =  8: RX Period = 5ns & TX Period =  40ns [PASSED]
# Prescale = 16: RX Period = 5ns & TX Period =  80ns [PASSED]
# Prescale = 32: RX Period = 5ns & TX Period = 160ns [PASSED]
# /*********************** Even Parity Testcases **********************/
# MISMATCH: 00000000 ->      EVEN PARITY TESTCASE [PASSED]
# MISMATCH: 00000000 ->      EVEN PARITY TESTCASE [PASSED]
# MISMATCH: 00000000 ->      EVEN PARITY TESTCASE [PASSED]
# /************************ Odd Parity Testcases **********************/
# MISMATCH: 00000000 ->       ODD PARITY TESTCASE [PASSED]
# MISMATCH: 00000000 ->       ODD PARITY TESTCASE [PASSED]
# MISMATCH: 00000000 ->       ODD PARITY TESTCASE [PASSED]
# /*********************** NO Parity Testcases ************************/
# MISMATCH: 00000000 ->        NO PARITY TESTCASE [PASSED]
# MISMATCH: 00000000 ->        NO PARITY TESTCASE [PASSED]
# MISMATCH: 00000000 ->        NO PARITY TESTCASE [PASSED]
# /******************** Gliches & Errors Testcases ********************/
# MISMATCH: 00000000 ->     START GLITCH TESTCASE [PASSED]
# MISMATCH: 00000000 ->   INCORRECT STOP TESTCASE [PASSED]
# MISMATCH: 00000000 -> INCORRECT PARITY TESTCASE [PASSED]
# /*********************** Two Successive Bytes ***********************/
# MISMATCH: 0000000000000000 -> TWO SUCCESSIVE BYTES TESTCASE [PASSED]
# /********************* Multiple Successive Bytes *********************/
```
