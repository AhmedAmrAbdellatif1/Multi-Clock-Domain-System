module FSM #( parameter WIDTH = 8 )
            ( input   wire          Data_Valid,
              input   wire          PAR_EN,
              input   wire          ser_done,
              input   wire          CLK,
              input   wire          RST,
              output  reg           ser_en,
              output  reg           busy,
              output  reg   [1:0]   mux_sel     );

  // FSM States Registers
  reg [2:0] current_state, next_state;
  
  // state encoding
  localparam  IDLE        = 3'b000;
  localparam  start_bit   = 3'b001;
  localparam  ser_data    = 3'b010;
  localparam  parity_bit  = 3'b011;
  localparam  stop_bit    = 3'b100;
  
  // mux selector encoding
  localparam  mux_start   = 2'b00;
  localparam  mux_serial  = 2'b01;
  localparam  mux_parity  = 2'b10;
  localparam  mux_stop    = 2'b11;
  
  // state transition always block
  always @(posedge CLK, negedge RST)
  begin
    if(!RST)
      current_state <= IDLE;
    else
      current_state <= next_state;
  end
  
  // next state logic always block
  always @(*)
  begin
    case(current_state)
      IDLE:       begin
        if(Data_Valid)
          next_state  = start_bit;
        else
          next_state  = IDLE;
      end
      start_bit:  begin
          next_state  = ser_data;
      end
      ser_data:   begin
        if(ser_done)
          begin
            if(PAR_EN)
              next_state  = parity_bit;
            else
              next_state  = stop_bit;
          end
        else
          next_state  = ser_data;
      end
      parity_bit: begin
          next_state  = stop_bit;
      end
      stop_bit:   begin
     // This condition allows the UART TX to receive two successive bytes or more without returning to IDLE    
       /*if(Data_Valid):
          next_state  = start_bit;
        else*/
          next_state  = IDLE;
      end
      default     begin
        next_state = IDLE;
      end
    endcase
  end
  
  // output logic always block
  always @(*)
  begin
    case(current_state)
      IDLE:       begin
        busy    = 1'b0;
        ser_en  = 1'b0;
        mux_sel = mux_stop;
      end
      start_bit:  begin
        busy    = 1'b1;
        ser_en  = 1'b1;
        mux_sel = mux_start;
      end
      ser_data:   begin
        busy    = 1'b1;
        ser_en  = 1'b1;
        mux_sel = mux_serial;
      end
      parity_bit: begin
        busy    = 1'b1;
        ser_en  = 1'b0;
        mux_sel = mux_parity;
      end
      stop_bit:   begin
        busy    = 1'b1;
        ser_en  = 1'b0;
        mux_sel = mux_stop;
      end
      default     begin
        busy    = 1'b0;
        ser_en  = 1'b0;
        mux_sel = mux_stop;
      end
    endcase
  end    
endmodule
