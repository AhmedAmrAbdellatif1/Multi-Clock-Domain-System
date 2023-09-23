module RST_SYNC #( parameter NUM_STAGES = 2)
  ( input   wire    CLK   ,         // Clock Signal
    input   wire    RST   ,         // Active Low Async Reset
    output  wire    SYNC_RST  );    // Active Low synchronized Reset
    
    // intermediate synchronizer FFs
    reg [NUM_STAGES-1:0]  sync_dff ;
    
    // generate control loop index
    integer i;

    always @(negedge RST or posedge CLK)
    begin
      if(!RST)
        sync_dff <= 'b0;
      else
      begin
        for(i = 0; i < NUM_STAGES; i = i + 1)
        begin
          if(i==0)
            sync_dff[i] <= 1'b1;
        else
            sync_dff[i] <= sync_dff[i-1];
        end
      end
    end
    
    // output
    assign SYNC_RST = sync_dff[NUM_STAGES-1];
    
endmodule
