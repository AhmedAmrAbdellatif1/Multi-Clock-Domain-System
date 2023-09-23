module UART_TX #( parameter WIDTH = 8 )
                ( input   wire    [WIDTH-1:0] P_DATA,
                  input   wire                DATA_VALID,
                  input   wire                PAR_EN,
                  input   wire                PAR_TYP,
                  input   wire                CLK,
                  input   wire                RST,
                  output  wire                TX_OUT,
                  output  wire                Busy      );
                  
  // internal signals declaration
  wire  ser_done;
  wire  ser_data;
  wire  ser_en;
  wire  par_bit;
  wire  [1:0] mux_sel;
  
  
  // module instantiations
  serializer  U0_serializer  ( .P_DATA(P_DATA),
                               .ser_en(ser_en),
                               .CLK(CLK),
                               .RST(RST),
                               .ser_data(ser_data),
                               .ser_done(ser_done)       );
                  
  FSM         U0_FSM         ( .Data_Valid(DATA_VALID),
                               .PAR_EN(PAR_EN),
                               .ser_done(ser_done),
                               .CLK(CLK),
                               .RST(RST),
                               .ser_en(ser_en),
                               .busy(Busy),
                               .mux_sel(mux_sel)     );
               
              
  parity_calc U0_parity_calc  ( .P_DATA(P_DATA),
                                .PAR_TYP(PAR_TYP),
                                .CLK(CLK),
                                .RST(RST),
                                .Data_Valid(!Busy),
                                .PAR_EN(PAR_EN),
                                .par_bit(par_bit)    );
                    
  MUX         U0_MUX          ( .start_bit(1'b0),
                                .stop_bit(1'b1),
                                .ser_data(ser_data),
                                .par_bit(par_bit),
                                .mux_sel(mux_sel),
                            	   .TX_OUT(TX_OUT)       );                                      
endmodule