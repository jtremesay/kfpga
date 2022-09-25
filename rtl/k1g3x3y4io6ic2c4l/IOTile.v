module IOTile(
    input [3:0] data_from_io,
    output [3:0] data_to_io,
    input [5:0] data_from_ic,
    output [5:0] data_to_ic,
    input [23:0] config_in
);
    // Dispatch the config 
    wire [1:0] c_mux_ic0 = config_in[1:0]; 
    wire [1:0] c_mux_ic1 = config_in[3:2]; 
    wire [1:0] c_mux_ic2 = config_in[5:4]; 
    wire [1:0] c_mux_ic3 = config_in[7:6]; 
    wire [1:0] c_mux_ic4 = config_in[9:8]; 
    wire [1:0] c_mux_ic5 = config_in[11:10]; 
    wire [2:0] c_mux_io0 = config_in[14:12]; 
    wire [2:0] c_mux_io1 = config_in[17:15]; 
    wire [2:0] c_mux_io2 = config_in[20:18]; 
    wire [2:0] c_mux_io3 = config_in[23:21];

    // IC
    
    Multiplexer4 mux_ic0(
        .data_in(data_from_io),
        .data_out(data_to_ic[0]),
        .config_in(c_mux_ic0)
    );
    
    Multiplexer4 mux_ic1(
        .data_in(data_from_io),
        .data_out(data_to_ic[1]),
        .config_in(c_mux_ic1)
    );
    
    Multiplexer4 mux_ic2(
        .data_in(data_from_io),
        .data_out(data_to_ic[2]),
        .config_in(c_mux_ic2)
    );
    
    Multiplexer4 mux_ic3(
        .data_in(data_from_io),
        .data_out(data_to_ic[3]),
        .config_in(c_mux_ic3)
    );
    
    Multiplexer4 mux_ic4(
        .data_in(data_from_io),
        .data_out(data_to_ic[4]),
        .config_in(c_mux_ic4)
    );
    
    Multiplexer4 mux_ic5(
        .data_in(data_from_io),
        .data_out(data_to_ic[5]),
        .config_in(c_mux_ic5)
    );
    

    // IO
    
    Multiplexer6 mux_io0(
        .data_in(data_from_ic),
        .data_out(data_to_io[0]),
        .config_in(c_mux_io0)
    );
    
    Multiplexer6 mux_io1(
        .data_in(data_from_ic),
        .data_out(data_to_io[1]),
        .config_in(c_mux_io1)
    );
    
    Multiplexer6 mux_io2(
        .data_in(data_from_ic),
        .data_out(data_to_io[2]),
        .config_in(c_mux_io2)
    );
    
    Multiplexer6 mux_io3(
        .data_in(data_from_ic),
        .data_out(data_to_io[3]),
        .config_in(c_mux_io3)
    );
    

endmodule