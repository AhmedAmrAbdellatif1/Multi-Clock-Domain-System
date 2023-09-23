`timescale 1us/1us

module  ALU_tb ();
  
/*******************************************************************/
///////////////////// TB Signals Declaration ////////////////////////
/*******************************************************************/
  parameter OPRND_WIDTH     =  8,   OUT_WIDTH    = 2 * OPRND_WIDTH,       CTRL_WIDTH = 4;
  parameter CLK_PERIOD      = 10,   HALF_PERIOD  = (CLK_PERIOD/2);
  parameter HIGH            =  1,   LOW          = 0;
  parameter testcases       = 16;
  
// interface ports 
    reg                       CLK          ;
    reg                       RST          ; 
    reg                       Enable       ;
    reg   [OPRND_WIDTH-1:0]   A            ;
    reg   [OPRND_WIDTH-1:0]   B            ;
    reg   [ CTRL_WIDTH-1:0]   ALU_FUN      ;
    wire  [  OUT_WIDTH-1:0]   ALU_OUT      ;
    wire                      OUT_VALID    ;
  
// for loop index
  integer current_test;   

/*******************************************************************/
////////////////////////// Initial Block ////////////////////////////
/*******************************************************************/

  initial
    begin
      $dumpfile("ALU.vcd");
      $dumpvars;
      initialize();
      reset();
      
      
      // begin testing
      for(current_test = 0; current_test < testcases; current_test = current_test + 1)
      begin
        testcase_selection(current_test);
        #CLK_PERIOD;
      end
      
      RESET_test();
      
      Enable = LOW;
      
      #(5*CLK_PERIOD) $stop;
    end
  
/*******************************************************************/
////////////////////////////// TASKS ////////////////////////////////
/*******************************************************************/
  
  //// reset task
  task reset;
    begin
      Enable = LOW;
      ALU_FUN = LOW;
      #HALF_PERIOD
      RST = LOW;
      #HALF_PERIOD
      RST = HIGH;
    end
  endtask
  
  //// initialize task  
  task initialize;
    begin
      CLK  = LOW;
      RST  = LOW;
      A    = {$random} %(2**(OPRND_WIDTH)-1);
      B    = {$random} %(2**(OPRND_WIDTH)-1);
      Enable = LOW;
      ALU_FUN = LOW;
    end
  endtask
  
  ////////////////////////////////////////
  task testcase_selection;
   input [3:0] ALU_FUN;
    begin
      case(ALU_FUN)
        4'b0000:  addition_test();
        4'b0001:  subtraction_test();
        4'b0010:  multiplication_test();
        4'b0011:  division_test();
        4'b0100:  AND_test(); 
        4'b0101:  OR_test();
        4'b0110:  NAND_test(); 
        4'b0111:  NOR_test();
        4'b1000:  NOP_test(); 
        4'b1001:  equal_test();
        4'b1010:  greater_test();
        4'b1011:  less_test();
        4'b1100:  A_LSR_test();
        4'b1101:  A_LSL_test();
        4'b1110:  B_LSR_test();
        4'b1111:  B_LSL_test();
      endcase
    end
  endtask
  ////////////////////////////////////////
  
  // (1) /////////////////////////////////
  task addition_test;
    reg   [OUT_WIDTH-1:0]   add_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0000;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      add_result = A + B;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == add_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: ADDITION" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: ADDITION" ,current_test+1);
      end
    endtask
    
    // (2) /////////////////////////////////
    task subtraction_test;
    reg   [OUT_WIDTH-1:0]   sub_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0001;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      sub_result = A - B;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == sub_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: SUBTRACTION" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: SUBTRACTION" ,current_test+1);
      end
    endtask
    
    // (3) /////////////////////////////////
    task multiplication_test;
    reg   [OUT_WIDTH-1:0]   mul_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0010;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      mul_result = A * B;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == mul_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: MULTIPLICATION" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: MULTIPLICATION" ,current_test+1);
      end
    endtask
    
    // (4) /////////////////////////////////
    task division_test;
    reg   [OUT_WIDTH-1:0]   div_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0011;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      div_result = A / B;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == div_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: DIVISION" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: DIVISION" ,current_test+1);
      end
    endtask
    
    // (5) /////////////////////////////////
    task AND_test;
    reg   [OUT_WIDTH-1:0]   AND_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0100;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      AND_result = A & B;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == AND_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: LOGICAL AND" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: LOGICAL AND" ,current_test+1);
      end
    endtask
    
    // (6) /////////////////////////////////
    task OR_test;
    reg   [OUT_WIDTH-1:0]   OR_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0101;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      OR_result = A | B;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == OR_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: LOGICAL OR" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: LOGICAL OR" ,current_test+1);
      end
    endtask
    
    // (7) /////////////////////////////////
    task NAND_test;
    reg   [OUT_WIDTH-1:0]   NAND_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0110;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      NAND_result = ~(A & B);
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == NAND_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: LOGICAL NAND" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: LOGICAL NAND" ,current_test+1);
      end
    endtask
    
    // (8) /////////////////////////////////
    task NOR_test;
    reg   [OUT_WIDTH-1:0]   NOR_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b0111;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      NOR_result = ~(A | B);
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == NOR_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: LOGICAL NOR" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: LOGICAL NOR" ,current_test+1);
      end
    endtask
    
    // (9) /////////////////////////////////
    task NOP_test;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1000;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      #CLK_PERIOD
      @(posedge CLK)
        if ( ALU_OUT == 0 && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: NOP" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: NOP" ,current_test+1);
      end
    endtask
    
    // (10) /////////////////////////////////
    task equal_test;
    reg   [2:0]   equ_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1001;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      equ_result = (A == B);
      #CLK_PERIOD
      @(posedge CLK)
        if ( ALU_OUT == equ_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%2d: EQUALITY" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%2d: EQUALITY" ,current_test+1);
      end
    endtask
    
    // (11) /////////////////////////////////
    task greater_test;
    reg   [OUT_WIDTH-1:0]   grt_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1010;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      grt_result = (A > B)? 'd2 : 'b0 ;
      #CLK_PERIOD
      @(posedge CLK)
        if ( ALU_OUT == grt_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: GREATER THAN" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: GREATER THAN" ,current_test+1);
      end
    endtask
    
    // (12) /////////////////////////////////
    task less_test;
    reg   [2:0]   less_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1011;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      less_result = (A < B)? 3'd3 : 3'b0 ;
      #CLK_PERIOD
      @(posedge CLK)
        if ( ALU_OUT == less_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: LESS THAN" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: LESS THAN" ,current_test+1);
      end
    endtask
    
    // (13) /////////////////////////////////
    task A_LSR_test;
    reg   [OUT_WIDTH:0]   shift_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1100;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      shift_result = A >> 1 ;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == shift_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: A-SHIFT RIGHT" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: A-SHIFT RIGHT" ,current_test+1);
      end
    endtask
    
    // (14) /////////////////////////////////
    task A_LSL_test;
    reg   [OUT_WIDTH-1:0]   shift_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1101;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      shift_result = A << 1 ;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == shift_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: A-SHIFT LEFT" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: A-SHIFT LEFT" ,current_test+1);
      end
    endtask
    
    // (15) /////////////////////////////////
    task B_LSR_test;
    reg   [OUT_WIDTH:0]   shift_result;
    begin
      //reset();
      @(negedge CLK)
      ALU_FUN = 4'b1110;
            Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      shift_result = B >> 1 ;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == shift_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: B-SHIFT RIGHT" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: B-SHIFT RIGHT" ,current_test+1);
      end
    endtask
    
    // (16) /////////////////////////////////
    task B_LSL_test;
    reg   [OUT_WIDTH:0]   shift_result;
    begin
      reset();
      @(negedge CLK)
      ALU_FUN = 4'b1111;
      Enable = HIGH;
      #CLK_PERIOD
      Enable = LOW;
      shift_result = B << 1 ;
      #CLK_PERIOD
      @(posedge CLK)
        if (ALU_OUT == shift_result && OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: B-SHIFT LEFT" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: B-SHIFT LEFT" ,current_test+1);
      end
    endtask
    
    // (17) /////////////////////////////////
    task RESET_test;
    begin
      @(negedge CLK) RST = LOW;
      @(posedge CLK) RST = HIGH;
      @(negedge CLK)
        if (!ALU_OUT && !OUT_VALID)
          $display("[PASSED] TESTCASE-%0d: RESET" ,current_test+1);
        else
          $display("[FAILED] TESTCASE-%0d: RESET" ,current_test+1);
      end
    endtask
      
/*******************************************************************/
///////////////////////// Clock Generator ///////////////////////////
/*******************************************************************/
  
  always #HALF_PERIOD CLK = ~CLK;
  
/*******************************************************************/
//////////////////////// DUT Instantiation //////////////////////////
/*******************************************************************/

  ALU DUT ( 
    .CLK        (CLK)          ,
    .RST        (RST)          ,
    .Enable     (Enable)       ,
    .A          (A)            ,
    .B          (B)            ,
    .ALU_FUN    (ALU_FUN)      ,
    .ALU_OUT    (ALU_OUT)      ,
    .OUT_VALID  (OUT_VALID)    );
  
endmodule