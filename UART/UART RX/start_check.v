module start_check
  ( input   wire  enable,
    input   wire  sampled_start_bit,
    output  reg   glitch            );
    
    always @(*)
    begin
      if(enable && sampled_start_bit)
        glitch = 1'b1;
      else
        glitch = 1'b0;
    end
endmodule

