module MultiplexerIOIC(
    input [3:0] data_in,
    output data_out,
    input [1:0] config_in
);
    // Dispatch the config 
    wire [1:0] c_selector = config_in[1:0];

    // Synthesizer is probably better than me to infer the best mux
    assign data_out = config_in < 4 ? data_in[c_selector] : 0;
endmodule