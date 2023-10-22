module LookUpTable(
    input [1:0] data_in,
    output data_out,
    input [3:0] config_in
);
    // Dispatch the config 
    wire [3:0] c_truth_table = config_in[3:0];

    // Implement the LUT with a mux
    MultiplexerLUT lut(
        .data_in(c_truth_table),
        .data_out(data_out),
        .config_in(data_in)
    );
endmodule