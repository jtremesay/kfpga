module MultiplexerLUT(
    input [15:0] data_in,
    output data_out,
    input [3:0] config_in
);
    // Dispatch the config 
    wire [3:0] c_selector = config_in[3:0];

    // Synthesizer is probably better than me to infer the best mux
    assign data_out = config_in < 16 ? data_in[c_selector] : 0;
endmodule