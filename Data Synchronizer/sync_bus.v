module sync_bus #( parameter BUS_WIDTH = 8)
  ( input   wire    RST                         ,
    input   wire    CLK                         ,
    input   wire    SEL                         ,
    input   wire    [BUS_WIDTH-1:0]   i_0       ,
    input   wire    [BUS_WIDTH-1:0]   i_1       ,
    output  reg     [BUS_WIDTH-1:0]   sync_bus  );
    
    wire  [BUS_WIDTH-1:0] mux_out;
    
    assign mux_out = SEL? i_1 : i_0;
    
    always @(negedge RST or posedge CLK)
    begin
      if(!RST)
        sync_bus <= 'b0;
      else
        sync_bus <= mux_out;
    end

endmodule