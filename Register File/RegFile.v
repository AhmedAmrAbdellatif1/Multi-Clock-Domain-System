module RegFile #(  parameter BUS_WIDTH = 8, DEPTH = 8, ADDR_WIDTH  = 4, PAR_EN = 1, PAR_TYPE = 0, PRESCALE = 32, DIV_RATIO = 32 )                            
  ( input   wire                    CLK           ,        // Clock Signal
    input   wire                    RST           ,        // Active Low Reset
    input   wire                    WrEn          ,        // Write Enable
    input   wire                    RdEn          ,        // Read Enable
    input   wire  [ADDR_WIDTH-1:0]  Address       ,        // Address bus
    input   wire  [BUS_WIDTH-1 :0]  WrData        ,        // Write Data Bus
    output  wire  [BUS_WIDTH-1 :0]  REG0          ,        // Register at Address 0x0
    output  wire  [BUS_WIDTH-1 :0]  REG1          ,        // Register at Address 0x1
    output  wire  [BUS_WIDTH-1 :0]  REG2          ,        // Register at Address 0x2
    output  wire  [BUS_WIDTH-1 :0]  REG3          ,        // Register at Address 0x3
    output  reg   [BUS_WIDTH-1 :0]  RdData        ,        // Read Data Bus
    output  reg                     RdData_Valid  );       // Read Data Valid
                    
  // Memory declaration
  reg [BUS_WIDTH-1:0] MEM [DEPTH-1:0];
  
  // control loop index
  integer i;
  
  // sequential always block
  always @(posedge CLK or negedge RST)
  begin
      if(!RST)
        begin : MEMORY_CLEARING
          for(i = 0; i < DEPTH; i = i + 1)
          begin
            if(i == 2)
            begin
              MEM[i][0]   <= PAR_EN;
              MEM[i][1]   <= PAR_TYPE;
              MEM[i][7:2] <= PRESCALE;
            end
            else if(i == 3)
              MEM[i][7:0] <= DIV_RATIO;
            else
              MEM[i] <= 'b0;
          end     
          RdData <= 'b0;
          RdData_Valid <= 1'b0;
        end
        
      else if (WrEn && !RdEn)
        begin : WRITING
          MEM[Address] <= WrData;
        end
    
      else if (!WrEn && RdEn)
        begin : READING
          RdData <= MEM[Address];
          RdData_Valid <= 1'b1;
        end
        
     else
       begin : NOT_READING
         RdData_Valid <= 1'b0;
       end
  end
  
  // assign statements
  assign REG0 = MEM['h0];
  assign REG1 = MEM['h1];
  assign REG2 = MEM['h2];
  assign REG3 = MEM['h3]; 

endmodule