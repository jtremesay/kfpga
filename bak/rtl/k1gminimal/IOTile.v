module IOTile(
    input [1:0] data_from_io,
    output [1:0] data_to_io,
    input [1:0] data_from_ic,
    output [1:0] data_to_ic,
    input [3:0] config_in
);
    // Dispatch the config 
    wire c_mux_ic0 = config_in[0]; 
    wire c_mux_ic1 = config_in[1]; 
    wire c_mux_io0 = config_in[2]; 
    wire c_mux_io1 = config_in[3];

    // IC
    
    MultiplexerIOIC mux_ic0(
        .data_in(data_from_io),
        .data_out(data_to_ic[0]),
        .config_in(c_mux_ic0)
    );
    
    MultiplexerIOIC mux_ic1(
        .data_in(data_from_io),
        .data_out(data_to_ic[1]),
        .config_in(c_mux_ic1)
    );
    

    // IO
    
    MultiplexerIOIO mux_io0(
        .data_in(data_from_ic),
        .data_out(data_to_io[0]),
        .config_in(c_mux_io0)
    );
    
    MultiplexerIOIO mux_io1(
        .data_in(data_from_ic),
        .data_out(data_to_io[1]),
        .config_in(c_mux_io1)
    );
    

endmodule