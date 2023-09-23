module ASYNC_FIFO #(  parameter DATA_WIDTH = 8, parameter MEM_DEPTH = 8, parameter PTR_WIDTH = ($clog2(MEM_DEPTH)+1)  )
  ( input   wire                      i_Wclk      ,
    input   wire                      i_Wrst_n    ,
    input   wire                      i_Winc      ,
    input   wire                      i_Rclk      ,
    input   wire                      i_Rrst_n    ,
    input   wire                      i_Rinc      ,
    input   wire    [DATA_WIDTH-1:0]  i_Wdata     ,
    output  wire                      o_full      ,
    output  wire    [DATA_WIDTH-1:0]  o_Rdata     ,
    output  wire                      o_empty     );
    
  // internal signal declaration
  wire  [PTR_WIDTH-2:0]  x_waddr        ,   x_raddr;
  wire  [PTR_WIDTH-1:0]  x_wptr         ,   x_rptr;
  wire  [PTR_WIDTH-1:0]  x_wptr_conv    ,   x_rptr_conv;
  wire  [PTR_WIDTH-1:0]  x_wq2_rptr     ,   x_rq2_wptr;
  
  // FIFO memory buffer  
  FIFO_MEM_CNTRL #(  .DATA_WIDTH(DATA_WIDTH), .MEM_DEPTH(MEM_DEPTH), .PTR_WIDTH(PTR_WIDTH) ) U0_FIFO_MEM_CNTRL (
  .W_clk_en   ((!o_full)&i_Winc)    , 
  .W_data     (i_Wdata)             ,
  .W_addr     (x_waddr)             ,
  .W_clk      (i_Wclk)              ,   
  .W_rst      (i_Wrst_n)            ,
  .R_data     (o_Rdata)             ,
  .R_addr     (x_raddr)             );
  
  // FIFO empty and read address generator
  FIFO_RD  #( .PTR_WIDTH(PTR_WIDTH) ) U0_FIFO_RD (
    .CLK          (i_Rclk)         ,
    .RST          (i_Rrst_n)       ,
    .rinc         (i_Rinc)         ,
    .wptr_conv    (x_rq2_wptr)    ,
    .rptr_conv    (x_rptr_conv)    ,
    .rptr         (x_rptr)         ,
    .raddr        (x_raddr)        ,
    .empty        (o_empty)        );
    
  // FIFO full and write address generator
  FIFO_WR  #( .PTR_WIDTH(PTR_WIDTH) ) U0_FIFO_WR (
    .CLK          (i_Wclk)         ,
    .RST          (i_Wrst_n)       ,
    .winc         (i_Winc)         ,
    .wptr_conv    (x_wptr_conv)    ,
    .rptr_conv    (x_wq2_rptr)    ,
    .wptr         (x_wptr)         ,
    .waddr        (x_waddr)        ,
    .full         (o_full)        );
    
  // Write-to-Read Synchronizer
  DF_SYNC #(.BUS_WIDTH(PTR_WIDTH)) U0_DF_SYNC  (
  .CLK    (i_Rclk)      ,
  .RST    (i_Rrst_n)    ,
  .ASYNC  (x_wptr_conv) ,
  .SYNC   (x_rq2_wptr)  );
                        
  // Read-to-Write Synchronizer
  DF_SYNC #(.BUS_WIDTH(PTR_WIDTH)) U1_DF_SYNC   (
  .CLK    (i_Wclk)      ,
  .RST    (i_Wrst_n)    ,
  .ASYNC  (x_rptr_conv) ,
  .SYNC   (x_wq2_rptr)  );

  // Write-PTR Gray Converter
  GRAY_CONV #(.PTR_WIDTH(PTR_WIDTH))  U0_GRAY_CONV  (
  .bit_ptr  (x_wptr)        ,
  .gray_ptr (x_wptr_conv)   );  
  
  // Read-PTR Gray Converter
  GRAY_CONV #(.PTR_WIDTH(PTR_WIDTH))  U1_GRAY_CONV  (
  .bit_ptr  (x_rptr)        ,
  .gray_ptr (x_rptr_conv)   );
 
endmodule
