`timescale  1ns/100ps

module UART_TX_tb();
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter WIDTH       = 8;          // width of the input data
  parameter par_frame   = 11;         // frame size with a parity bit
  parameter nopar_frame = 10;         // frame size without a partiy bit
  parameter TESTCASES   = 9;          // no. of parity testcases
  parameter CLK_PERIOD  = 5;          // 200MHz frequency
  parameter HALF_PERIOD = 2.5;        
  parameter EVEN        = 0;          // Even Parity => PAR_TYP
  parameter ODD         = 1;          // Odd Parity => PAR_TYP
  parameter HIGH        = 1;        
  parameter LOW         = 0;
 
  
  // interface ports 
  reg    [WIDTH-1:0] P_DATA;
  reg                DATA_VALID;
  reg                PAR_EN;
  reg                PAR_TYP;
  reg                CLK;
  reg                RST;
  wire               TX_OUT;
  wire               Busy;
  
  // register to store output serial data for testing
  reg [par_frame-1:0]    tx_pdata;
  reg [nopar_frame-1:0]  tx_npdata;
  
  // testing memories
  reg   [WIDTH-1:0]     input_data[0:TESTCASES-1];
  reg   [par_frame-1:0] expec_out [0:TESTCASES-1];
  
  // control loop index
  integer i,n;
  
/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile("UART_TX.vcd");
    $dumpvars;
    
    // the .txt files has 9 rows, each 3 rows represet different testcase
    // first section:   even parity
    // second section:  odd parity
    // third section:   no parity
    $readmemb("input_data.txt",input_data);
    $readmemb("expected_output.txt",expec_out);
    
    initialize();
    reset();
    
    #CLK_PERIOD
    n = 0;
    
    $display("/********** Even Parity Testcases **********/");
    repeat(3) 
    begin
      even_parity(input_data[n],expec_out[n]);
      n = n + 1;
      #CLK_PERIOD;
    end
    
    $display("/********** Odd Parity Testcases **********/");
    repeat(3) 
    begin
      odd_parity(input_data[n],expec_out[n]);
      n = n + 1;
      #CLK_PERIOD;
    end
        
    $display("/********** NO Parity Testcases **********/");
    repeat(3) 
    begin
      NO_parity(input_data[n],expec_out[n]);
      n = n + 1;
      #CLK_PERIOD;
    end
    
    $display("/**** Passing New Data While Transmission ****/");
    adding_new_data(input_data[0],expec_out[0]);

    // we disabled this feature in FSM.v line 64, un-comment both to enable it
    //$display("/********** Two Successive Bytes **********/");
    //two_success_bytes(input_data[0],expec_out[0],input_data[3],expec_out[3]);
    
    #(5*CLK_PERIOD) $stop;
  end
  
/*******************************************************************/
////////////////////////////// TASKS ////////////////////////////////
/*******************************************************************/
  task reset;
    begin
      RST = HIGH;
      #HALF_PERIOD;
      RST = LOW;
      #HALF_PERIOD
      RST = HIGH;
      tx_pdata  = 'bx;          // evacute the register for another test
      tx_npdata = 'bx;
    end
  endtask
  /********************************/
  task initialize;
    begin
      RST         = HIGH;
      CLK         = LOW;
      P_DATA      = 'b0;
      PAR_EN      = LOW;
      PAR_TYP     = LOW;
      DATA_VALID  = LOW;
    end
  endtask
  /********************************/
  task valid;
    begin
      DATA_VALID  = HIGH;
      #CLK_PERIOD
      DATA_VALID  = LOW;
    end
  endtask
  /********************************/
  task even_parity;
    input [WIDTH-1:0] data;             // input parallel data
    input [par_frame-1:0] check_data;   // expected output data
    reg [par_frame-1:0] mismatch;       // mismatch bits
    integer cycle;                      // control loop index
    
    begin
      reset();
      P_DATA  = data;                   
      PAR_EN  = HIGH;
      PAR_TYP = EVEN;
      
      valid();
      
      cycle = par_frame - 1;
      
      repeat(par_frame)   // preserve the output serial data in a register
        begin
          @(negedge CLK)
          tx_pdata[cycle] = TX_OUT;
          cycle = cycle - 1;
        end
        
        #CLK_PERIOD
        mismatch = tx_pdata - check_data; 
        if(tx_pdata == check_data)
          $display("MISMATCH: %11b -> EVEN PARITY TESTCASE [PASSED]",mismatch);
        else
          $display("MISMATCH: %11b -> EVEN PARITY TESTCASE [FAILED]",mismatch);
          
        #CLK_PERIOD;
    end
  endtask
  /********************************/
  task odd_parity;
    input [WIDTH-1:0] data;
    input [par_frame-1:0] check_data;
    
    reg [par_frame-1:0] mismatch;
    integer cycle;
    begin
      reset();
      P_DATA  = data;
      PAR_EN  = HIGH;
      PAR_TYP = ODD;
      
      valid();
      
      cycle = par_frame - 1;
      repeat(par_frame)
        begin
          @(negedge CLK)
          tx_pdata[cycle] = TX_OUT;
          cycle = cycle - 1;
        end
        #CLK_PERIOD
        mismatch = tx_pdata - check_data;
        if(tx_pdata == check_data)
          $display("MISMATCH: %11b ->  ODD PARITY TESTCASE [PASSED]",mismatch);
        else
          $display("MISMATCH: %11b ->  ODD PARITY TESTCASE [FAILED]",mismatch);
          
        #CLK_PERIOD;
    end
  endtask
  /********************************/
  task NO_parity;
    input [WIDTH-1:0] data;
    input [nopar_frame-1:0] check_data;
    
    reg [nopar_frame-1:0] mismatch;
    integer cycle;
    begin
      reset();
      P_DATA  = data;
      PAR_EN  = LOW;
      
      valid();
      
      cycle = nopar_frame - 1;
      repeat(nopar_frame)
        begin
          @(negedge CLK)
          tx_npdata[cycle] = TX_OUT;
          cycle = cycle - 1;
        end
        #CLK_PERIOD
        mismatch = tx_npdata - check_data;
        if(tx_npdata == check_data)
          $display("MISMATCH: %11b ->   NO PARITY TESTCASE [PASSED]",mismatch);
        else
          $display("MISMATCH: %11b ->   NO PARITY TESTCASE [FAILED]",mismatch);
          
        #CLK_PERIOD;
    end
  endtask
  /********************************/
  task two_success_bytes;
    input [WIDTH-1:0] data_1;
    input [par_frame-1:0] check_data_1;
    input [WIDTH-1:0] data_2;
    input [par_frame-1:0] check_data_2;
    
    reg [2*(par_frame)-1:0] tx_o_data;
    reg [2*(par_frame)-1:0] mismatch;
    integer cycle;
    begin
      reset();
      P_DATA  = data_1;
      
      PAR_EN  = HIGH;
      PAR_TYP = EVEN;
      
      valid();
      
      cycle = 2*(par_frame)-1;
      repeat(par_frame)
        begin
          @(negedge CLK)
          tx_o_data[cycle] = TX_OUT;
          cycle = cycle - 1;
        end
        
            begin
              DATA_VALID  = HIGH;
              P_DATA  = data_2;
              PAR_EN  = HIGH;
              PAR_TYP = ODD;
            end
      
      #CLK_PERIOD;
      DATA_VALID  = LOW;
       repeat(par_frame)
        begin
          @(negedge CLK)
          tx_o_data[cycle] = TX_OUT;
          cycle = cycle - 1;
        end
        
        #CLK_PERIOD
        mismatch = tx_o_data - {check_data_1,check_data_2};
        if(!mismatch)
          $display("MISMATCH: %22b ->  TWO SUCCESSIVE BYTES TESTCASE [PASSED]",mismatch);
        else
          $display("MISMATCH: %22b ->  TWO SUCCESSIVE BYTES [FAILED]",mismatch);
          
        #CLK_PERIOD;
    end
  endtask
  /********************************/ 
  task adding_new_data;
    input [WIDTH-1:0] data;             // input parallel data
    input [par_frame-1:0] check_data;   // expected output data
    reg [par_frame-1:0] mismatch;       // mismatch bits
    
    integer RANDOM;
    integer cycle;                      // control loop index
    
    begin
      reset();
      P_DATA  = data;                   
      PAR_EN  = HIGH;
      PAR_TYP = EVEN;
      valid();
    
      cycle = par_frame - 1;
      
      repeat(par_frame)   // preserve the output serial data in a register
        begin
          @(negedge CLK)
          RANDOM = $urandom %127;           // random 7-bit generator
          tx_pdata[cycle] = TX_OUT;
          cycle = cycle - 1;
          P_DATA = {RANDOM,~^(RANDOM)};   // random 8-bit odd parity generator
        end
        
        #CLK_PERIOD
        mismatch = tx_pdata - check_data; 
        if(tx_pdata == check_data)
          $display("MISMATCH: %11b -> IGNORING INPUT TESTCASE [PASSED]",mismatch);
        else
          $display("MISMATCH: %11b -> IGNORING INPUT TESTCASE [FAILED]",mismatch);
          
        #CLK_PERIOD;
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
  UART_TX DUT ( .P_DATA(P_DATA),
                .DATA_VALID(DATA_VALID),
                .PAR_EN(PAR_EN),
                .PAR_TYP(PAR_TYP),
                .CLK(CLK),
                .RST(RST),
                .TX_OUT(TX_OUT),
                .Busy(Busy)             );
endmodule
