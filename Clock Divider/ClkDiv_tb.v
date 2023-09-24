`timescale 1ns/1ns

module ClkDiv_tb ();

/*******************************************/
/*************** PARAMETERS ****************/
/*******************************************/
  parameter MAX_RATIO   = 10;
  parameter RATIO_BIT   = ($clog2(MAX_RATIO)+1);
  parameter CLK_PERIOD  = 10;
  parameter HALF_PERIOD = 5;
  parameter HIGH        = 1;
  parameter LOW         = 0;

/*******************************************************/
/*************** TB SIGNAL DECLARATIONS ****************/
/*******************************************************/
  reg  [RATIO_BIT-1:0] DIV_RATIO;
  reg  CLK;
  reg  RST;
  reg  ENABLE;
  wire CLK_OUT;
  wire CLK_NEG;
  
  integer i;
  
  assign CLK_NEG = ~CLK_OUT;
  
/**********************************************/
/*************** INITIAL BLOCK ****************/
/**********************************************/
  initial
  begin
    $dumpfile("ClkDiv.vcd");
    $dumpvars;
    initialize;
    reset;
    
    repeat(MAX_RATIO)
    begin
      divide_by(i);
      i = i + 1;
    end
    
    #(5*CLK_PERIOD) $stop;
  end

/**************************************/
/*************** TASKS ****************/
/**************************************/
  
/////////////  
  task reset;
    begin
      RST = LOW;
      #HALF_PERIOD;
      RST = HIGH;
      #HALF_PERIOD;
    end
  endtask

//////////////////
  task initialize;
    begin
      DIV_RATIO = LOW;
      CLK       = LOW;
      ENABLE    = LOW;
      i         = LOW;
    end
  endtask

/////////////////// 
  task divide_by;
    input [RATIO_BIT-1:0] ratio;
    begin
      reset;
      DIV_RATIO = ratio;
      ENABLE    = HIGH;
      #(ratio*CLK_PERIOD);
        calc_period;
      #(ratio*CLK_PERIOD);
      ENABLE    = LOW;
    end
  endtask
/////////////////// 
 task calc_period;
    real period,first,last;
    begin
      first   = 0;
      last    = 0;
      period  = 0;
      if( (DIV_RATIO == 0 || DIV_RATIO == 1) )
        begin
          @(posedge CLK_OUT)
          first = $realtime;
          @(posedge CLK_OUT)
          last = $realtime;
          @(negedge CLK_OUT)
          period = last - first;
          $display("[PASSED]: div ratio = %0d, clock period = %0dns, div clock period = %0dns",DIV_RATIO,CLK_PERIOD,period);
        end

      else
        begin
          wait(CLK_OUT);
          first = $realtime;
          wait(!CLK_OUT);
          wait(CLK_OUT);
          last = $realtime;
          wait(!CLK_OUT);
          period = last - first;
        
          if(period == DIV_RATIO*CLK_PERIOD)
            $display("[PASSED]: div ratio = %0d, clock period = %0dns, div clock period = %0dns",DIV_RATIO,CLK_PERIOD,period);
          else
            $display("[FAILED]: div ratio = %0d",DIV_RATIO);
        end
    end
  endtask
    
/************************************************/
/*************** CLOCK GENERATOR ****************/
/************************************************/
always #HALF_PERIOD CLK = ~CLK;

/**************************************************/
/*************** DUT INSTANTIATION ****************/
/**************************************************/
ClkDiv #(.RATIO_WIDTH(RATIO_BIT)) DUT (  .i_ref_clk(CLK),
              .i_rst_n(RST),
              .i_clk_en(ENABLE),
              .i_div_ratio(DIV_RATIO),
              .o_div_clk(CLK_OUT)       );
endmodule


