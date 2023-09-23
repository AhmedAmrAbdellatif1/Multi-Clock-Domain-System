`timescale 1ns/10ps
/*******************************************************************/
//  To try different No. of Stages,
//  you can changes the parameter values in line 15 and re-run
/*******************************************************************/

module RST_SYNC_tb();
  
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter CLK_PERIOD  = 10  ,	HALF_PERIOD = 5;        
  parameter HIGH        = 1   ,	LOW         = 0;
  parameter NUM_STAGES  = 2;
  
  defparam DUT.NUM_STAGES = NUM_STAGES;
 
  
  // interface ports
  reg   CLK       ;
  reg   RST       ;
  wire  SYNC_RST  ;
  
/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile("BIT_SYNC.vcd");
    $dumpvars;
  
    initialize();
    reset();
    
    latency_test();
    
    #(2*CLK_PERIOD) $stop;
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
      CLK   = LOW;
      RST   = HIGH;
    end
  endtask
/********************************/
  task latency_test;
    integer first_time, second_time, period;
    begin
      #(3*CLK_PERIOD)
      @(posedge CLK)
      //#(0.2*CLK_PERIOD)
      RST = LOW;
      @(negedge CLK)
      #(0.9*HALF_PERIOD);
      RST = HIGH;
    end
  endtask

/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always #HALF_PERIOD CLK = ~CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/
  RST_SYNC DUT (  .CLK        (CLK)       ,
                  .RST        (RST)       ,  
                  .SYNC_RST   (SYNC_RST)  );  

endmodule