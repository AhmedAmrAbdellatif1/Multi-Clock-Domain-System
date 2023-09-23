//******************************************************************************************//
//  Description:                                                                            //
//  ------------                                                                            //
//  It's the FIFO memory buffer that is accessed by both the write and read clock domains.  //
//  This buffer is most likely a synchronous dual-port RAM or register file                 //
//                                                                                          //
//******************************************************************************************//
  
module FIFO_MEM_CNTRL #(  parameter DATA_WIDTH = 8, parameter MEM_DEPTH = 8, parameter PTR_WIDTH = ($clog2(MEM_DEPTH)+1)  )
  ( input   wire  [DATA_WIDTH-1:0]  W_data    ,
    input   wire                    W_clk_en  ,
    input   wire  [PTR_WIDTH-2:0]   W_addr    ,
    input   wire  [PTR_WIDTH-2:0]   R_addr    ,
    input   wire                    W_clk     ,
    input   wire                    W_rst     ,
    output  wire  [DATA_WIDTH-1:0]  R_data    );
    
    // FIFO Memory declaration
    reg [DATA_WIDTH-1:0]  MEM [MEM_DEPTH-1:0];
    
    // control loop index
    integer i;
    
    // write-port memory
    always @(posedge W_clk or negedge W_rst)
    begin
      if(!W_rst)
        begin
          for(i = 0; i < MEM_DEPTH; i = i + 1)
          begin
            MEM[i] <= 'b0;
          end
        end
      else if(W_clk_en)
        MEM[W_addr] <= W_data;
    end
    
    // read-port memory
    assign R_data = MEM[R_addr];
endmodule

