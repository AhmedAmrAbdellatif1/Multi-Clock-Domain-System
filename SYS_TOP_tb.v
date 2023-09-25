`timescale 1ns/1ps

module SYS_TOP_tb ();
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter PRESCALE        = 32;                       
  parameter BUS_WIDTH       = 8 ,                         FRAME = 11;
  parameter REF_CLK_PERIOD  = 20,	                        REF_HALF_PERIOD    = (REF_CLK_PERIOD/2);
  parameter RX_CLK_PERIOD   = 271.267,	                   RX_HALF_PERIOD     = (RX_CLK_PERIOD/2);
  parameter TX_CLK_PERIOD   = (PRESCALE*RX_CLK_PERIOD),	  TX_HALF_PERIOD     = (TX_CLK_PERIOD/2);       
  parameter HIGH            =  1,	                        LOW                = 0;
    
  // interface ports
  reg   REF_CLK   ;
  reg   URX_CLK   ;
  reg   UTX_CLK   ;
  reg   RST       ;
  reg   RX_IN     ;
  wire  TX_OUT    ;
  wire  PAR_ERR   ;
  wire  STP_ERR   ;
  
  // integers
  integer i,j;
  
  // registers
  reg [BUS_WIDTH-1:0] read_data;
  reg [FRAME-1:0] test_out;

/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
  begin
    $dumpfile("SYS_TOP.vcd");
    $dumpvars;
  
    initialize();
    reset();
    
    @(negedge UTX_CLK)
    
    /**************************** CONFIG TESTCASE ***************************/
      
    /************************ REG FILE WRITE TESTCASE ***********************/
    // testcase (1)
      write_test('b10101010100,'b11000001000,'b11100011110);  // 0xAA - 0x4 - 0x8F
    // testcase (2)
      write_test('b10101010100,'b10000001010,'b10101001010);  // 0xAA - 0x5 - 0xA5
    // testcase (3)
      write_test('b10101010100,'b11000001110,'b11101111000);  // 0xAA - 0x7 - 0xBC


    /************************ REG FILE READ TESTCASE ************************/
    // testcase (1)
      read_test('b10101110110,'b11000001000);   // 0xBB - 0x4
    // testcase (2)
      read_test('b10101110110,'b10000001010);   // 0xBB - 0x5
    // testcase (3)
      read_test('b10101110110,'b11000001110);   // 0xBB - 0x7
    
   /******** ALU OPERATION WITH OPERAND TESTCASE ********/
      ALU_O_test('b10110011000,'b11011001000,'b11001100100,'b10000000000);  // 0xCC - 100 - 50 - 0x0
   
   /***************** ALU OPERATION WITH NO OPERAND TESTCASE ****************/
      ALU_NO_test('b10110111010, 'b11000000010);  // 0xDD - 0x1
      ALU_NO_test('b10110111010, 'b11000000100);  // 0xDD - 0x2
      ALU_NO_test('b10110111010, 'b10000000110);  // 0xDD - 0x3
     
    #(50*TX_CLK_PERIOD) $stop;
    
  end
  
/*******************************************************************/
////////////////////////////// TASKS ////////////////////////////////
/*******************************************************************/
  task reset; 
    begin
      RST = LOW;
      #RX_HALF_PERIOD
      RST = HIGH;
      #RX_HALF_PERIOD;
    end
  endtask
  /********************************/
  task initialize;
    begin
      REF_CLK   = LOW;
      URX_CLK  = LOW;
      UTX_CLK = LOW;
      RST       = LOW;
      RX_IN     = HIGH;
    end
  endtask
  /********************************/
  task write_test;
    input [FRAME-1:0] CMD,addr,data; 
    begin
      passing_input(CMD);
      passing_input(addr);
      passing_input(data);
    end
  endtask
  /********************************/
  task read_test;
    input [FRAME-1:0] CMD,addr;
    begin
      passing_input(CMD);
      passing_input(addr);
    end
  endtask
  /********************************/
  task passing_input;
    input [FRAME-1:0] frame;
    begin
      for(i = 0; i < FRAME; i = i + 1)
        begin
          RX_IN = frame[i];
          #(TX_CLK_PERIOD);
        end
    end
  endtask
 /********************************/ 
  task ALU_O_test;
    input [FRAME-1:0] CMD,Operand_A,Operand_B,ALU_FUNC; 
    begin
      passing_input(CMD);
      passing_input(Operand_A);
      passing_input(Operand_B);
      passing_input(ALU_FUNC);
    end
  endtask
  /********************************/
  task ALU_NO_test;
    input [FRAME-1:0] CMD,ALU_FUNC; 
    begin
      passing_input(CMD);
      passing_input(ALU_FUNC);
    end
  endtask
/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always  #REF_HALF_PERIOD  REF_CLK = ~REF_CLK;
  always  #RX_HALF_PERIOD   URX_CLK =~URX_CLK;
  always  #TX_HALF_PERIOD   UTX_CLK =~UTX_CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/

SYS_TOP #() DUT (
  .i_ref_clk    (REF_CLK)   ,     
  .i_uart_clk   (URX_CLK)   ,     
  .i_rst_n      (RST)       ,     
  .i_rx_in      (RX_IN)     ,
  .o_parity_err (PAR_ERR)   ,
  .o_stop_err   (STP_ERR)   ,     	 
  .o_tx_out     (TX_OUT)    );

endmodule
