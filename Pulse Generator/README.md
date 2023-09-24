# Pulse Generator Block

## Overview
The Pulse Generator block is a fundamental component in our Low Power Configurable Multi-Clock Digital System design. It serves the essential function of generating precise pulses based on control signals, enabling synchronized actions within our digital system.

## Block Description
In digital systems, generating accurate and controlled pulses is crucial for synchronizing various operations. The Pulse Generator block efficiently creates pulses based on specific control signals, facilitating precise timing and coordination within the system.

## Block Interface
The Pulse Generator block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/62298708-7b8a-4481-a8c1-05febe86f983)

- **Inputs:**
  - `CLK`: Clock signal for the sequential elements within the Pulse Generator.
  - `RST`: Asynchronous active-low reset signal to initialize and clear the pulse generation process.
  - `LVL_SIGNAL`: Control signal that determines the pulse characteristics.

- **Outputs:**
  - `PULSE_SIGNAL`: The generated pulse signal with controlled characteristics based on the `LVL_SIGNAL` input.

> For a better understanding of how the Pulse Generator block is implemented in RTL (Register-Transfer Level) code, please refer to the [`PULSE_GEN.v`](.PULSE_GEN.v) file in this repository.

## Key Functionality
The Pulse Generator block's primary function is to create precise pulses based on the `LVL_SIGNAL` input. It offers flexibility and control over pulse characteristics, making it an essential component for coordinating actions within our digital system.

## [Testbench](./PULSE_GEN_tb.v)
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/2e8fe5f4-412b-481a-8430-4ee73543a09b)
