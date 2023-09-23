//******************************************************************************************//
//  Description:                                                                            //
//  ------------                                                                            //
//  It is responsible for calculation of write address (raddr) and generation of full flag  //
//                                                                                          //
//******************************************************************************************//

module FIFO_WR #( parameter PTR_WIDTH = 4 )
  ( input   wire                      CLK         ,
    input   wire                      RST         ,
    input   wire                      winc        ,
    input   wire    [PTR_WIDTH-1:0]   wptr_conv   ,
    input   wire    [PTR_WIDTH-1:0]   rptr_conv   ,
    output  reg     [PTR_WIDTH-1:0]   wptr        ,
    output  wire    [PTR_WIDTH-2:0]   waddr       ,
    output  reg                       full        );
    
    // full flag declaration
    wire  FULL_FLAG;
    
    // full calculation always block
    always @(posedge CLK or negedge RST)
    begin
      if(!RST)
        full <= 1'b0;
      else if(FULL_FLAG)
        full <= 1'b1;
      else
        full <= 1'b0;
    end
    
    // write address increment always block
    always @(posedge CLK or negedge RST)
    begin
      if(!RST)
        wptr <= 'b0;
      else if(winc)
        wptr <= wptr + 1'b1;
    end

  // the write address is the LSBs of the pointer
  assign waddr = wptr[PTR_WIDTH-2:0];
  
  // empty flag condition
  assign FULL_FLAG =  (rptr_conv[PTR_WIDTH-1]   != wptr_conv[PTR_WIDTH-1]) 
                                                && 
                      (rptr_conv[PTR_WIDTH-2]   != wptr_conv[PTR_WIDTH-2]) 
                                                &&                          
                      (rptr_conv[PTR_WIDTH-3:0] == wptr_conv[PTR_WIDTH-3:0]); //when both pointers, except the MSBs, are equal
endmodule
