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
   
> For a better understanding of how the Data Synchronizer block is implemented in RTL (Register-Transfer Level) code, please refer to the [`DATA_SYNC.v`](.DATA_SYNC.v) file in this repository.

## Elaborated Design
The Data Synchronizer block comprises the following key components:

### Multi Flip-Flop Enable Synchronizer ([multi_ff.v](./multi_ff.v))
This component ensures that data is correctly synchronized across clock domains while minimizing metastability issues.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/c6213b85-e7b5-4ce9-afc1-73b150846e64)

### Pulse Generator Block ([DS_PULSE.v](./DS_PULSE.v))
Responsible for generating a pulse signal (`enable_pulse`) that signifies the successful synchronization of data.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/9fdcf169-9dfc-446a-a482-d4231a1cc87c)

## Synchronized MUX-Select Synchronization Scheme ([sync_bus.v](./sync_bus.v))
The Data Synchronizer employs a unique synchronization scheme that overcomes Clock Domain Crossing challenges. This scheme ensures data integrity and consistency between different clock domains, making it a crucial component in our design.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/88633b99-573b-430d-83b5-ba01889e551f)

## [Testbench](./DATA_SYNC_tb.v)

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/561ab148-fd5c-4b52-afff-a646835774e1)

```
[PASSED] Bus Width = 8, No. of Stages = 2
```
