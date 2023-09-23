`timescale 1ns/1ns
/*******************************************************************/
//  To try different Bus Width & No. of Stages,
//  you can changes the parameter values in line 15 and re-run
/*******************************************************************/

module DATA_SYNC_tb();
  
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter CLK_PERIOD  = 10  ,	HALF_PERIOD = 5;        
  parameter HIGH        = 1   ,	LOW         = 0;
  parameter BUS_WIDTH   = 8   , NUM_STAGES  = 2;
  
  defparam DUT.BUS_WIDTH  = BUS_WIDTH;
  defparam DUT.NUM_STAGES = NUM_STAGES;
 
  
  // interface ports
  reg                   CLK         ;
  reg                   RST         ;
  reg                   bus_enable  ;    
  reg   [BUS_WIDTH-1:0] unsync_bus  ;
  wire  [BUS_WIDTH-1:0] sync_bus    ;
  wire                  enable_bus  ;
  
  // test value
  reg   [BUS_WIDTH-1:0] test_var;


/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile("BIT_SYNC.vcd");
    $dumpvars;
  
    initialize();
    reset();
    
    test_var = 'haa;
    latency_test(test_var);
    
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
      CLK         = HIGH;
      RST         = HIGH;
      bus_enable  = LOW;
      unsync_bus  = LOW;
    end
  endtask
/********************************/
  task latency_test;
    input [BUS_WIDTH-1:0] test_value;

    begin
      reset();
      @(posedge CLK)
      //#(0.3*CLK_PERIOD)
      unsync_bus  = test_value;
      bus_enable  = HIGH;
      #CLK_PERIOD
      #(NUM_STAGES*CLK_PERIOD)
      #HALF_PERIOD
      
      if(sync_bus == test_value)
        $display("[PASSED] Bus Width = %0d, No. of Stages = %0d",BUS_WIDTH,NUM_STAGES);
      else
        $display("[FAILED] Bus Width = %0d, No. of Stages = %0d",BUS_WIDTH,NUM_STAGES);
    end
  endtask

/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always #HALF_PERIOD CLK = ~CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/
  DATA_SYNC DUT (
    .dest_clk       (CLK)           ,
    .dest_rst       (RST)           ,
    .bus_enable     (bus_enable)    ,    
    .unsync_bus     (unsync_bus)    ,
    .sync_bus       (sync_bus)      ,
    .enable_pulse   (enable_bus)    );

endmodule
