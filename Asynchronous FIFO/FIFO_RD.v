//******************************************************************************************//
//  Description:                                                                            //
//  ------------                                                                            //
//  It is responsible for calculation of read address (raddr) and generation of empty flag  //
//                                                                                          //
//******************************************************************************************//

module FIFO_RD  #( parameter PTR_WIDTH = 4 )
  ( input   wire                      CLK         ,
    input   wire                      RST         ,
    input   wire                      rinc        ,
    input   wire    [PTR_WIDTH-1:0]   wptr_conv   ,
    input   wire    [PTR_WIDTH-1:0]   rptr_conv   ,
    output  reg     [PTR_WIDTH-1:0]   rptr        ,
    output  wire    [PTR_WIDTH-2:0]   raddr       ,
    output  reg                       empty       );
    
    // empty flag declaration
    wire  EMPTY_FLAG;
    
    // empty calculation always block
    always @(posedge CLK or negedge RST)
    begin
      if(!RST)
        empty <= 1'b1;
      else if(EMPTY_FLAG)
        empty <= 1'b1;
      else
        empty <= 1'b0;
    end
    
    // read address increment always block
    always @(posedge CLK or negedge RST)
    begin
      if(!RST)
        rptr <= 'b0;
      else if(!empty && rinc)
        rptr <= rptr + 1'b1;
    end

  // the read address is the LSBs of the pointer
  assign raddr = rptr[PTR_WIDTH-2:0];
  
  // empty flag condition
  assign EMPTY_FLAG = (rptr_conv == wptr_conv); //when both pointers, including the MSBs are equal
endmodule
