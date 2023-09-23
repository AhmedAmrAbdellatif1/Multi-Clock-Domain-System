module deserializer #(
  parameter WIDTH     = 8 )
  ( 
    input   wire                  clk             ,   
    input   wire                  rst             ,
    input   wire                  enable          ,
    input   wire                  sampled_bit     ,
    input   wire                  success         , 
    output  reg                   data_valid      ,
    output  reg   [WIDTH-1:0]     sampled_stream  ,
    output  reg   [WIDTH-1:0]     parallel_data   );
    
    // shifter and counter always block
    always @(posedge clk, negedge rst)
    begin
      if(!rst)
        begin
          sampled_stream <= 'b0;
        end
      else if(enable)
        begin
          sampled_stream <= {sampled_bit,sampled_stream[7:1]};
        end
    end
    
    always @(posedge clk, negedge rst)
    begin
      if(!rst)
        begin      
          parallel_data <= 'b0;
          data_valid    <= 'b0;
        end
      else if(success)
        begin
          parallel_data <= sampled_stream;
          data_valid    <= 'b1;
        end
      else if(!success)
        begin
          data_valid    <= 'b0;
        end
    end
endmodule
