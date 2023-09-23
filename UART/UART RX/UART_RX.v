module UART_RX  #(parameter         WIDTH         = 8  ,
                                    PAR_MAX       = 11 ,  
                                    MAX_PRESCALE  = 32 ,
                                    FRAME_WIDTH   = ($clog2(PAR_MAX) + 1)     ,
                                    PRSC_WIDTH    = ($clog2(MAX_PRESCALE)+1)  )(
                                    
    input   wire                    i_clk             ,
    input   wire                    i_rst_n           ,  
    input   wire  [PRSC_WIDTH-1:0]  i_prescale        ,
    input   wire                    i_serial_data     ,    
    input   wire                    i_parity_enable   ,
    input   wire                    i_parity_type     ,
    output  wire                    o_data_valid      ,
    output  wire                    o_parity_error    ,
    output  wire                    o_stop_error      ,
    output  wire  [WIDTH-1:0]       o_parallel_data   );
    
    // internal signal declaration
    wire  [FRAME_WIDTH-2:0] x_bit_cnt     ;  // from edge_bit_counter to FSM
    wire  [PRSC_WIDTH-2:0]  x_edge_cnt    ;  // from edge_bit_counter to data_sampling
    wire                    x_samp_done   ;  // from edge_bit_counter to FSM
    wire                    x_sampled_bit ;  // from data_sampling to parity_check, start_check, stop_check & deserializer
    //wire                    o_parity_error     ;  // from parity_check to FSM
    //wire                    o_stop_error     ;  // from stop_check to FSM
    wire                    x_strt_glitch ;  // from start_check to FSM
    wire                    x_samp_cnt_en ;  // from FSM to data_sampling & edge_bit_counter
    wire                    x_deser_en    ;  // from FSM to deserializer
    wire                    x_success_sig ;  // from FSM to deserializer
    wire                    x_par_chk_en  ;  // from FSM to parity_check
    wire                    x_strt_chk_en ;  // from FSM to start_check
    wire                    x_stp_chk_en  ;  // from FSM to stop_check
    wire  [WIDTH-1:0]       x_sampled_data;  // from deserializer to parity_check
    
UART_RX_FSM U0_FSM (
  .clk              (i_clk)           ,
  .rst              (i_rst_n)         ,
  .RX_IN            (i_serial_data)   ,
  .bit_cnt          (x_bit_cnt)       ,
  .done_sampling    (x_samp_done)     ,
  .par_en           (i_parity_enable) ,
  .par_err          (o_parity_error)       ,
  .start_glitch     (x_strt_glitch)   ,
  .stop_err         (o_stop_error)       ,
  .par_check_en     (x_par_chk_en)    ,
  .start_check_en   (x_strt_chk_en)   ,
  .stop_check_en    (x_stp_chk_en)    ,
  .samp_cnt_en      (x_samp_cnt_en)   ,
  .deser_en         (x_deser_en)      ,
  .data_valid       (x_success_sig)   );
  
edge_bit_counter  U0_edge_bit_counter (
  .clk        (i_clk)           ,
  .rst        (i_rst_n)         ,
  .enable     (x_samp_cnt_en)   ,
  .prescale   (i_prescale)      ,
  .parity_en  (i_parity_enable) ,
  .bit_cnt    (x_bit_cnt)       ,
  .edge_max   (x_samp_done)     ,
  .edge_cnt   (x_edge_cnt)      );
  
data_sampling U0_data_sampling (
  .clk          (i_clk)           ,
  .rst          (i_rst_n)         ,
  .serial_data  (i_serial_data)   ,
  .counter      (x_edge_cnt)      ,
  .enable       (x_samp_cnt_en)   ,
  .sampled_bit  (x_sampled_bit)   ,
  .prescale     (i_prescale[PRSC_WIDTH-1:1]));
  
  
deserializer U0_deserializer (
  .clk            (i_clk)           ,
  .rst            (i_rst_n)         ,
  .sampled_bit    (x_sampled_bit)   ,
  .enable         (x_deser_en)      ,
  .success        (x_success_sig)   ,
  .data_valid     (o_data_valid)    ,
  .sampled_stream (x_sampled_data)  ,
  .parallel_data  (o_parallel_data) );
  
  
start_check U0_start_check (
  .enable             (x_strt_chk_en) ,
  .sampled_start_bit  (x_sampled_bit) ,
  .glitch             (x_strt_glitch) );
  
stop_check  U0_stop_check (
  .enable             (x_stp_chk_en)  ,
  .sampled_stop_bit   (x_sampled_bit) ,
  .error              (o_stop_error)     );
  
parity_check U0_parity_check  (
  .data     (x_sampled_data)  ,
  .par_type (i_parity_type)   ,
  .par_bit  (x_sampled_bit)   ,
  .enable   (x_par_chk_en)    ,
  .error    (o_parity_error)       );
    
    
endmodule
