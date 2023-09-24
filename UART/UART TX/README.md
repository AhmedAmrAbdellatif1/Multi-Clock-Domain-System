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

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/8614ac50-6430-41bc-9b1b-9562b4de9f8e)

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

  > For a better understanding of how the ALU block is implemented in RTL (Register-Transfer Level) code, please refer to the [`UART_TX.v`](./UART_TX.v) file in this repository.

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

## Elaborated Design
The UART TX block is composed of four primary blocks, each serving a unique function:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/f261060e-718b-4ba0-b429-9600d08de267)

### 1. Serializer ([serializer.v](./serializer.v))
The Serializer block is responsible for converting parallel data received on the `P_DATA` bus into a serial frame for transmission. It performs the task of serializing the data efficiently.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/534fdc9d-12ae-4b58-81b7-31c727dc5100)

### 2. Parity Calculator ([parity_calc.v](./parity_calc.v))
The Parity Calculator block determines the parity bit for the serial frame, ensuring data integrity during transmission. Depending on the configuration, it calculates and inserts either an even or odd parity bit into the frame.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/4e539160-5e00-49f8-bb66-b420275fd3b2)

### 3. MUX (Multiplexer) ([MUX.v](./MUX.v))
The MUX block selects the appropriate bit from the serial frame for output, facilitating the serial data transmission. It plays a critical role in the serialization process.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/193f6e9a-1b06-40d2-895d-7c51ce069470)

### 4. FSM (Finite State Machine) ([FSM.v](./FSM.v))
The FSM block controls the flow of data transmission, ensuring that data is sent in the correct order and at the right time. It orchestrates the operation of the entire UART TX block.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/2fd8fb14-f818-4590-8b4d-56cfbaf6c690)


## [Testbench](./UART_TX_tb.v)

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/c799d6f1-91df-410e-8d11-56f71768f413)

```
# /********** Even Parity Testcases **********/
# MISMATCH: 00000000000 -> EVEN PARITY TESTCASE [PASSED]
# MISMATCH: 00000000000 -> EVEN PARITY TESTCASE [PASSED]
# MISMATCH: 00000000000 -> EVEN PARITY TESTCASE [PASSED]
# /********** Odd Parity Testcases **********/
# MISMATCH: 00000000000 ->  ODD PARITY TESTCASE [PASSED]
# MISMATCH: 00000000000 ->  ODD PARITY TESTCASE [PASSED]
# MISMATCH: 00000000000 ->  ODD PARITY TESTCASE [PASSED]
# /********** NO Parity Testcases **********/
# MISMATCH:  0000000000 ->   NO PARITY TESTCASE [PASSED]
# MISMATCH:  0000000000 ->   NO PARITY TESTCASE [PASSED]
# MISMATCH:  0000000000 ->   NO PARITY TESTCASE [PASSED]
# /**** Passing New Data While Transmission ****/
# MISMATCH: 00000000000 -> IGNORING INPUT TESTCASE [PASSED]
```


