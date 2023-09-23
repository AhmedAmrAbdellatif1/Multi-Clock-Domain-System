module PULSE_GEN_tb ();

/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter CLK_PERIOD  = 10,	HALF_PERIOD = 5;        
  parameter HIGH        = 1,	LOW         = 0;
 
  
  // interface ports
  reg   CLK        ;
  reg   RST        ;
  reg   LVL_SIG    ;
  wire  PULSE_SIG  ;

/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile(".vcd");
    $dumpvars;
  
    initialize();
    reset();
    
    LVL_SIG = HIGH;
    
    #(3*CLK_PERIOD);
    LVL_SIG = LOW;
    #CLK_PERIOD
    #2
    LVL_SIG = HIGH;
    
    #(3*CLK_PERIOD);
    LVL_SIG = LOW;
    #CLK_PERIOD
    #5
    LVL_SIG = HIGH;
    #(3*CLK_PERIOD) $stop;
  end
  
/*******************************************************************/
////////////////////////////// TASKS ////////////////////////////////
/*******************************************************************/
  task reset;
    begin
      RST = LOW;
      #HALF_PERIOD
      RST = HIGH;
      #HALF_PERIOD;
    end
  endtask
  /********************************/
  task initialize;
    begin
      CLK = LOW;
      RST = LOW;
      LVL_SIG = LOW;
    end
  endtask
  /********************************/

/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always #HALF_PERIOD CLK = ~CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/
  PULSE_GEN DUT (
  .CLK(CLK)               ,
  .RST(RST)               ,
  .LVL_SIG(LVL_SIG)       ,
  .PULSE_SIG(PULSE_SIG)   );

endmodule
