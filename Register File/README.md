# Register File Block

## Overview
The Register File is a critical component of our multi-clock domain mini-processor system. It serves as the primary storage for our processor's registers, enabling efficient data retrieval and manipulation during program execution. 
The Register File consists of 8 registers, each register of 16-bit width.


## Block Description
The Register File block is responsible for the following key functions:

- **Register Storage:** It provides storage for a set of registers, each capable of holding data of a specific width.

- **Read Access:** The block supports read operations, allowing the processor to access the contents of registers as needed for computations.

- **Write Access:** It also enables write operations, allowing the processor to update the contents of registers when required.

- **Register Indexing:** The block accepts register address inputs, indicating the target registers for read or write operations.

## Block Interface
The Register File block has the following interface:

- **Inputs:**
  - `WrData`: 8-bits Data input for write operations.
  - `WrEn`: Control signal enabling write operations.
  - `RdEn`: Control signal enabling read operations.
  - `Address`: Register address input for read or write operations.
  - `CLK`: Clock signal for sequential elements.
  - `RST`: Active-low asynchronous reset signal to clear the sequential elements.

- **Outputs:**
  - `RdData`: Data output for read operations.
  - 'RdData_Valid`: Status flag indicating that the data read from the register is valid.
  - `REG0`: The register contents at address 0x0, used by the system to store ALU Operand A
  - `REG1`: The register contents at address 0x1, used by the system to store ALU Operand B
  - `REG2`: The register contents at address 0x2, used by the system to store UART Config
  - `REG3`: The register contents at address 0x3, used by the system to store Div Ratio
 
  ![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/fcefdc49-c7f5-49ff-bae6-ab6169afaa6f)

  > For a better understanding of how the Rgister File block is implemented in RTL (Register-Transfer Level) code, please refer to the `RegFile.v` file in this repository.


## Usage
To effectively utilize the Register File block within our system, follow these steps:

1. Use the `Address` input to specify which registers you want to read data from or write data into.

2. The `RdData` output will provide the data stored in the specified register when the `RdEn` signal is asserted.

3. To update the contents of a register, set the `Address` input to the target register, provide the data to be written in `WrData`, and assert the `WrEn` signal.

4. Only one operation (read or write) can be evaluated at a time.

## Elaborated Design

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/1e8efb0f-a027-4d24-9e7d-a0fea8e9899e)

## Testbench



