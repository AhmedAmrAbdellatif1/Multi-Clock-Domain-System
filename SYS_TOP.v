//***************************************************************************************************************//
//	Module: SYS_TOP.Valid
//	Project: Multi Clock Domain System
//  Description: 
//***************************************************************************************************************//

module SYS_TOP #( parameter MEM_DEPTH       = 8   ,     // RegFile and FIFO depth
                  parameter BUS_WIDTH       = 8   ,		   // data bus width
                  parameter ALU_WIDTH       = 16  ,		   // ALU output max width
                  parameter ADDR_WIDTH      = 4   ,		   // address width
                  parameter ALUFN_WIDTH     = 4   ,  		 // ALU func width
                  parameter PAR_EN          = 1   ,     // parity enable
                  parameter PAR_TYPE        = 0   ,     // parity type
                  parameter PRESCALE        = 32  ,     // prescale value
                  parameter DIV_RATIO       = 32  ,     // clock div ratio
									parameter PTR_WIDTH 			   = ($clog2(MEM_DEPTH)+1)	) 	// pointer width    
                  
  ( input   wire    i_ref_clk   		  ,     // reference clock signal 
    input   wire    i_uart_clk  		  ,     // UART clock signal
    input   wire    i_rst_n     		  ,     // Asynchronous active-low reset signal
    input   wire    i_rx_in     		  ,     // input serial data
    output  wire    o_parity_err      ,     // parity bit error
    output  wire    o_stop_err     	  ,     // stop bit error
    output  wire    o_tx_out    	 	  );    // output serial data

/******************************************* Internal Signal Declaration *******************************************/
/********* UART RX OUTPUT SIGNALS *********/
  wire                    x_URX_VLD   	  ;   // Out Data Valid             : connected to DATA_SYNC
  wire  [BUS_WIDTH-1:0]   x_URX_OUT       ;   // Parallel Out Data Bus      : connected to DATA_SYNC
  
/******** DATA _SYNC OUTPUT SIGNALS *******/
  wire  [BUS_WIDTH-1:0]   x_DS_OUT        ;   // Synchronized Data Bus      : connected to SYS_CTRL
  wire                    x_DS_pulse      ;   // Enable Pulse Signal        : connected to SYS_CTRL
  
/******** Sys Ctrl OUTPUT SIGNALS *********/
  wire  [ALUFN_WIDTH-1:0] x_ALU_fun       ;   // ALU Function Signal        : connected to ALU
  wire                    x_ALU_en        ;   // ALU Enable Signal          : connected to ALU
  wire                    x_CG_en         ;   // Clock Gate Enable Signal   : connected to CLK_GATE
  wire  [ADDR_WIDTH-1:0]  x_Reg_addr      ;   // Address Bus                : connected to RegFile
  wire                    x_Reg_WrEn      ;   // Write Enable Signal        : connected to RegFile
  wire                    x_Reg_RdEn      ;   // Read Enable Signal         : connected to RegFile
  wire  [BUS_WIDTH-1:0]   x_Reg_WrData    ;   // Write Data Bus             : connected to RegFile
  wire  [BUS_WIDTH-1:0]   x_UTX_data      ;   // Parallel Data Bus          : connected to UART_TX
  wire                    x_UTX_VLD       ;   // Parallel Data Valid        : connected to UART_TX
  wire                    x_CD_en         ;   // Clock Divider Enable       : connected to ClkDiv
  wire  [BUS_WIDTH-3:0]   x_CD_RX					; 	 // Clock Divider RX ratio		: connected to ClkDiv
	
/*********** ALU OUTPUT SIGNALS ***********/
  wire  [ALU_WIDTH-1:0]   x_ALU_out       ;   // ALU Result                 : connected to SYS_CTRL
  wire                    x_ALU_vld    		;   // Result Valid               : connected to SYS_CTRL

/********* RegFile OUTPUT SIGNALS *********/
  wire  [BUS_WIDTH-1:0]   x_Reg_RdData    ;   // Read Data Bus              : connected to SYS_CTRL
  wire  [BUS_WIDTH-1:0]   x_Reg_REG0      ;   // Register at Address 0x0    : connected to ALU
  wire  [BUS_WIDTH-1:0]   x_Reg_REG1      ;   // Register at Address 0x1    : connected to ALU
  wire  [BUS_WIDTH-1:0]   x_Reg_REG2      ;   // Register at Address 0x2    : connected to UART
  wire  [BUS_WIDTH-1:0]   x_Reg_REG3      ;   // Register at Address 0x3    : connected to ClkDiv
  wire                    x_Reg_RdVld     ;   // Read Data Valid            : connected to SYS_CTRL

/******** ASYNC_FIFO OUTPUT SIGNALS *******/
  wire  [BUS_WIDTH-1:0]   x_FIFO_RData    ;   // Read Data Bus              : connected to UART_TX
  wire                    x_FIFO_EMPTY    ;   // FIFO Buffer empty flag     : connected to UART_TX  
  wire                    x_FIFO_FULL     ;   // FIFO Buffer full flag      : connected to SYS_CTRL

