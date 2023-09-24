module PULSE_GEN  (
  input   wire  CLK       ,   // Clock Signal 
  input   wire  RST       ,   // Active Low Reset
  input   wire  LVL_SIG   ,   // Level signal
  output  wire  PULSE_SIG );  // Pulse signal
  
  // register declaration
  reg DFF;
  
  // shifting the input
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      DFF <= 1'b0;
    else
      DFF <= LVL_SIG;
  end
  
  // pulse generation
  assign PULSE_SIG = (~DFF) & LVL_SIG;
  
endmodule
