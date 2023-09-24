# Data Synchronizer Block

## Overview
The Data Synchronizer block is a critical component in our multi-clock domain mini-processor design. It plays a vital role in managing data synchronization across different clock domains, solving the complex challenge of Clock Domain Crossing (CDC).

## Block Description
The Data Synchronizer employs a Synchronized MUX-Select Synchronization Scheme, which effectively synchronizes multiple bits and ensures reliable data transfer between asynchronous clock domains.

## Block Interface
The Data Synchronizer block has the following interface:

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/f7cb8624-704a-4af9-9ba2-c6093e7c7016)

- **Inputs:**
  - `unsync_bus`: The unsynchronized data bus to be synchronized across clock domains.
  - `bus_enable`: Control signal indicating when data synchronization is required.
  - `CLK`: Clock signal for the sequential elements within the Data Synchronizer.
  - `RST`: Asynchronous active-low reset signal to clear the internal state.

- **Outputs:**
  - `sync_bus`: The synchronized data bus, ensuring that data arrives reliably in the destination clock domain.
  - `enable_pulse`: Control signal indicating the synchronization process has occurred, enabling subsequent actions in the design.

## Block Components
The Data Synchronizer block comprises the following key components:

- **Multi Flip-Flop Enable Synchronizer:** This component ensures that data is correctly synchronized across clock domains while minimizing metastability issues.

- **Pulse Generator Block:** Responsible for generating a pulse signal (`enable_pulse`) that signifies the successful synchronization of data.

- **Multiplexer-Based Block:** This block facilitates the selection of the correct synchronized data, ensuring it aligns with the target clock domain.

## Synchronized MUX-Select Synchronization Scheme
The Data Synchronizer employs a unique synchronization scheme that overcomes Clock Domain Crossing challenges. This scheme ensures data integrity and consistency between different clock domains, making it a crucial component in our design.

## Example RTL Code
For a deeper understanding of how the Data Synchronizer is implemented in RTL (Register-Transfer Level) code, please refer to the `data_synchronizer.v` file in this repository.

```verilog
// Sample Verilog code illustrating the Data Synchronizer functionality
module data_synchronizer (
  input wire [DATA_WIDTH-1:0] unsync_bus,
  input wire bus_enable,
  input wire CLK,
  input wire RST,
  output wire [DATA_WIDTH-1:0] sync_bus,
  output wire enable_pulse
);
  // Implementation details go here
  // ...
endmodule

