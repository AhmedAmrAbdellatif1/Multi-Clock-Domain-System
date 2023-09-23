module data_sampling #(
  parameter   MAX_PRESCALE  = 32 ,
              PRSC_WIDTH    = ($clog2(MAX_PRESCALE)+1) )
  ( 
    input   wire                    clk         ,
    input   wire                    rst         ,
    input   wire                    enable      ,
    input   wire                    serial_data ,
    input   wire  [PRSC_WIDTH-1:1]  prescale    ,
    input   wire  [PRSC_WIDTH-2:0]  counter     ,
    output  wire                    sampled_bit );
    
    // internal signals
    reg                     first_sample, second_sample,  third_sample;    // sampled data
    wire  [PRSC_WIDTH-1:0]  sampling_1,   sampling_2,     sampling_3 ;     // sampling time
    
    // sampling always block
    always @(posedge clk, negedge rst)
    begin
      if(!rst)
        begin
          first_sample  <= 1'b0;
          second_sample <= 1'b0;
          third_sample  <= 1'b0;
        end
      else if(enable)
        begin
          case(counter)
            sampling_1: first_sample  <= serial_data;
            sampling_2: second_sample <= serial_data;
            sampling_3: third_sample  <= serial_data;
          endcase
        end
      else
        begin
          first_sample  <= 1'b0;
          second_sample <= 1'b0;
          third_sample  <= 1'b0;
        end
    end
    
    // sampled data using Karnaugh map
    assign sampled_bit =  (second_sample  &  third_sample) |
                          (first_sample   &  third_sample) |
                          (first_sample   &  second_sample);
                          
    // calculate sampling time
    assign  sampling_1 = (prescale)-1'b1;
    assign  sampling_2 = (prescale)     ;
    assign  sampling_3 = (prescale)+1'b1;
    
  endmodule
