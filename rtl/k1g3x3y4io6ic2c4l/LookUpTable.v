module LookUpTable(
    input [3:0] data_in,
    output data_out,
    input [15:0] config_in
);
    // Dispatch the config 
    wire [15:0] c_truth_table = config_in[15:0];

    // Implement the LUT with a mux
    Multiplexer16 lut(
        .data_in(c_truth_table),
        .data_out(data_out),
        .config_in(data_in)
    );
endmodule