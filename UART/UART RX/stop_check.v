module stop_check
  ( input   wire  enable,
    input   wire  sampled_stop_bit,
    output  reg   error           );
    
    always @(*)
    begin
      if(enable && !sampled_stop_bit)
        error = 1'b1;
      else
        error = 1'b0;
    end
endmodule

