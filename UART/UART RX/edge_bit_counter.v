module edge_bit_counter #(
  parameter MAX_PRESCALE = 32                       ,
            PAR_MAX      = 11                       ,
            PRSC_WIDTH   = ($clog2(MAX_PRESCALE)+1) ,
            FRAME_WIDTH  = ($clog2(PAR_MAX) + 1)    )
  (
  input   wire  clk       ,
  input   wire  rst       ,
  input   wire  enable    ,
  input   wire  parity_en ,
  input   wire  [PRSC_WIDTH-1:0]  prescale  ,
  output  reg   [PRSC_WIDTH-2:0]  edge_cnt  ,
  output  reg   [FRAME_WIDTH-2:0] bit_cnt   ,
  output  wire                    edge_max  );
  
  // counter max value declaration
  wire bit_max;
  
  // edge sampling counter
  always @(posedge clk, negedge rst)
  begin
    if(!rst)
      edge_cnt <= 'b0;
    else if(!enable || (enable && edge_max))
      edge_cnt <= 'b0;
    else
      edge_cnt <= edge_cnt + 1'b1;
  end
  
  // bit counter
  always @(posedge clk, negedge rst)
  begin
    if(!rst)
      bit_cnt <= 'b0;
    else if(!enable || (enable && bit_max && edge_max))
      bit_cnt <= 'b0;
    else if(edge_max)
      bit_cnt <= bit_cnt + 1'b1;
  end    

  // flag assign statement
  assign edge_max       = (edge_cnt == prescale - 1);
  assign bit_max        = (parity_en)? (bit_cnt == 'b1010) : (bit_cnt == 'b1001);

endmodule