/********** UART TX OUTPUT SIGNALS ********/
  wire                    x_UTX_busy      ;   // UART TX Status Signal      : connected to PULSE_GEN   
  
/********* Pulse Gen OUTPUT SIGNALS *******/
  wire                    x_PG_pulse      ;   // Pulse signal               : connected to ASYNC_FIFO

/********* Clk Gate OUTPUT SIGNALS ********/
  wire                    x_CG_ALUclk     ;   // Gated Clock signal         : connected to ALU 

/********* Clk Div OUTPUT SIGNALS *********/
  wire                    x_UTX_CLK       ;   // Divided Clock Signal       : connected to UART_TX   
  wire                    x_URX_CLK       ;   // Divided Clock Signal       : connected to UART_RX
  
/******** RST_SYNC OUTPUT SIGNALS *********/
  wire                    x_RST_SYNC1     ;   // Active Low synchronized Reset  : connected to ASYNC_FIFO
  wire                    x_RST_SYNC2     ;   // Active Low synchronized Reset  : connected to UART



/********************************************* IP Blocks Instantiation *********************************************/
/********* UART RX instantiation **********/
  UART_RX  #( 
    .WIDTH ( BUS_WIDTH )
    
  )   U0_UART_RX    (
    .i_clk              ( x_URX_CLK )       ,
    .i_rst_n            ( x_RST_SYNC2 )     ,  
    .i_prescale         ( x_Reg_REG2[7:2] ) ,
    .i_serial_data      ( i_rx_in )         ,    
    .i_parity_enable    ( x_Reg_REG2[0] )   ,
    .i_parity_type      ( x_Reg_REG2[1] )   ,
		.o_parity_error			  ( o_parity_err )  ,
		.o_stop_error       ( o_stop_err )      ,
    .o_data_valid       ( x_URX_VLD )       ,
    .o_parallel_data    ( x_URX_OUT )       );
 
/**** Data Synchronizer instantiation *****/  
  DATA_SYNC #( 
    .BUS_WIDTH ( BUS_WIDTH )
    
  )   U0_DATA_SYNC    (
    .dest_clk         ( i_ref_clk )         ,
    .dest_rst         ( x_RST_SYNC1 )       ,
    .bus_enable       ( x_URX_VLD )         ,    
    .unsync_bus       ( x_URX_OUT )         ,
    .sync_bus         ( x_DS_OUT )          ,
    .enable_pulse     ( x_DS_pulse )        );

/********* Sys Ctrl instantiation *********/ 
  SYS_CTRL #( 
    .ALU_WIDTH ( ALU_WIDTH ),
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .ALUFN_WIDTH ( ALUFN_WIDTH ), 
    .DATA_BUS_WIDTH ( BUS_WIDTH ) 
    
  )   U0_SYS_CTRL   (
    .CLK          ( i_ref_clk )       ,
    .RST          ( x_RST_SYNC1 )     ,
    .ALU_OUT      ( x_ALU_out )       ,
    .OUT_Valid    ( x_ALU_vld )       ,
    .RX_P_Data    ( x_DS_OUT )        ,
    .RX_D_VLD     ( x_DS_pulse )      ,
    .RdData       ( x_Reg_RdData )    ,
    .RdData_Valid ( x_Reg_RdVld )     ,
		.Prescale_RX  ( x_Reg_REG2[7:2])  ,
		.ClkDiv_RX 		 ( x_CD_RX )				,
		.FIFO_FULL		  ( x_FIFO_FULL )   ,
    .ALU_EN       ( x_ALU_en )        ,
    .ALU_FUN      ( x_ALU_fun )       ,
    .CLK_EN       ( x_CG_en )         ,
    .Address      ( x_Reg_addr )      ,
    .WrEn         ( x_Reg_WrEn )      ,
    .RdEn         ( x_Reg_RdEn )      ,
    .WrData       ( x_Reg_WrData )    ,
    .TX_P_Data    ( x_UTX_data )      ,
    .TX_D_VLD     ( x_UTX_VLD )       ,
    .clk_div_en   ( x_CD_en )         );
    
/*********** ALU instantiation ************/ 
  ALU  #(
    .OUT_WIDTH( ALU_WIDTH ),
    .OPRND_WIDTH( BUS_WIDTH ),
    .CTRL_WIDTH( ALUFN_WIDTH )
    
  )   U0_ALU    (
    .CLK          ( x_CG_ALUclk ) ,
    .RST          ( x_RST_SYNC1 ) , 
    .Enable       ( x_ALU_en )    ,     
    .A            ( x_Reg_REG0 )  ,        
    .B            ( x_Reg_REG1 )  ,         
    .ALU_FUN      ( x_ALU_fun )   ,      
    .ALU_OUT      ( x_ALU_out )   ,     
    .OUT_VALID    ( x_ALU_vld )   );

