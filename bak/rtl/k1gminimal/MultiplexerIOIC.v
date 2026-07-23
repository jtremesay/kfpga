module MultiplexerIOIC(
    input [1:0] data_in,
    output data_out,
    input config_in
);
    // Dispatch the config 
    wire c_selector = config_in;

    // Synthesizer is probably better than me to infer the best mux
    assign data_out = config_in < 2 ? data_in[c_selector] : 0;
endmodule