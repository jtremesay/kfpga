module Multiplexer4(
    input [3:0] data_in,
    output data_out,
    input [1:0] config_in
);
    // Dispatch the config 
    wire [1:0] c_selector = config_in[1:0];

    // Implement a pipelined mux
    // At each stage, we divide the search space by two.

    // First step of the pipeline
    wire [3:0] stage2 = { data_in };
    
    // Build the pipeline
    wire [1:0] stage1 = c_selector[1] ? stage2[3:2] : stage2[1:0];
    
    // Final stage
    assign data_out = c_selector[0] ? stage1[1] : stage1[0] ;
endmodule