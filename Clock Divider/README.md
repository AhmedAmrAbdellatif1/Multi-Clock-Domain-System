# Clock Divider (Frequency Divider) Block

## Overview
The Clock Divider (Frequency Divider) block is a vital component within our Low Power Configurable Multi-Clock Digital System. Its purpose is to take an input clock signal of a certain frequency and generate an output clock signal with a different frequency, achieving frequency division as needed.

## Block Description
In digital systems, managing clock frequencies is crucial for proper operation. The Clock Divider block provides the capability to divide the input clock frequency to match the specific requirements of our digital design.

## Block Interface
The Clock Divider block has the following interface:

<p align="left">
  <img src="https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/0da54eaa-ea99-4f3d-a77f-7d635b0c1992" width=600 alt="Block Interface">
</p>  

- **Inputs:**
  - `I_ref_clk`: Reference clock frequency input.
  - `I_rst_n`: Active-low asynchronous reset signal.
  - `I_clk_en`: Clock Divider Block Enable signal.
  - `I_div_ratio`: The desired divided ratio (an integer value).

- **Output:**
  - `o_div_clk`: The generated clock signal with the divided or multiplied frequency.

> For a detailed look at the Verilog implementation of the Clock Divider block, please refer to the [`ClkDiv.v`](./ClkDiv.v) file in this repository.

## Key Functionality
The Clock Divider block's primary function is to adjust the clock period based on the input divided ratio. This flexibility ensures that our digital system operates with the precise timing required for its various components.

## Expected Waveforms
![clkdiv](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/6942cecb-4e00-481d-a55b-ebc55aa40a01)

## [Testbench](./ClkDiv_tb.v)
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/ddf7df87-f36a-45f0-a0e7-d21a36a19b91)

```
# [PASSED]: div ratio = 0, clock period = 10ns, div clock period = 10ns
# [PASSED]: div ratio = 1, clock period = 10ns, div clock period = 10ns
# [PASSED]: div ratio = 2, clock period = 10ns, div clock period = 20ns
# [PASSED]: div ratio = 3, clock period = 10ns, div clock period = 30ns
# [PASSED]: div ratio = 4, clock period = 10ns, div clock period = 40ns
# [PASSED]: div ratio = 5, clock period = 10ns, div clock period = 50ns
# [PASSED]: div ratio = 6, clock period = 10ns, div clock period = 60ns
# [PASSED]: div ratio = 7, clock period = 10ns, div clock period = 70ns
# [PASSED]: div ratio = 8, clock period = 10ns, div clock period = 80ns
# [PASSED]: div ratio = 9, clock period = 10ns, div clock period = 90ns
```

