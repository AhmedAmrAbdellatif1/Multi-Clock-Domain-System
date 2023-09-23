module RegFile_tb ();
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter   BUS_WIDTH   = 16      ,      DEPTH        = 8,                ADDR_WIDTH  = ($clog2(DEPTH)+1);
  parameter   CLK_PERIOD  = 10      ,      HALF_PERIOD  = (CLK_PERIOD/2);
  parameter   HIGH        =  1      ,      LOW          = 0;
  
  defparam DUT.BUS_WIDTH  = BUS_WIDTH;
  defparam DUT.ADDR_WIDTH = ADDR_WIDTH;
  defparam DUT.DEPTH      = DEPTH;
  
  // interface ports
  reg                     CLK           ;       // Clock Signal
  reg                     RST           ;       // Active Low Reset
  reg                     WrEn          ;       // Write Enable
  reg                     RdEn          ;       // Read Enable
  reg   [ADDR_WIDTH-1:0]  Address       ;       // Address bus
  reg   [BUS_WIDTH-1 :0]  WrData        ;       // Write Data Bus
  wire  [BUS_WIDTH-1 :0]  REG0          ;       // Register at Address 0x0
  wire  [BUS_WIDTH-1 :0]  REG1          ;       // Register at Address 0x1
  wire  [BUS_WIDTH-1 :0]  REG2          ;       // Register at Address 0x2
  wire  [BUS_WIDTH-1 :0]  REG3          ;       // Register at Address 0x3
  wire  [BUS_WIDTH-1 :0]  RdData        ;       // Read Data Bus
  wire                    RdData_Valid  ;       // Read Data Valid
  
  // test memory declaration
  reg [BUS_WIDTH-1:0] TEST_MEM [DEPTH-1:0];
  
/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/
  initial
    begin
      $dumpfile("RegFile.vcd");
      $dumpvars;
      initialize();
      init_mem();
      reset();
      
      $display("/******************** Writing Testcases **************************/");
      write_data();
      
      $display("/******************** Reading Testcases **************************/");
      read_data();
      
      $display("/******************** Enables Testcases **************************/");
      no_write_no_read();
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
      CLK     = LOW;
      RST     = LOW;
      WrEn    = LOW;
      RdEn    = LOW;
      Address = LOW;
      WrData  = LOW;
    end
  endtask
  /********************************/
  task init_mem;
    integer i;
    begin
      for(i = 0; i < DEPTH; i = i + 1)
      begin
        TEST_MEM[i] = ($random %(2**BUS_WIDTH-1));
      end
    end
  endtask
  /********************************/
  task write_data;
    integer i;
    begin
      @(negedge CLK)
      WrEn = HIGH;
      RdEn = LOW;
      
      // writing in a memory for loop
      for(i = 0; i < DEPTH; i = i + 1)
      begin
        Address = i;
        WrData  = TEST_MEM[i];
        #CLK_PERIOD;
      end
      
      #CLK_PERIOD
      
      // checking the memory contents for loop
      for(i = 0; i < DEPTH; i = i + 1)
      begin
        if(DUT.MEM[i] == TEST_MEM[i])
          $display("[PASSED]:  Write in Address %3b",i);
        else
          $display("[FAILED]:  Write in Address %3b",i);
      end
      
    end
  endtask
  /********************************/
  task read_data;
    integer i;
    begin
      @(negedge CLK)
      WrEn = LOW;
      RdEn = HIGH;
      
      // checking the memory contents for loop
      for(i = 0; i < DEPTH; i = i + 1)
      begin
        Address = i;
        #CLK_PERIOD
        if((RdData == TEST_MEM[i]) && RdData_Valid)
          $display("[PASSED]: Read from Address %3b",i);
        else
          $display("[FAILED]: Read from Address %3b",i);
        #CLK_PERIOD;
      end  
    end
  endtask
  /********************************/
  task no_write_no_read;
    begin
      WrEn = LOW;
      RdEn = LOW;
      reset(); 
      #(2*CLK_PERIOD)
      
      WrEn = HIGH;
      RdEn = HIGH;
      Address = 'h0;
      WrData  = 'ha1b2;
      #CLK_PERIOD
      if(DUT.MEM[Address] == 'ha1b2)
        $display("[FAILED]: Writing accepted when WrEn = %0b RdEn = %0b",WrEn,RdEn);
      else
        $display("[PASSED]: Writing rejected when WrEn = %0b RdEn = %0b",WrEn,RdEn);
        
      #CLK_PERIOD
      if(RdData_Valid)
        $display("[FAILED]: Reading accepted when WrEn = %0b RdEn = %0b",WrEn,RdEn);
      else
        $display("[PASSED]: Reading rejected when WrEn = %0b RdEn = %0b",WrEn,RdEn);
        
      #CLK_PERIOD
      WrEn = LOW;
      RdEn = LOW;
      Address = 'h1;
      WrData  = 'hb1a2;
      #CLK_PERIOD
      if(DUT.MEM[Address] == 'hb1a2)
        $display("[FAILED]: Writing accepted when WrEn = %0b RdEn = %0b",WrEn,RdEn);
      else
        $display("[PASSED]: Writing rejected when WrEn = %0b RdEn = %0b",WrEn,RdEn);
        
      #CLK_PERIOD
      if(RdData_Valid)
        $display("[FAILED]: Reading accepted when WrEn = %0b RdEn = %0b",WrEn,RdEn);
      else
        $display("[PASSED]: Reading rejected when WrEn = %0b RdEn = %0b",WrEn,RdEn);

    end
  endtask

/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  always #HALF_PERIOD CLK = ~CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/
  RegFile DUT (
  .CLK            (CLK)           ,
  .RST            (RST)           ,
  .WrEn           (WrEn)          ,
  .RdEn           (RdEn)          ,
  .Address        (Address)       ,
  .WrData         (WrData)        ,
  .REG0           (REG0)          ,
  .REG1           (REG1)          ,
  .REG2           (REG2)          ,
  .REG3           (REG3)          ,
  .RdData         (RdData)        ,
  .RdData_Valid   (RdData_Valid)  );           
  
endmodule