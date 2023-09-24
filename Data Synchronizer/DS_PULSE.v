module D
  ( input   wire    CLK             ,
    input   wire    RST             ,
    input   wire    bus_enable      ,
    output  wire    pulse           ,
    output  reg     enable_pulse    );

    // enable shifting
    PULSE_GEN  inst_PULSE_GEN (
      .CLK(CLK)       ,   
      .RST(RST)       ,  
      .LVL_SIG(bus_enable)   ,  
      .PULSE_SIG(pulse) );
    
    // passing the enable pulse
    always @(negedge RST or posedge CLK)
    begin
      if(!RST)
        enable_pulse <= 1'b0;
      else
        enable_pulse <= pulse;
    end
    
    
endmodule
