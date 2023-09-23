module DF_SYNC #( parameter BUS_WIDTH = 4, NUM_STAGES = 2)
  ( input   wire                  CLK   ,
    input   wire                  RST   ,
    input   wire  [BUS_WIDTH-1:0] ASYNC ,
    output  wire  [BUS_WIDTH-1:0] SYNC  );
    
    // intermediate synchronizer FFs
    reg [BUS_WIDTH-1:0] sync_dff [NUM_STAGES-1:0];
    
    // control loop index
    integer i;
    
    always @(negedge RST or posedge CLK)
    begin
        if(!RST)
          for(i = 0; i < NUM_STAGES; i = i + 1)
            sync_dff[i] <= 'b0;
        else
          begin
            for(i = 0; i < NUM_STAGES; i = i + 1)
            begin
              if(i == 0)
                sync_dff[i] <= ASYNC;
              else
                sync_dff[i] <= sync_dff[i-1];
            end
          end
    end
    
    // output
    assign SYNC = sync_dff[NUM_STAGES-1];
endmodule



