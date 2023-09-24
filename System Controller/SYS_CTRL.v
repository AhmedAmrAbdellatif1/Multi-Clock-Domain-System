module SYS_CTRL #(  parameter ALU_WIDTH = 16, ADDR_WIDTH = 4, DATA_BUS_WIDTH = 8, ALUFN_WIDTH = 4, NO_STATES = 12, STATE_WIDTH = $clog2(NO_STATES))
  
  ( input   wire                        CLK             ,     // Clock Signal
    input   wire                        RST             ,     // Active Low Reset
    input   wire  [ALU_WIDTH-1:0]       ALU_OUT         ,     // ALU Result
    input   wire                        OUT_Valid       ,     // ALU Result Valid
    input   wire  [DATA_BUS_WIDTH-1:0]  RX_P_Data       ,     // UART_RX Data
    input   wire                        RX_D_VLD        ,     // RX Data Valid
    input   wire  [DATA_BUS_WIDTH-1:0]  RdData          ,     // Read Data Bus
    input   wire                        RdData_Valid    ,     // Read Data Valid
		input		 wire  [DATA_BUS_WIDTH-3:0]	 Prescale_RX			  ,			  // config prescale values
		input		 wire												        FIFO_FULL				   ,			  // FIFO full flag
		output	 reg		[DATA_BUS_WIDTH-3:0]	  ClkDiv_RX				   ,			  // Clock Divider Ratio for RX
    output  reg                         ALU_EN          ,     // ALU Enable signal
    output  reg   [ALUFN_WIDTH-1:0]     ALU_FUN         ,     // ALU Function signal
    output  reg                         CLK_EN          ,     // Clock gate enable
    output  reg   [ADDR_WIDTH-1:0]      Address					    ,     // Address bus
    output  reg                         WrEn            ,     // Write Enable
    output  reg                         RdEn            ,     // Read Enable
    output  reg   [DATA_BUS_WIDTH-1:0]  WrData          ,     // Write Data Bus
    output  reg   [DATA_BUS_WIDTH-1:0]  TX_P_Data       ,     // UART _TX Data
    output  reg                         TX_D_VLD        ,     // TX Data Valid
    output  wire                        clk_div_en      );    // Clock divider enable

    // states register declaration
    reg [STATE_WIDTH-1:0] current_state, next_state;
    
    // state encoding
    localparam S_IDLE         	 = 'b0000;			// Idle state
    localparam S_REG_WRT_ADRS  	= 'b0001;			// Register File Write command: Frame 1 [Address] 
    localparam S_REG_WRT_DATA  	= 'b0011;			// Register File Write command: Frame 2 [Data]
    localparam S_REG_RD_ADRS	   = 'b0010;			// Register File Read command: [Address]
    localparam S_REG_RD_OUT	 	 	= 'b0110;			// Register File Passing Data to output
		localparam S_ALU_IN_A				   =	'b0111;			// ALU Operation with OPERAND command: Frame 1 [Operand A]
		localparam S_ALU_IN_B				   =	'b0101;			// ALU Operation with OPERAND command: Frame 2 [Operand B]
		localparam S_ALU_FUN			 	   =	'b0100;			// ALU Operation with OPERAND command: Frame 3 [ALU Func]
		localparam S_ALU_OUT_LSB		  =	'b1100;			// ALU Operation with OPERAND command: Pass the output outside LSB
		localparam S_ALU_OUT_MSB		  =	'b1101;			// ALU Operation with OPERAND command: Pass the output outside MSB
    
    // commands encoding
    localparam REG_WR_CMD  = 'hAA;
    localparam REG_RD_CMD  = 'hBB;
    localparam ALU_OP_CMD  = 'hCC;
    localparam ALU_NOP_CMD = 'hDD;
		
		// registers
		reg	[ADDR_WIDTH-1:0]	addr_reg;
		reg	[ALUFN_WIDTH-1:0]	ALUFN_reg;
		
		// conditions
		wire CHANGE_ADDR,CHANGE_FUNC;
		
    
    /****************************************** *******************************************/
    // current state sequential always
    always @(posedge CLK or negedge RST)
    begin
      if(!RST)
        current_state <= S_IDLE;
      else
        current_state <= next_state;
    end
    
    // next state & output logic
    always @(*)
    begin
      case(current_state)
				// idle state
        S_IDLE: begin
       		ALU_EN 			  = 1'b0;
					ALU_FUN 		 =  'b1000;
					CLK_EN 			 = 1'b0;
					Address 		 = addr_reg;
					WrEn 				  = 1'b0;
					RdEn 				  = 1'b0;
					WrData 			 =  'b0;
					TX_P_Data 	=  'hFF;
					TX_D_VLD 		= 1'b0;
					
          if(RX_D_VLD)
            case(RX_P_Data)
              REG_WR_CMD:	begin
								ALU_EN = 1'b0;
								CLK_EN = 1'b0;
								next_state = S_REG_WRT_ADRS;
							end
							
							REG_RD_CMD:	begin
								ALU_EN = 1'b0;
								CLK_EN = 1'b0;
								next_state = S_REG_RD_ADRS;
							end 	
              ALU_OP_CMD:	begin
								ALU_EN = 1'b1;
								CLK_EN = 1'b1;
								next_state = S_ALU_IN_A;
							end 	
              ALU_NOP_CMD:	begin
								ALU_EN = 1'b1;
								CLK_EN = 1'b1;
								next_state = S_ALU_FUN;
							end 	
              default: next_state = S_IDLE;
            endcase
          else
            next_state = S_IDLE;
        end

				
				// Reg Write frame 1: Address Frame
        S_REG_WRT_ADRS:  begin
					ALU_EN 			 = 1'b0;
					ALU_FUN 		 =  'b1000;
					CLK_EN 			 = 1'b0;
					WrEn 			 	 = 1'b0;
					RdEn 				  = 1'b0;
					WrData 			 =  'b0;
					TX_P_Data 	=  'b0;
					TX_D_VLD 		= 1'b0;
          if(RX_D_VLD)
            begin
              Address = addr_reg;
							next_state = S_REG_WRT_DATA;
            end
          else
            begin
              Address = addr_reg;
							next_state = S_REG_WRT_ADRS;
            end
        end
				
				// Reg Write frame 2: Data Frame
        S_REG_WRT_DATA:  begin
					ALU_EN 			 = 1'b0;
					ALU_FUN 		 =  'b1000;
					CLK_EN 			 = 1'b0;
					Address 		 = addr_reg;
					WrData 			 =  'b0;
					TX_P_Data 	=  'b0;
					TX_D_VLD 		= 1'b0;
					
          if(RX_D_VLD)
            begin
							WrEn = 1'b1;
              RdEn = 1'b0;
              WrData = RX_P_Data;
							next_state = S_IDLE;
            end
          else
            begin
							WrEn = 1'b0;
              RdEn = 1'b0;
              WrData = 'b0;
							next_state = S_REG_WRT_DATA;
            end
        end
				
				// Reg Read address
				S_REG_RD_ADRS:  begin
					ALU_EN 			= 1'b0;
					ALU_FUN 		= 'b1000;
					CLK_EN 			= 1'b0;
					WrEn 				= 1'b0;
					RdEn 				= 1'b0;
					WrData 			= 'b0;
					TX_P_Data 	= 'b0;
					TX_D_VLD 		= 1'b0;
					
          if(RX_D_VLD)
            begin
							Address = addr_reg;
							next_state = S_REG_RD_OUT;
            end
          else
						begin
							Address = addr_reg;
							next_state = S_REG_RD_ADRS;
						end    
        end
				
				// Passing read data
				S_REG_RD_OUT:	begin
					ALU_EN 	= 1'b0;
					ALU_FUN = 'b1000;
					CLK_EN 	= 1'b0;
					Address = addr_reg;
					WrData 	= 'b0;
					WrEn 		=	 1'b0;
          RdEn 		= 1'b1;
					
          if(RdData_Valid && !FIFO_FULL)
            begin
               TX_P_Data 	= RdData;
					     TX_D_VLD = 1'b1;
					     next_state = S_IDLE;
            end
          else
            begin
               TX_P_Data 	= 'b0;
					     TX_D_VLD = 1'b0;
					     next_state = S_REG_RD_OUT;
            end
				end
				
			// ALU Operantion with Operand command: Operand A
			S_ALU_IN_A:	begin
				Address 		= 'h0;
				ALU_EN 			= 1'b0;
				ALU_FUN 		= 'b1000;
				CLK_EN 			= 1'b0;
				TX_P_Data 	= 'b0;
				TX_D_VLD 		= 1'b0;
				
				if(RX_D_VLD)
            begin
							WrEn = 1'b1;
							RdEn = 1'b0;
              WrData = RX_P_Data;
							next_state = S_ALU_IN_B;
            end
          else
            begin
							WrEn = 1'b0;
							RdEn = 1'b0;
              WrData = 'b0;
							next_state = S_ALU_IN_A;
						end
				end
				
				// ALU Operantion with Operand command: Operand B
				S_ALU_IN_B:	begin
				Address 		= 'h1;
				ALU_EN 			= 1'b0;
				ALU_FUN 		= 'b1000;
				CLK_EN 			= 1'b0;
				TX_P_Data 	= 'b0;
				TX_D_VLD 		= 1'b0;
				
				if(RX_D_VLD)
            begin
							WrEn = 1'b1;
							RdEn = 1'b0;
              WrData = RX_P_Data;
							next_state = S_ALU_FUN;
            end
          else
						begin
							WrEn = 1'b0;
							RdEn = 1'b0;
              WrData = 'b0;
							next_state = S_ALU_IN_B;
						end
				end
				
			// ALU Operantion with Operand command: ALU FUNC
			S_ALU_FUN:	begin
				ALU_EN 			= 1'b1;
				CLK_EN 			= 1'b1;
				Address 		= addr_reg;
				WrEn 				= 1'b0;
				RdEn 				= 1'b0;
				WrData 			= 'b0;
				TX_P_Data 	= 'b0;
				TX_D_VLD 		= 1'b0;
				WrEn 				= 1'b0;
        RdEn 				= 1'b0;
				
				if(RX_D_VLD)
            begin
              ALU_FUN = RX_P_Data;
							next_state = S_ALU_OUT_LSB;
            end
          else
						begin
						  ALU_FUN = 'b1000;
							next_state = S_ALU_FUN;
						end
				end
				
			// Passing the ALU result
			S_ALU_OUT_LSB:	begin
				ALU_EN 			= 1'b1;
				CLK_EN 			= 1'b1;
				ALU_FUN  		= ALUFN_reg;
				Address 		= addr_reg;
				WrEn 				= 1'b0;
				RdEn 				= 1'b0;
				WrData 			= 'b0;
				WrEn 				= 1'b0;
        RdEn 				= 1'b0;
					
				if(OUT_Valid && !FIFO_FULL)
					begin
						 
						 TX_P_Data = ALU_OUT[DATA_BUS_WIDTH-1:0];
						 TX_D_VLD = 1'b1;
						 next_state = S_ALU_OUT_MSB;
					end
				else
					begin
						TX_P_Data = 'b0;
						TX_D_VLD = 1'b0;
						next_state = S_ALU_OUT_LSB;
					end
			end
				
			// Passing the ALU result
			S_ALU_OUT_MSB:	begin
				ALU_EN 			= 1'b1;
				CLK_EN 			= 1'b1;
				Address 		= addr_reg;
				WrEn 				= 1'b0;
				RdEn 				= 1'b0;
				WrData 			= 'b0;
				WrEn 				= 1'b0;
        RdEn 				= 1'b0;
				
				if(OUT_Valid && !FIFO_FULL)
					begin
						 TX_P_Data = ALU_OUT[2*DATA_BUS_WIDTH-1:DATA_BUS_WIDTH];
						 TX_D_VLD = 1'b1;
						 ALU_FUN  = 'b1000;
						 next_state = S_IDLE;
					end
				else
					begin
						TX_P_Data = 'b0;
						TX_D_VLD = 1'b0;
						ALU_FUN  = ALUFN_reg;
						next_state = S_ALU_OUT_MSB;
					end
			end
				
        default: begin
       		ALU_EN 			  = 1'b0;
					ALU_FUN 		 =  'b1000;
					CLK_EN 			 = 1'b0;
					Address 		 = addr_reg;
					WrEn 				  = 1'b0;
					RdEn 				  = 1'b0;
					WrData 			 =  'b0;
					TX_P_Data 	=  'b0;
					TX_D_VLD 		= 1'b0;
					next_state = S_IDLE;
				end
      endcase
    end
		
		
		
		// registering the addr_reg
		always @(posedge CLK or negedge RST)
		begin
			if(!RST)
				addr_reg <= 'b0;
			else if(CHANGE_ADDR)
				addr_reg <= RX_P_Data; 
		end
		
		// registering the ALU func
		always @(posedge CLK or negedge RST)
		begin
			if(!RST)
				ALUFN_reg <= 'b1000;
			else if(CHANGE_FUNC)
				ALUFN_reg <= RX_P_Data; 
		end		
		
		// Configuring ClkDiv RX Ratio
		always @(*)
		begin
			case(Prescale_RX)
				'd8:   	  ClkDiv_RX = 'd4;
				'd16:		   ClkDiv_RX =	'd2;
				'd32:		   ClkDiv_RX = 'd1;
				default:  ClkDiv_RX = 'd1;
			endcase
		end	
		
		// change address conditions
		assign CHANGE_ADDR = ( (current_state == S_REG_WRT_ADRS) ||
													 (current_state == S_REG_RD_ADRS)  );

													 // change address conditions
		assign CHANGE_FUNC = ( (current_state == S_ALU_FUN) );
 
    // clock divider is always active
    assign clk_div_en = 1'b1;
endmodule