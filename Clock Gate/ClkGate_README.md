
# Clock Gate Block

## Overview
The Clock Gate block plays a pivotal role in my Low Power Configurable Multi-Clock Digital System design. It employs the widely adopted technique of Clock Gating to efficiently reduce dynamic power consumption by selectively disabling the clock signal during idle periods.

## Block Description
In modern digital systems, optimizing power consumption is paramount. The Clock Gate block offers an effective solution by allowing me to control the clock signal, turning it off when a specific block is in an idle state.

## Block Interface
The Clock Gate block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/ac110b9a-378f-47f9-961e-033e6067a5da)

- **Inputs:**
  - `CLK_EN`: Clock Enable signal, determining whether the clock should be gated or not.
  - `CLK`: The primary clock signal.
  
- **Outputs:**
  - `GATED_CLK`: The clock signal, gated or disabled when `CLK_EN` indicates an idle state.

> To gain a deeper insight into how the Clock Gate block is implemented in RTL (Register-Transfer Level) code, please refer to the [`ClkGate.v`](.ClkGate.v) file in this repository.

## Key Functionality
The Clock Gate block's primary function is to efficiently manage power consumption by controlling the clock signal based on the `CLK_EN` input. This enables me to reduce dynamic power consumption during idle periods of specific blocks within my digital system.

## Understanding the RTL code
For a detailed understanding of how the Clock Gate is implemented in Verilog, please refer to the [`ClkGate.v`](.ClkGate.v) file in this repository.
- the Clock Gating Cell is implemented using a LATCH and an AND gate, but due to wire delay, it might cause errors. thus, the RTL code is used only in simulation as there's no wire delay in simulation. but during synthesis this design is replaced by ICG (integrated clock gating) full custom standard cell, which resolves the problem of wire delay
- My code uses generated case statement to define the modelling of the cell, depending on the current stage of the flow, whether we're at the RTL designing phase or we're at the synthesis phase

## [Testbench](./ClkGate_tb.v)
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/dabfe29b-83cf-4eec-9229-f882a7fb2e12)
