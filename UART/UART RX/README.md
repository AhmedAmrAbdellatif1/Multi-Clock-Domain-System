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

## [Testbench](./UART_RX_tb.v)
