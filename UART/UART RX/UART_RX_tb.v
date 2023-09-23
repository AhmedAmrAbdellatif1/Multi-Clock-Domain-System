`timescale  1ns/100ps

module UART_RX_tb ();
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter CLK_PERIOD    = 5 ,   HALF_PERIOD   = 2.5; 
  parameter MAX_PRESCALE  = 32,   PRSC_WIDTH    = ($clog2(MAX_PRESCALE)+1);
  parameter EVEN          = 0 ,   ODD           = 1;
  parameter HIGH          = 1 ,   LOW           = 0;
  parameter WIDTH         = 8 ,   FRAME         = 11;
  parameter PRESCALE      = 16 ,  HALF_PRE      = (PRESCALE/2);
  parameter TESTCASES     = 9;
  
// interface ports
  reg                     clk_rx;
  reg                     clk_tx;
  reg                     rst_tb;
  reg   [PRSC_WIDTH-1:0]  prescale_tb;
  reg                     input_data_tb;
  reg                     parity_enable_tb;
  reg                     parity_type_tb;
  wire                    data_valid_tb;
  wire  [WIDTH-1:0]       output_data_tb;

// testing memories
  reg   [FRAME-1:0]   input_data[0:TESTCASES-1];
  reg   [WIDTH-1:0]   expec_out [0:TESTCASES-1];
  
// control loop index
  integer i,n;
  integer x,y;
  
/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile("UART_RX.vcd");
    $dumpvars;
    initialize();
    reset();
    
    // the .txt files has 9 rows, each 3 rows represet different testcase
    // first section:   even parity
    // second section:  odd parity
    // third section:   no parity
    $readmemb("input_data.txt",input_data);
    $readmemb("expected_output.txt",expec_out);
    
    $display("/*********************** Prescale Testcases *************************/");
    check_prescale('d8);
    check_prescale('d16);
    check_prescale('d32);

    #CLK_PERIOD
    n = 0;
    $display("/*********************** Even Parity Testcases **********************/");
    repeat(3) 
    begin
      even_parity(input_data[n],expec_out[n]);
      n = n + 1;
      #CLK_PERIOD;
    end
    
    $display("/************************ Odd Parity Testcases **********************/");
    repeat(3) 
    begin
      odd_parity(input_data[n],expec_out[n]);
      n = n + 1;
      #CLK_PERIOD;
    end 
    $display("/*********************** NO Parity Testcases ************************/");
    repeat(3) 
    begin
      no_parity(input_data[n],expec_out[n]);
      n = n + 1;
      #(PRESCALE*CLK_PERIOD);
    end
   $display("/******************** Gliches & Errors Testcases ********************/");
   begin
   start_glitch;
   #(PRESCALE*CLK_PERIOD);
   stop_error('b01011111000,'b00000000);
   #(PRESCALE*CLK_PERIOD);
   parity_error('b01011111011,'b00000000);
   end
 
   $display("/*********************** Two Successive Bytes ***********************/");
   two_success_bytes(input_data[0],expec_out[0],input_data[3],expec_out[3]);
    
    
  $display("/********************* Multiple Successive Bytes *********************/");
    for(x = 0; x < 3; x = x + 1)
    begin
      for(y = 0; y < 3; y = y + 1)
      begin
        transmit_data(input_data[y]);
      end
    end

    #(PRESCALE*CLK_PERIOD*12) $stop;
  end
  
  initial
  begin
  end
  
/*******************************************************************/
////////////////////////////// TASKS ////////////////////////////////
/*******************************************************************/
/***INITIALIZE TASK***/
task initialize;
  begin
    clk_rx  = LOW;
    clk_tx  = LOW;
    rst_tb  = HIGH;
    prescale_tb       = LOW;
    input_data_tb     = HIGH;
    parity_enable_tb  = LOW;
    parity_type_tb    = LOW;
  end
endtask

/***RESET TASK***/
task reset;
  begin
    rst_tb = LOW;
    #HALF_PERIOD
    rst_tb = HIGH;
    #HALF_PERIOD;
  end
endtask

/***EVEN PARITY TEST***/
task even_parity;
  input [FRAME-1:0] data;
  input [WIDTH-1:0] check_data;
  reg   [FRAME-1:0] mismatch;       // mismatch bits
  integer bit;
  begin

    reset();
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    parity_type_tb    = EVEN;
    repeat(11)
    begin
      @(negedge clk_tx)
      input_data_tb = data[bit];
      bit = bit + 1;
    end
    wait(data_valid_tb)
    #HALF_PERIOD
    mismatch  = (output_data_tb - check_data);
    if(!mismatch && data_valid_tb)
      $display("MISMATCH: %8b ->      EVEN PARITY TESTCASE [PASSED]",mismatch);
    else
      $display("MISMATCH: %8b ->      EVEN PARITY TESTCASE [FAILED]",mismatch);
    #CLK_PERIOD;
    
    #HALF_PERIOD
    input_data_tb = 1;
  end
endtask

/***ODD PARITY TEST***/
task odd_parity;
  input [FRAME-1:0] data;
  input [WIDTH-1:0] check_data;
  reg   [FRAME-1:0] mismatch;       // mismatch bits
  integer bit;
  begin

    reset();
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    parity_type_tb    = ODD;
    repeat(11)
    begin
      @(negedge clk_tx)
      input_data_tb = data[bit];
      bit = bit + 1;
    end
    wait(data_valid_tb)
    #HALF_PERIOD
    mismatch  = (output_data_tb - check_data);
    if(!mismatch && data_valid_tb)
      $display("MISMATCH: %8b ->       ODD PARITY TESTCASE [PASSED]",mismatch);
    else
      $display("MISMATCH: %8b ->       ODD PARITY TESTCASE [FAILED]",mismatch);
    #CLK_PERIOD;
    
    #HALF_PERIOD
    input_data_tb = 1;
  end
endtask

/***NO PARITY TEST***/
task no_parity;
  input [FRAME-2:0] data;
  input [WIDTH-1:0] check_data;
  reg   [FRAME-2:0] mismatch;       // mismatch bits
  integer bit;
  begin

    reset();
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = LOW;
    repeat(10)
    begin
      @(negedge clk_tx)
      input_data_tb = data[bit];
      bit = bit + 1;
    end
    wait(data_valid_tb)
    #CLK_PERIOD
    mismatch  = (output_data_tb - check_data);
    if(!mismatch && data_valid_tb)
      $display("MISMATCH: %8b ->        NO PARITY TESTCASE [PASSED]", mismatch);
    else
      $display("MISMATCH: %8b ->        NO PARITY TESTCASE [FAILED]", mismatch);
    #CLK_PERIOD;
    
    #HALF_PERIOD
    input_data_tb = 1;
  end
endtask

task start_glitch;
  begin
    reset();
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    input_data_tb     = LOW;
    #(3*CLK_PERIOD)   
    input_data_tb     = HIGH;
    #(PRESCALE*CLK_PERIOD)
    if(!output_data_tb && !data_valid_tb)
      $display("MISMATCH: %8b ->     START GLITCH TESTCASE [PASSED]",output_data_tb);
    else
      $display("MISMATCH: %8b ->     START GLITCH TESTCASE [FAILED]",output_data_tb);
    #CLK_PERIOD;
  end
endtask

/***PARITY BIT ERROR TEST***/
task parity_error;
  input [FRAME-1:0] data;
  input [WIDTH-1:0] check_data;
  reg   [FRAME-1:0] mismatch;       // mismatch bits
  integer bit;
  begin

    reset();
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    parity_type_tb    = EVEN;
    repeat(11)
    begin
      @(negedge clk_tx)
      input_data_tb = data[bit];
      bit = bit + 1;
    end
    #(PRESCALE*CLK_PERIOD)
    mismatch  = (output_data_tb - check_data);
    if(!mismatch && !data_valid_tb)
      $display("MISMATCH: %8b -> INCORRECT PARITY TESTCASE [PASSED]",mismatch);
    else
      $display("MISMATCH: %8b -> INCORRECT PARITY TESTCASE [FAILED]",mismatch);
    #CLK_PERIOD;
    
    #HALF_PERIOD
    input_data_tb = 1;
  end
endtask

/***STOP BIT ERROR TEST***/
task stop_error;
  input [FRAME-1:0] data;
  input [WIDTH-1:0] check_data;
  reg   [FRAME-1:0] mismatch;       // mismatch bits
  integer bit;
  begin

    reset();
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    parity_type_tb    = EVEN;
    repeat(11)
    begin
      @(negedge clk_tx)
      input_data_tb = data[bit];
      bit = bit + 1;
    end
    #(PRESCALE*CLK_PERIOD)
    mismatch  = (output_data_tb - check_data);
    if(!mismatch && !data_valid_tb)
      $display("MISMATCH: %8b ->   INCORRECT STOP TESTCASE [PASSED]",mismatch);
    else
      $display("MISMATCH: %8b ->   INCORRECT STOP TESTCASE [FAILED]",mismatch);
    #CLK_PERIOD;
    
    #HALF_PERIOD
    input_data_tb = 1;
  end
endtask

/***TWO SUCCESSIVE BYTES TEST***/
task two_success_bytes;
  input [FRAME-1:0] data_1;
  input [WIDTH-1:0] check_data_1;
  input [FRAME-1:0] data_2;
  input [WIDTH-1:0] check_data_2;
  reg   [FRAME-1:0] mismatch_1;       // mismatch bits
  reg   [FRAME-1:0] mismatch_2;       // mismatch bits
  integer bit;
  begin

    reset();
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    parity_type_tb    = EVEN;
    
    // first stream
    repeat(11)
    begin
      @(negedge clk_tx)
      input_data_tb = data_1[bit];
      bit = bit + 1;
    end
    
    @(negedge clk_rx)
    bit = 0;
    prescale_tb       = PRESCALE;
    parity_enable_tb  = HIGH;
    parity_type_tb    = ODD;
    
    // second stream
    repeat(11)
    begin
      @(negedge clk_tx)
      if(bit == 1) mismatch_1  = (output_data_tb - check_data_1);
      input_data_tb = data_2[bit];
      bit = bit + 1;
    end
    
    @(negedge data_valid_tb)
    mismatch_2  = (output_data_tb - check_data_2);
    
    #(PRESCALE*CLK_PERIOD)
    if(!{mismatch_2,mismatch_1} && !data_valid_tb)
      $display("MISMATCH: %16b -> TWO SUCCESSIVE BYTES TESTCASE [PASSED]",{mismatch_2,mismatch_1});
    else
      $display("MISMATCH: %16b -> TWO SUCCESSIVE BYTES TESTCASE [FAILED]",{mismatch_2,mismatch_1});
    #CLK_PERIOD;
    
    #HALF_PERIOD
    input_data_tb = 1;
  end
endtask

/***PRESCALE***/
task check_prescale;
  input [PRSC_WIDTH-1:0] ratio;
  integer first_edge, second_edge, period;
  begin
    reset();
    prescale_tb       = ratio;
    parity_enable_tb  = HIGH;
    input_data_tb     = LOW;
    wait(DUT.x_bit_cnt == 'd1)    first_edge  = $time;
    wait(DUT.x_bit_cnt == 'd2)    second_edge = $time;
    #CLK_PERIOD
    input_data_tb     = HIGH;
    #CLK_PERIOD
    period = second_edge - first_edge;
    if(ratio*CLK_PERIOD == period)
      $display("Prescale = %2d: RX Period = %1dns & TX Period = %3tns [PASSED]",ratio,CLK_PERIOD,period/10);
    else
      $display("Prescale = %2d: RX Period = %1dns & TX Period = %3tns [FAILED]",ratio,CLK_PERIOD,period/10);
    end
  endtask
  /***transmit data***/
   task transmit_data;
    input [FRAME-1:0] DATA;
    integer i;
    begin
      prescale_tb        = PRESCALE;
      parity_enable_tb   = HIGH;
      parity_type_tb     = EVEN;
      for(i = 0; i < FRAME; i = i + 1)
      begin
        @(negedge clk_tx)
        input_data_tb = DATA[i];
      end
    end
  endtask 
/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always #HALF_PERIOD     clk_rx = ~clk_rx;
  always
  begin
    repeat(HALF_PRE)
    begin
      @(posedge clk_rx);
    end
    clk_tx = ~clk_tx;
  end
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/
UART_RX  DUT  (
  .i_clk              (clk_rx)            ,
  .i_rst_n            (rst_tb)            ,  
  .i_prescale         (prescale_tb)       ,
  .i_serial_data      (input_data_tb)     ,    
  .i_parity_enable    (parity_enable_tb)  ,
  .i_parity_type      (parity_type_tb)    ,
  .o_data_valid       (data_valid_tb)     ,
  .o_parallel_data    (output_data_tb)    );
  
endmodule
