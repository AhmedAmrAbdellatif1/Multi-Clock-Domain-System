module DATA_SYNC #( parameter BUS_WIDTH = 8, NUM_STAGES = 2)
  ( input   wire                    dest_clk      ,
    input   wire                    dest_rst      ,
    input   wire                    bus_enable    ,    
    input   wire  [BUS_WIDTH-1:0]   unsync_bus    ,
    output  wire  [BUS_WIDTH-1:0]   sync_bus      ,
    output  wire                    enable_pulse  );
    
    // internal signal declaration
    wire  x_sync_bus_enable;
    wire  x_pulse_sel;
    
  multi_ff U0_multi_ff  (
    .CLK     (dest_clk)           ,
    .RST     (dest_rst)           ,
    .ASYNC   (bus_enable)         ,
    .SYNC    (x_sync_bus_enable)  ); 
    
    
  DS_PULSE U0_DS_PULSE  (
    .CLK                  (dest_clk)             ,
    .RST                  (dest_rst)             ,
    .bus_enable           (x_sync_bus_enable) ,
    .pulse                (x_pulse_sel)       ,
    .enable_pulse         (enable_pulse)    );
    
  sync_bus U0_sync_bus  (
    .CLK        (dest_clk)         ,
    .RST        (dest_rst)         ,
    .SEL        (x_pulse_sel)   ,
    .i_0        (sync_bus)    ,
    .i_1        (unsync_bus)  ,
    .sync_bus   (sync_bus)    );
    
    
  endmodule
