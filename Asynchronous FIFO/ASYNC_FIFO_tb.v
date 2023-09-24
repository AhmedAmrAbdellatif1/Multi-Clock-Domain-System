`timescale 1ns/100ps

module ASYNC_FIFO_tb ();
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter DATA_WIDTH    = 8   , MEM_in_DEPTH      = 8     ,   PTR_WIDTH = ($clog2(MEM_in_DEPTH)+1);
  parameter W_CLK_PERIOD  = 10  ,	W_HALF_PERIOD  = 5      ;
  parameter R_CLK_PERIOD  = 25  ,	R_HALF_PERIOD  = 12.5   ;         
  parameter HIGH          = 1   ,	LOW            = 0      ;
 
  defparam DUT.MEM_DEPTH = MEM_in_DEPTH;
  // interface ports
  reg                     W_CLK   ;
  reg                     W_RST   ;
  reg                     W_INC   ;
  reg                     R_CLK   ;
  reg                     R_RST   ;
  reg                     R_INC   ;
  reg   [DATA_WIDTH-1:0]  W_DATA  ;
  wire                    FULL    ; 
  wire  [DATA_WIDTH-1:0]  R_DATA  ;
  wire                    EMPTY   ;
  
  // testing MEM_inory
  reg [DATA_WIDTH-1:0]  MEM_in  [2*MEM_in_DEPTH-1:0];
  reg [DATA_WIDTH-1:0]  MEM_out [2*MEM_in_DEPTH-1:0];
  integer i,j,o;
  
/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile("ASYNC_FIFO.vcd");
    $dumpvars;
  
    initialize();
    for(i = 0; i < 2*MEM_in_DEPTH; i = i + 1)
    begin
      MEM_in[i] = $random %(2**DATA_WIDTH - 1);
    end
  end
  
  // read initial block
  initial
  begin
     r_reset();
     for(j = 0; j < 2*MEM_in_DEPTH; j = j + 1)
     begin
       wait(!EMPTY)
       @(negedge R_CLK)
       MEM_out[j] = R_DATA;
       R_INC = HIGH;
       #R_CLK_PERIOD
       R_INC = LOW;
       #R_CLK_PERIOD;
     end
    #(R_CLK_PERIOD)
    for(o = 0; o < 2*MEM_in_DEPTH; o = o + 1)
     begin
       if(MEM_out[o] == MEM_in[o])
         $display("MEMORY[%2d]: CAPTURE PASSED",o);
       else
         $display("MEMORY[%2d]: CAPTURE FAILED",o);
     end
    #(10*R_CLK_PERIOD) $stop;
  end
  
  // write initial block
  initial
  begin
    w_reset();
    for(i = 0; i < 2*MEM_in_DEPTH; i = i + 1)
     begin
       wait(!FULL)
       @(negedge W_CLK)
       W_INC = HIGH;
       W_DATA = MEM_in[i];
       #W_CLK_PERIOD
       W_INC = LOW;
       #W_CLK_PERIOD;
     end
  end
  
/*******************************************************************/
////////////////////////////// TASKS ////////////////////////////////
/*******************************************************************/
  task w_reset;
    begin
      W_RST = LOW;
      #W_HALF_PERIOD
      W_RST = HIGH;
      #W_HALF_PERIOD;
    end
  endtask
  /********************************/
  task r_reset;
    begin
      R_RST = LOW;
      #R_HALF_PERIOD
      R_RST = HIGH;
      #R_HALF_PERIOD;
    end
  endtask
  /********************************/
  task initialize;
    begin
      W_CLK   = LOW;
      W_RST   = LOW;
      W_INC   = LOW;
      R_CLK   = LOW;
      R_RST   = LOW;
      R_INC   = LOW;
      W_DATA  = LOW;
    end
  endtask
  /********************************/

/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always #W_HALF_PERIOD W_CLK = ~W_CLK;
  always #R_HALF_PERIOD R_CLK = ~R_CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/

ASYNC_FIFO DUT (
  .i_Wclk     (W_CLK)     ,
  .i_Wrst_n   (W_RST)     ,
  .i_Winc     (W_INC)     ,
  .i_Rclk     (R_CLK)     ,
  .i_Rrst_n   (R_RST)     ,
  .i_Rinc     (R_INC)     ,
  .i_Wdata    (W_DATA)    ,
  .o_full     (FULL)      ,
  .o_Rdata    (R_DATA)    ,
  .o_empty    (EMPTY)     );

endmodule
