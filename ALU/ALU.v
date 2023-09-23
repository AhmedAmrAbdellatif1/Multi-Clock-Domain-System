
module ALU  #( parameter  OPRND_WIDTH = 8, OUT_WIDTH = 2 * OPRND_WIDTH, CTRL_WIDTH = 4)
  ( input   wire                     CLK          ,   // Clock Signal
    input   wire                     RST          ,   // Active Low Reset
    input   wire                     Enable       ,   // ALU Enable
    input   wire  [OPRND_WIDTH-1:0]  A            ,   // Operand A
    input   wire  [OPRND_WIDTH-1:0]  B            ,   // Operand B
    input   wire  [ CTRL_WIDTH-1:0]  ALU_FUN      ,   // ALU Function
    output  reg   [  OUT_WIDTH-1:0]  ALU_OUT      ,   // ALU Result
    output  reg                      OUT_VALID    );  // ALU Result Valid
  
  // calculated result
  reg [OUT_WIDTH-1:0] ALU_RESULT;
  
  // combinational always block implementing gate-level ALU
  always @(*)
  begin
    if(Enable)
      case(ALU_FUN)
      // arithmatic cases     
        4'b0000:  ALU_RESULT = A + B;   // adition   
        4'b0001:  ALU_RESULT = A - B;   // subtraction
        4'b0010:  ALU_RESULT = A * B;   // multiplication
        4'b0011:  ALU_RESULT = A / B;   // division

      // logical cases   
        4'b0100:  ALU_RESULT = A & B;     // AND           
        4'b0101:  ALU_RESULT = A | B;     // OR  
        4'b0110:  ALU_RESULT = ~(A & B);  // NAND
        4'b0111:  ALU_RESULT = ~(A | B);  // NOR 

      // comparsion cases  
        4'b1000:  ALU_RESULT = 'b0;
        4'b1001:  ALU_RESULT = (A==B)? 'd1:'d0;
        4'b1010:  ALU_RESULT =  (A>B)? 'd2:'d0;
        4'b1011:  ALU_RESULT =  (A<B)? 'd3:'d0;

      // shift operation cases
        4'b1100:  ALU_RESULT = A>>1;    // shift A right
        4'b1101:  ALU_RESULT = A<<1;    // shift A left
        4'b1110:  ALU_RESULT = B>>1;    // shift B right
        4'b1111:  ALU_RESULT = B<<1;    // shift B left

        default:  ALU_RESULT = 'b0;
      endcase
    else
      ALU_RESULT = 'b0;
  end

  // registering the alu out
  always @(posedge CLK or negedge RST)
  begin
    if(!RST)
      begin
        ALU_OUT   <= 'b0;
        OUT_VALID <= 1'b0;
      end
    else if(Enable)
      begin
        ALU_OUT   <= ALU_RESULT;
        OUT_VALID <= 1'b1;
      end
  end 
endmodule
  