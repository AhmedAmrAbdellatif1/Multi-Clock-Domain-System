`timescale 1ns/100ps

module ClkGate_tb ();

reg CLK_EN;
reg CLK;
wire GATED_CLK;

initial
begin
  CLK = 0;
  CLK_EN = 0;
  
  #10
  @(posedge CLK)
  #2
  CLK_EN = 1;
  #20
  CLK_EN = 0;
  #28
  
  @(negedge CLK)
  #2
  CLK_EN = 1;
  #20
  CLK_EN = 0;
  #3
  
  @(posedge CLK)
  #1
  CLK_EN = 1;
  #1
  CLK_EN = 0;
  #3
  
  @(negedge CLK)
  #1
  CLK_EN = 1;
  #1
  CLK_EN = 0;
  #3
  
  #20 $stop;

end
 
always #5 CLK = ~CLK;

ClkGate DUT	( .CLK_EN(CLK_EN),
              .CLK(CLK),
              .GATED_CLK(GATED_CLK)	);


endmodule