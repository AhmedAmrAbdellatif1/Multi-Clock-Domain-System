module parity_calc #( parameter WIDTH = 8 )
                    ( input  wire  [WIDTH-1:0] P_DATA,
                      input  wire              PAR_TYP,
                      input  wire              CLK,
                      input  wire              RST,
                      input  wire              PAR_EN,
                      input  wire              Data_Valid,
                      output reg               par_bit     );
                       
  reg [WIDTH-1:0] data;

  localparam  EVEN = 1'b0;
  localparam  ODD  = 1'b1;        

  always @(posedge CLK, negedge RST)
  begin
    if(!RST)
      data <= 'b0;
    else if(Data_Valid)
      data <= P_DATA;
  end 
  
  always @(*)
  begin
    if(PAR_EN)
        par_bit = (PAR_TYP)? ~^data : ^data;
    else
        par_bit = 1'b0;
  end
  
  
  /*always @(posedge CLK, negedge RST)
  begin
    if(!RST)
      begin
        data <= 'b0;
        par_bit <= 1'b0;
      end
    else if(PAR_EN)
      begin
        par_bit <= (PAR_TYP)? ~^data :  ^data;
      end
    else
      data <= P_DATA;
  end     */
  
endmodule 
