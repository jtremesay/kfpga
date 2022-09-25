module MultiplexerLUT(
    input [15:0] data_in,
    output data_out,
    input [3:0] config_in
);
    // Dispatch the config 
    wire [3:0] c_selector = config_in[3:0];

    // Implement a pipelined mux
    // At each stage, we divide the search space by two.

    // First step of the pipeline
    wire [15:0] stage4 = { data_in };
    
    // Build the pipeline
    wire [7:0] stage3 = c_selector[3] ? stage4[15:8] : stage4[7:0];
    wire [3:0] stage2 = c_selector[2] ? stage3[7:4] : stage3[3:0];
    wire [1:0] stage1 = c_selector[1] ? stage2[3:2] : stage2[1:0];
    
    // Final stage
    assign data_out = c_selector[0] ? stage1[1] : stage1[0] ;
endmodule