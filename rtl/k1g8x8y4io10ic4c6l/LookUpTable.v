module LookUpTable(
    input [5:0] data_in,
    output data_out,
    input [63:0] config_in
);
    // Dispatch the config 
    wire [63:0] c_truth_table = config_in[63:0];

    // Implement the LUT with a mux
    Multiplexer64 lut(
        .data_in(c_truth_table),
        .data_out(data_out),
        .config_in(data_in)
    );
endmodule