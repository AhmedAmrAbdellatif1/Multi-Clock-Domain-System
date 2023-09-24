# Reset Synchronizer Block

## Overview
The Reset Synchronizer block is a crucial component in our Low Power Configurable Multi-Clock Digital System design. It addresses the challenges associated with asynchronous reset signals by ensuring synchronized de-assertion with respect to the clock domain.

## Block Description
In digital circuits, asynchronous reset signals can pose timing challenges during de-assertion, potentially violating the recovery and removal times of Flip-Flops. The Reset Synchronizer effectively manipulates the asynchronous reset signal to achieve synchronous de-assertion, enhancing the reliability of the reset operation.

## Block Interface
The Reset Synchronizer block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/76adf338-ba66-40f4-bc4a-9126835cfdbf)

- **Inputs:**
  - `RST`: Asynchronous reset signal that requires synchronization.
  - `CLK`: Clock signal for the sequential elements within the Reset Synchronizer.

- **Outputs:**
  - `SYNC_RST`: The synchronized reset signal with controlled de-assertion timing.

> For a better understanding of how the Reset Synchronizer block is implemented in RTL (Register-Transfer Level) code, please refer to the [`RESET_SYNC.v`](.RESET_SYNC.v) file in this repository.

## Parameterized Number of Synchronization Stages
One notable feature of the Reset Synchronizer block is its parameterized number of synchronization stages. This flexibility allows you to adapt the block to your specific design requirements, ensuring optimal synchronization performance.

## [Testbench](./RST_SYNC_tb.v)
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/eef146e9-cb39-4a61-9220-9a6e7591f53e)


