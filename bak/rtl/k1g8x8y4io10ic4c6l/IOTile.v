module IOTile(
    input [3:0] data_from_io,
    output [3:0] data_to_io,
    input [9:0] data_from_ic,
    output [9:0] data_to_ic,
    input [35:0] config_in
);
    // Dispatch the config 
    wire [1:0] c_mux_ic0 = config_in[1:0]; 
    wire [1:0] c_mux_ic1 = config_in[3:2]; 
    wire [1:0] c_mux_ic2 = config_in[5:4]; 
    wire [1:0] c_mux_ic3 = config_in[7:6]; 
    wire [1:0] c_mux_ic4 = config_in[9:8]; 
    wire [1:0] c_mux_ic5 = config_in[11:10]; 
    wire [1:0] c_mux_ic6 = config_in[13:12]; 
    wire [1:0] c_mux_ic7 = config_in[15:14]; 
    wire [1:0] c_mux_ic8 = config_in[17:16]; 
    wire [1:0] c_mux_ic9 = config_in[19:18]; 
    wire [3:0] c_mux_io0 = config_in[23:20]; 
    wire [3:0] c_mux_io1 = config_in[27:24]; 
    wire [3:0] c_mux_io2 = config_in[31:28]; 
    wire [3:0] c_mux_io3 = config_in[35:32];

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
    
    MultiplexerIOIC mux_ic2(
        .data_in(data_from_io),
        .data_out(data_to_ic[2]),
        .config_in(c_mux_ic2)
    );
    
    MultiplexerIOIC mux_ic3(
        .data_in(data_from_io),
        .data_out(data_to_ic[3]),
        .config_in(c_mux_ic3)
    );
    
    MultiplexerIOIC mux_ic4(
        .data_in(data_from_io),
        .data_out(data_to_ic[4]),
        .config_in(c_mux_ic4)
    );
    
    MultiplexerIOIC mux_ic5(
        .data_in(data_from_io),
        .data_out(data_to_ic[5]),
        .config_in(c_mux_ic5)
    );
    
    MultiplexerIOIC mux_ic6(
        .data_in(data_from_io),
        .data_out(data_to_ic[6]),
        .config_in(c_mux_ic6)
    );
    
    MultiplexerIOIC mux_ic7(
        .data_in(data_from_io),
        .data_out(data_to_ic[7]),
        .config_in(c_mux_ic7)
    );
    
    MultiplexerIOIC mux_ic8(
        .data_in(data_from_io),
        .data_out(data_to_ic[8]),
        .config_in(c_mux_ic8)
    );
    
    MultiplexerIOIC mux_ic9(
        .data_in(data_from_io),
        .data_out(data_to_ic[9]),
        .config_in(c_mux_ic9)
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
    
    MultiplexerIOIO mux_io2(
        .data_in(data_from_ic),
        .data_out(data_to_io[2]),
        .config_in(c_mux_io2)
    );
    
    MultiplexerIOIO mux_io3(
        .data_in(data_from_ic),
        .data_out(data_to_io[3]),
        .config_in(c_mux_io3)
    );
    

endmodule