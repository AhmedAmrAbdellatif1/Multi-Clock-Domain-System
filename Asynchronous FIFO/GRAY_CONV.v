//******************************************************************************************//
//  Description:                                                                            //
//  ------------                                                                            //
//  It is N-bit Bit-Gray Code Converter                                                     //
//                                                                                          //
//******************************************************************************************//

module GRAY_CONV  #( parameter PTR_WIDTH = 4 )
  ( input   wire  [PTR_WIDTH-1:0]   bit_ptr   ,
    output  reg   [PTR_WIDTH-1:0]   gray_ptr  );
    
  // control loop variable
  integer i;
  
  // conversion always block
  always @(*)
  begin
    for(i = 0; i < PTR_WIDTH-1; i = i + 1)
    begin
      gray_ptr[i] = bit_ptr[i] + bit_ptr[i+1];
    end
    gray_ptr[PTR_WIDTH-1] = bit_ptr[PTR_WIDTH-1];    // the MSB is kept the same
  end
endmodule
