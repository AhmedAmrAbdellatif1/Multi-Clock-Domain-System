module UART_RX_FSM #(
  parameter NO_STATES     = 5  ,
            HIGH          = 1  ,
            LOW           = 0  ,
            PAR_MAX       = 11 ,
            STAT_WIDTH    = ($clog2(NO_STATES))   , 
            FRAME_WIDTH   = ($clog2(PAR_MAX) + 1) )
  (
    input   wire                    clk            ,
    input   wire                    rst            ,
    input   wire                    RX_IN          ,
    input   wire                    par_en         ,
    input   wire                    par_err        ,
    input   wire                    start_glitch   ,
    input   wire                    stop_err       ,
    input   wire  [FRAME_WIDTH-2:0] bit_cnt        ,
    input   wire                    done_sampling  ,    
    output  reg                     par_check_en   ,
    output  reg                     start_check_en ,
    output  reg                     stop_check_en  ,
    output  reg                     samp_cnt_en    ,
    output  reg                     deser_en       ,
    output  reg                     data_valid     );
    
    
    // states register declaration
    reg [STAT_WIDTH-1:0]  current_state, next_state;
    
    // registering check_error
    reg check_error;
  
    // states encoding using HOT STATE
    localparam  IDLE        = 'b000;
    localparam  start_bit   = 'b001;
    localparam  serial_data = 'b011;
    localparam  parity_bit  = 'b010;
    localparam  stop_bit    = 'b110; 
    
    // current state sequential logic
    always @(posedge clk, negedge rst)
    begin
      if(!rst)
        current_state <= IDLE;
      else
        current_state <= next_state;
    end
    
    // next state combinational logic
    always @(*)
    begin
      case(current_state)
        IDLE:   begin
          if(!RX_IN)
            next_state = start_bit;
          else
            next_state = IDLE;
        end
        
        start_bit:  begin
          if((bit_cnt == 'b1) && !check_error)
            next_state = serial_data;
          else if((bit_cnt == 'b1) && check_error)
            next_state = IDLE;
          else
            next_state = start_bit;
        end
        
        serial_data:  begin
          if((bit_cnt == 'b1001) && par_en)
            next_state = parity_bit;
          else if((bit_cnt == 'b1001) && !par_en)
            next_state = stop_bit;
          else
            next_state = serial_data;
        end
        
        parity_bit: begin
          if(bit_cnt == 'b1010)
            next_state = stop_bit;
         else
            next_state = parity_bit;
        end
        
        stop_bit: begin
          if( ((bit_cnt == 'b0) && RX_IN) || done_sampling && check_error)
            next_state = IDLE;
          else if((bit_cnt == 'b0) && !RX_IN)
            next_state = start_bit;
          else
            next_state = stop_bit;
        end
		
		default: begin
			next_state = IDLE;
		end
      endcase       
    end
    
    // output combinational logic
    always @(*)
    begin
      case(current_state)
        IDLE:   begin
          if(!RX_IN)
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
          else
            begin
              samp_cnt_en     = LOW;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
        end
        
        start_bit:  begin
          if((bit_cnt == 'b1) && start_glitch)
            begin
              samp_cnt_en     = LOW;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
          else if((bit_cnt == 'b1) && !start_glitch)
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
          else
            begin
              samp_cnt_en     = HIGH;
              start_check_en = (done_sampling)? HIGH:LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
        end
        
        serial_data:  begin
          if((bit_cnt == 'b1001) && par_en)
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
          else if((bit_cnt == 'b1001) && !par_en)
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
          else
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              if(done_sampling)
                deser_en      = HIGH;
              else
                deser_en      = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
        end
        
        parity_bit: begin
          if(bit_cnt == 'b1010)
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
         else
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = (done_sampling)? HIGH:LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end 
        end
        
        stop_bit: begin
          if((bit_cnt == 'b0) && RX_IN)
            begin
              samp_cnt_en     = LOW;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = LOW;
              data_valid      = LOW;
            end
          else
            begin
              samp_cnt_en     = HIGH;
              start_check_en  = LOW;
              deser_en        = LOW;
              par_check_en    = LOW;
              stop_check_en   = (done_sampling)? HIGH:LOW;
              data_valid      = (done_sampling)? ~(check_error):LOW;
            end
        end
		default: begin
            samp_cnt_en     = LOW;
            start_check_en  = LOW;
            deser_en        = LOW;
            par_check_en    = LOW;
            stop_check_en   = LOW;
            data_valid      = LOW;
		end
      endcase
    end
    
    always @(posedge clk, negedge rst)
    begin
      if(!rst)
        check_error <= 1'b0;
      else if(stop_err | par_err | start_glitch)
        check_error <= 1'b1;
      else if(next_state == IDLE)
        check_error <= 1'b0;
    end
endmodule