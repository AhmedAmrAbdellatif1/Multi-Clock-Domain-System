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

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/e078ff93-2b9c-413b-b1f8-999912ace48f)

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

## The Block Diagram for FIFO

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/42ca8d2a-883f-4acc-bbaf-e7713042b7f1)

To facilitate static timing analysis of the style #1 FIFO design, the design has been partitioned into the following six
Verilog modules with the following functionality and clock domains:

### 1. Wrapper Module ([ASYNC_FIFO.v](./ASYNC_FIFO.v))
- This top-level wrapper module includes all clock domains and serves as a wrapper to instantiate other FIFO modules.
- In a larger ASIC or FPGA design, this top-level wrapper may be discarded to group FIFO modules into their respective clock domains for improved synthesis and static timing analysis.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/e4eb84e4-5819-4d2b-b293-8be99cabbe56)

### 2. FIFO Memory Buffer ([FIFO_MEM_CNTRL.v](./FIFO_MEM_CNTRL.v))
- The FIFO memory buffer is accessed by both the write and read clock domains.
- Typically, this buffer is implemented as a synchronous dual-port RAM, although other memory styles can be adapted for use as the FIFO buffer.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/fd10039a-3846-4951-a627-e40786743c7c)

### 3. Read-to-Write Synchronizer ([DF_SYNC.v](./DF_SYNC.v))
- This module synchronizes the read pointer into the write-clock domain.
- The synchronized read pointer is used by the `FIFO_WR` module to generate the FIFO full condition.
- This module contains flip-flops synchronized to the write clock, without additional logic.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/16dc0c62-c447-4dd1-8f77-f545ae01b994)

### 4. Write-to-Read Synchronizer ([DF_SYNC.v](./DF_SYNC.v))
- This module synchronizes the write pointer into the read-clock domain.
- The synchronized write pointer is used by the `FIFO_RD` module to generate the FIFO empty condition.
- Similar to `sync_r2w.v`, this module contains flip-flops synchronized to the read clock, without additional logic.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/9d211593-3d69-46c7-a1ee-763291b7f340)

### 5. Read Pointer and Empty-Flag Logic ([FIFO_RD.v](./FIFO_RD.v))
- This module operates entirely within the read-clock domain.
- It contains the FIFO read pointer and logic for generating the empty condition.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/a4005eca-697e-46ce-9f11-b563319e0a8d)

### 6. Write Pointer and Full-Flag Logic ([FIFO_WR.v](./FIFO_WR.v))
- This module operates entirely within the write-clock domain.
- It contains the FIFO write pointer and logic for generating the full condition.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/bf34e317-cd15-4b74-8a05-31ada52054ea)

### 7. Gray Code Converter ([GRAY_CONV.v](./GRAY_CONV.v))
- The `GRAY_CONV.v` module is responsible for converting binary pointers into Gray encoded pointers.
- Gray encoding is used to decrease synchronization errors when passing pointers between clock domains, ensuring reliable calculation of empty and full flags.
  
![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/3d745080-1f65-4886-8e1b-cb4db2e78f3c)

## [Testbench](./ASYNC_FIFO_tb.v)

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/5ff86d80-e1f6-40b8-9f8f-069a776561d2)

```
MEMORY[ 0]: CAPTURE PASSED
MEMORY[ 1]: CAPTURE PASSED
MEMORY[ 2]: CAPTURE PASSED
MEMORY[ 3]: CAPTURE PASSED
MEMORY[ 4]: CAPTURE PASSED
MEMORY[ 5]: CAPTURE PASSED
MEMORY[ 6]: CAPTURE PASSED
MEMORY[ 7]: CAPTURE PASSED
MEMORY[ 8]: CAPTURE PASSED
MEMORY[ 9]: CAPTURE PASSED
MEMORY[10]: CAPTURE PASSED
MEMORY[11]: CAPTURE PASSED
MEMORY[12]: CAPTURE PASSED
MEMORY[13]: CAPTURE PASSED
MEMORY[14]: CAPTURE PASSED
MEMORY[15]: CAPTURE PASSED
```

[^1]: https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjcscnm_MKBAxWpV6QEHcLyDzQQFnoECBoQAQ&url=http%3A%2F%2Fwww.sunburst-design.com%2Fpapers%2FCummingsSNUG2002SJ_FIFO1.pdf&usg=AOvVaw3-qzaucL9OsvhhA5RKZqaM&opi=89978449