/********** RegFile instantiation **********/
  RegFile #(
    .DEPTH ( MEM_DEPTH ),
		.PAR_EN ( PAR_EN ),
		.PAR_TYPE ( PAR_TYPE ),
		.PRESCALE ( PRESCALE ),
		.DIV_RATIO ( DIV_RATIO),
    .BUS_WIDTH ( BUS_WIDTH ),
    .ADDR_WIDTH  ( ADDR_WIDTH ) 
  
  )  U0_RegFile   (
    .CLK          ( i_ref_clk )     ,
    .RST          ( x_RST_SYNC1 )   ,
    .WrEn         ( x_Reg_WrEn )    ,
    .RdEn         ( x_Reg_RdEn )    ,
    .Address      ( x_Reg_addr )    ,
    .WrData       ( x_Reg_WrData )  ,
    .REG0         ( x_Reg_REG0 )    ,
    .REG1         ( x_Reg_REG1 )    ,
    .REG2         ( x_Reg_REG2 )    ,
    .REG3         ( x_Reg_REG3 )    ,
    .RdData       ( x_Reg_RdData )  ,
    .RdData_Valid ( x_Reg_RdVld )   );
		
/********* ASYNC FIFO instantiation ********/
	ASYNC_FIFO #(
	.DATA_WIDTH ( BUS_WIDTH ),
	.MEM_DEPTH ( MEM_DEPTH ),
	.PTR_WIDTH ( PTR_WIDTH ) 
		
	)	U0_ASYNC_FIFO	(
		.i_Wclk			  ( i_ref_clk )           ,
		.i_Wrst_n		  ( x_RST_SYNC1 )    	    ,
		.i_Winc			  ( x_UTX_VLD )           ,
		.i_Rclk			  ( x_UTX_CLK )           ,
		.i_Rrst_n		  ( x_RST_SYNC2 )    	    ,
		.i_Rinc			  ( x_PG_pulse )          ,
		.i_Wdata		  ( x_UTX_data )     	    ,
		.o_full			  ( x_FIFO_FULL )         ,
		.o_Rdata		  ( x_FIFO_RData )     	  ,
		.o_empty		  ( x_FIFO_EMPTY  )     	);
		
/********* RST SYNC instantiation **********/
	RST_SYNC U0_RST_SYNC (
		.CLK 			  ( i_ref_clk )			 ,
		.RST 			  ( i_rst_n )				 ,
		.SYNC_RST   ( x_RST_SYNC1 ) 	 );

	RST_SYNC U1_RST_SYNC (
		.CLK 			  ( i_uart_clk )		 ,
		.RST 			  ( i_rst_n )				 ,  
		.SYNC_RST   ( x_RST_SYNC2 ) 	 );
		
/********** CLK DIV instantiation **********/
	ClkDiv #(.RATIO_WIDTH ( BUS_WIDTH-2 ))  U0_ClkDiv	( 
		.i_ref_clk 		( i_uart_clk )     	,
		.i_rst_n 			( x_RST_SYNC2 )     ,
		.i_clk_en 		( x_CD_en )      		,
		.i_div_ratio 	( x_CD_RX )   			,
		.o_div_clk 		( x_URX_CLK )     	);

	ClkDiv U1_ClkDiv	( 
		.i_ref_clk 		( i_uart_clk )     	,
		.i_rst_n 		  ( x_RST_SYNC2 )    	,
		.i_clk_en 		( x_CD_en )      		,
		.i_div_ratio 	( x_Reg_REG3 )   		,
		.o_div_clk 		( x_UTX_CLK )     	);

/********* Pulse Gen instantiation *********/    
    PULSE_GEN  U0_PULSE_GEN (
			.CLK				 ( x_UTX_CLK )   	   ,   
      .RST				 ( x_RST_SYNC2 )  	 ,  
      .LVL_SIG		 ( x_UTX_busy )   	 ,  
      .PULSE_SIG	 ( x_PG_pulse ) 		 ; 
  
/********* UART TX instantiation *********/
		UART_TX	U0_UART_TX (
			.CLK				 ( x_UTX_CLK )			   ,
			.RST				 ( x_RST_SYNC2 )	 	   ,
			.P_DATA			 ( x_FIFO_RData )	     ,
			.DATA_VALID	 ( !x_FIFO_EMPTY )	   ,
			.PAR_EN			 ( x_Reg_REG2[0] )	   ,
			.PAR_TYP		 ( x_Reg_REG2[1] )	   ,
			.TX_OUT			 ( o_tx_out )			     ,
			.Busy 			 ( x_UTX_busy )        );
			
/********* Clk Gate instantiation ********/
		ClkGate	U0_ClkGate	(
			.CLK 				 ( i_ref_clk )			,
			.CLK_EN 		 ( x_CG_en )			  ,
			.GATED_CLK 	 ( x_CG_ALUclk )    );
  
endmodule

