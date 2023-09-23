module ClkGate  #(  parameter POST_SYN  = 0) 
  (	input   wire  CLK       ,     // Clock Signal
    input   wire  CLK_EN    ,     // Clock Enable
    output  wire  GATED_CLK	);    // Gated Clock signal    			
  
  // latch enable signal declaration
  reg CLK_EN_LATCHED;
   
   
  // generate block for post-syn design
  generate
    case(POST_SYN)
      1'b0: 
        begin : FOR_SIMULATION
          always @(CLK)
 	          begin
 	            if(!CLK)
 	              CLK_EN_LATCHED <= CLK_EN;
 	          end
 	        assign GATED_CLK = CLK & CLK_EN_LATCHED;
 	      end
 	      
 	    1'b1: 
        begin : FOR_SYN
          TLATNCAX6M  U0_CLK_GATE_CELL (
            .CK   (CLK)         ,
            .E    (CLK_EN)      ,
            .ECK  (GATED_CLK)   );
 	      end
 	  endcase
 	endgenerate
endmodule