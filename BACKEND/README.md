# ASIC Flow Overview
This document provides an overview of the Application-Specific Integrated Circuit (ASIC) design flow, outlining the key phases from RTL design to DFT insertion. Each phase contributes to the successful creation of a custom digital integrated circuit.

## RTL Design
The RTL (Register-Transfer Level) design phase is the starting point for ASIC development. During this phase, the system's functionality is described using hardware description languages (HDLs) like Verilog or VHDL. Designers create high-level representations of digital logic, specifying the interconnections and operations of various components within the ASIC.

### [SYS_TOP](./SYS_TOP.v) Simulation Result

```
# Write Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=32  
# Read Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=32  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=32  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=32  
# Write Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=32  
# Read Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=32  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=32  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=32  
# Write Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=32  
# Read Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=32  
# ALU Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=32  
# ALU Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=32  
# Write Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=16  
# Read Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=16  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=16  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE=16  
# Write Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=16  
# Read Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=16  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=16  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE=16  
# Write Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=16  
# Read Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=16  
# ALU Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=16  
# ALU Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE=16  
# Write Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE= 8  
# Read Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE= 8  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE= 8  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=0  PRESCALE= 8  
# Write Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE= 8  
# Read Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE= 8  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE= 8  
# ALU Operation is succeeded with configurations PARITY_ENABLE=1 PARITY_TYPE=1  PRESCALE= 8  
# Write Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE= 8  
# Read Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE= 8  
# ALU Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE= 8  
# ALU Operation is succeeded with configurations PARITY_ENABLE=0 PARITY_TYPE=0  PRESCALE= 8 
```

## [Synthesis](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/523d0aed7bb8a34674a57778fa5e1acd2a9f78f2/System%20Top/Synthesis)
Once the RTL design is complete, synthesis is the next crucial step. In this phase, the RTL code is transformed into a gate-level netlist. The synthesis tool maps the RTL description onto specific target libraries, optimizing for factors like area, power, and speed. The result is a gate-level representation of the design, which can be further optimized.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/f785937b-2dbe-46fe-916f-efcdfd1c4a6b)

## Post-Synthesis Formal Verification
After synthesis, formal verification techniques are employed to ensure that the gate-level netlist accurately reflects the original RTL design. Formal methods, such as model checking and equivalence checking, are used to mathematically verify that the design behaves as intended. This phase helps identify and rectify any discrepancies introduced during synthesis.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/24e354db-672d-436b-8089-4b713ce81eb9)

## [DFT Insertion](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/bbccaeeca005c569c398ab85718bef4f8792171a/System%20Top/DFT)

Design for Testability (DFT) is a critical phase in ASIC development, aimed at ensuring efficient testing of the final chip. During DFT insertion, various test structures, such as scan chains and boundary scan cells, are added to the design. These structures enable comprehensive testing of the ASIC's functionality and help diagnose and debug any faults.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/3d1456b6-1ae7-4273-8c3a-dbb44bf4f703)

## [Post-DFT Formal Verification](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/tree/bbccaeeca005c569c398ab85718bef4f8792171a/System%20Top/Formal%20Verification%20(POST-DFT))

Following DFT insertion, formal verification is once again applied to the modified design. This phase ensures that the test structures and DFT logic are correctly integrated into the ASIC and that they do not introduce any unintended behavior. Formal methods play a crucial role in confirming that the DFT enhancements do not compromise the design's integrity.

![image](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/4546e26e-a7bb-4861-9167-1683401d9534)

## Physical Design and Place-and-Route (PnR)
In the Physical Design phase, the logical design is translated into a physical layout. This involves defining the exact locations and sizes of transistors, interconnections, and metal layers on the silicon wafer. The Place-and-Route (PnR) tool plays a crucial role in determining the optimal placement of components and routing of connections to meet performance, power, and area constraints.

![PnR](https://github.com/AhmedAmrAbdellatif1/Multi-Clock-Domain-System/assets/140100601/527d96c1-464e-4f4a-9350-50533389b6a2)
