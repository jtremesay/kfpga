module MultiplexerLUT(
    input [63:0] data_in,
    output data_out,
    input [5:0] config_in
);
    // Dispatch the config 
    wire [5:0] c_selector = config_in[5:0];

    // Synthesizer is probably better than me to infer the best mux
    assign data_out = config_in < 64 ? data_in[c_selector] : 0;
endmodule