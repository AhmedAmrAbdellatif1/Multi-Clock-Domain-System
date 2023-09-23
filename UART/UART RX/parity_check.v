module parity_check #(
  parameter WIDTH = 8,
            EVEN  = 0,
            ODD   = 1)
  ( 
    input   [WIDTH-1:0] data,
    input   wire        par_type,
    input   wire        par_bit,
    input   wire        enable,
    output  reg         error   );
  
    wire  data_xor;
  // calculate parity with the extracted data
  always @(*)
  begin
    if(enable)
      case(par_type)
        EVEN: begin
          if(par_bit == (data_xor))
            error = 1'b0;
          else
            error = 1'b1;
        end
        ODD:  begin
          if(par_bit == (~data_xor))
            error = 1'b0;
          else
            error = 1'b1;
        end
      endcase
    else
      error = 1'b0;
  end
  
  assign data_xor = ^data;
endmodule