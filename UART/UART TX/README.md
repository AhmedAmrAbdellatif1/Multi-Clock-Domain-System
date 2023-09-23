# UART TX (Transmitter) Block

## Overview
The UART TX (Transmitter) block is a crucial part of our multi-clock domain system. It's responsible for transmitting data to a master device through the UART interface. Whether it's sending commands, results, or any other information, the UART TX block ensures efficient and accurate data transmission.

## Block Description
The UART TX block performs the following key functions:

- **Data Transmission:** It receives data to be transmitted on the `P_DATA` bus when the `DATA_VALID` signal is high.

- **Configuration:** The block allows for configuration of frame parity bit generation (`PAR_EN`) and parity type (`PAR_TYP`) for data integrity.

- **Status Indication:** It provides a `TX_OUT` serial data output signal to transmit data and a `BUSY` signal to indicate ongoing transmission.

## Block Interface
The UART TX block has the following interface:

- **Inputs:**
  - `CLK`: Clock signal for sequential elements.
  - `RST`: Active-low asynchronous reset signal to clear registers.
  - `PAR_TYPE`: Configuration signal for parity type (0 for even, 1 for odd).
  - `PAR_EN`: Configuration signal to enable/disable the frame parity bit (0 for disable, 1 for enable).
  - `P_DATA`: Parallel 8-bits Data to be transmitted.
  - `DATA_VALID`: Signal indicating that `P_DATA` contains valid data for transmission.

- **Outputs:**
  - `TX_OUT`: Serial data output signal for transmitting data. (high when idle)
  - `BUSY`: Output signal indicating ongoing transmission (high for transmission, low for idle).

## Specifications
To effectively use the UART TX block, consider the following specifications:

- UART TX only accepts new data on the `P_DATA` bus when the `DATA_VALID` signal is high.

- The block is cleared using the asynchronous active low reset signal `RST`.

- The `DATA_VALID` signal remains high for only 1 clock cycle to indicate valid data.

- The `BUSY` signal is high as long as the UART TX block is transmitting a frame; otherwise, it's low.

- During UART TX processing, no new data is accepted on the `P_DATA` bus, even if `DATA_VALID` is high.

- `TX_OUT` is high in the IDLE case when no transmission is occurring.

- Configuration:
  - `PAR_EN` (Parity Configuration):
    - 0: Disables the frame parity bit.
    - 1: Enables the frame parity bit.
  - `PAR_TYP` (Parity Type Configuration):
    - 0: Specifies even parity.
    - 1: Specifies odd parity.


