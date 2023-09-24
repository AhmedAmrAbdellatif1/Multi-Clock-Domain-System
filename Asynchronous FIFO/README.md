# Asynchronous FIFO Block

## Overview
The Asynchronous FIFO (First-In, First-Out) block is a crucial component in our system, designed to efficiently manage data storage and retrieval between two asynchronous clock domains. It serves as a 2-port memory with a specified depth, allowing for asynchronous write and read operations.

## Block Description
The Asynchronous FIFO block is characterized by the following key features:

- **Dual Clocks:** It operates with two clocks:
  - `W_CLK` (Write Clock): Used for write operations.
  - `R_CLK` (Read Clock): Used for read operations.

- **Dual Addresses:** The FIFO has two address ports:
  - Write Address: Determines the location for write operations.
  - Read Address: Determines the location for read operations.

- **Write Operation:** Data is written into the FIFO at the location specified by the write address (`W_INC` and `WR_DATA` inputs).

- **Read Operation:** Data is read from the FIFO at the location specified by the read address (`R_INC` output and `RD_DATA` output).

## Block Interface
The Asynchronous FIFO block has the following interface:

- **Inputs:**
  - `W_CLK`: Write clock signal.
  - `W_RST`: Asynchronous active-low write reset signal.
  - `W_INC`: Write address increment signal.
  - `R_CLK`: Read clock signal.
  - `R_RST`: Asynchronous active-low read reset signal.
  - `R_INC`: Read address increment signal.
  - `WR_DATA`: Data input for write operations.

- **Outputs:**
  - `FULL`: Signal indicating that the FIFO is full.
  - `RD_DATA`: Data output for read operations.
  - `EMPTY`: Signal indicating that the FIFO is empty.

## Specifications
The Asynchronous FIFO block operates according to the following specifications:

- Data can be written into the FIFO using the `W_CLK`, `W_RST`, `W_INC`, and `WR_DATA` inputs.

- Data can be read from the FIFO using the `R_CLK`, `R_RST`, `R_INC`, and `RD_DATA` outputs.

- The `FULL` signal indicates that the FIFO is full and cannot accept further write operations.

- The `EMPTY` signal indicates that the FIFO is empty, and no data can be read from it.

- Asynchronous reset signals `W_RST` and `R_RST` are used to clear the FIFO's state.

## Additional Information
The design of this Asynchronous FIFO block is based on the principles outlined in Clifford E. Cummings' paper: "Simulation and Synthesis Techniques for Asynchronous FIFO Design."[^1]

## Example RTL Code
For a better understanding of how the Asynchronous FIFO block is implemented in RTL (Register-Transfer Level) code, please refer to the `async_fifo.v` file in this repository.

[^1]: https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjcscnm_MKBAxWpV6QEHcLyDzQQFnoECBoQAQ&url=http%3A%2F%2Fwww.sunburst-design.com%2Fpapers%2FCummingsSNUG2002SJ_FIFO1.pdf&usg=AOvVaw3-qzaucL9OsvhhA5RKZqaM&opi=89978449
