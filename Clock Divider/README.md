# Clock Divider (Frequency Multiplier) Block

## Overview
The Clock Divider (Frequency Multiplier) block is a vital component within our Low Power Configurable Multi-Clock Digital System. Its purpose is to take an input clock signal of a certain frequency and generate an output clock signal with a different frequency, achieving frequency multiplication as needed.

## Block Description
In digital systems, managing clock frequencies is crucial for proper operation. The Clock Divider block provides the capability to multiply the input clock frequency to match the specific requirements of our digital design.

## Block Interface
The Clock Divider block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/0da54eaa-ea99-4f3d-a77f-7d635b0c1992)

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

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/d59e5943-36bd-4335-8283-ded552d0f39f)

## [Testbench](./ClkDiv_tb.v)
![Uploading image.png…]()

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

