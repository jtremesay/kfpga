module SwitchBox(
    input [5:0] data_north_in,
    output [5:0] data_north_out,
    input [5:0] data_east_in,
    output [5:0] data_east_out,
    input [5:0] data_south_in,
    output [5:0] data_south_out,
    input [5:0] data_west_in,
    output [5:0] data_west_out,
    input [1:0] data_from_les,
    output [7:0] data_to_les,
    input [111:0] config_in
);
    // Dispatch the config 
    wire [2:0] c_mux_north0 = config_in[2:0]; 
    wire [2:0] c_mux_north1 = config_in[5:3]; 
    wire [2:0] c_mux_north2 = config_in[8:6]; 
    wire [2:0] c_mux_north3 = config_in[11:9]; 
    wire [2:0] c_mux_north4 = config_in[14:12]; 
    wire [2:0] c_mux_north5 = config_in[17:15]; 
    wire [2:0] c_mux_east0 = config_in[20:18]; 
    wire [2:0] c_mux_east1 = config_in[23:21]; 
    wire [2:0] c_mux_east2 = config_in[26:24]; 
    wire [2:0] c_mux_east3 = config_in[29:27]; 
    wire [2:0] c_mux_east4 = config_in[32:30]; 
    wire [2:0] c_mux_east5 = config_in[35:33]; 
    wire [2:0] c_mux_south0 = config_in[38:36]; 
    wire [2:0] c_mux_south1 = config_in[41:39]; 
    wire [2:0] c_mux_south2 = config_in[44:42]; 
    wire [2:0] c_mux_south3 = config_in[47:45]; 
    wire [2:0] c_mux_south4 = config_in[50:48]; 
    wire [2:0] c_mux_south5 = config_in[53:51]; 
    wire [2:0] c_mux_west0 = config_in[56:54]; 
    wire [2:0] c_mux_west1 = config_in[59:57]; 
    wire [2:0] c_mux_west2 = config_in[62:60]; 
    wire [2:0] c_mux_west3 = config_in[65:63]; 
    wire [2:0] c_mux_west4 = config_in[68:66]; 
    wire [2:0] c_mux_west5 = config_in[71:69]; 
    wire [4:0] c_mux_le0_i0 = config_in[76:72]; 
    wire [4:0] c_mux_le0_i1 = config_in[81:77]; 
    wire [4:0] c_mux_le0_i2 = config_in[86:82]; 
    wire [4:0] c_mux_le0_i3 = config_in[91:87]; 
    wire [4:0] c_mux_le1_i0 = config_in[96:92]; 
    wire [4:0] c_mux_le1_i1 = config_in[101:97]; 
    wire [4:0] c_mux_le1_i2 = config_in[106:102]; 
    wire [4:0] c_mux_le1_i3 = config_in[111:107];

    // Use Wilton switchbox
    // https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.4925&rep=rep1&type=pdf
    // 6.1.2: Logic Resources, p103

    // Side north
    MultiplexerSBIC mux_north0(
        .data_in({
            data_west_in[1],
            data_south_in[0], 
            data_east_in[0],
            data_from_les
        }),
        .data_out(data_north_out[0]),
        .config_in(c_mux_north0)
    );
    
    MultiplexerSBIC mux_north1(
        .data_in({
            data_west_in[2],
            data_south_in[1], 
            data_east_in[5],
            data_from_les
        }),
        .data_out(data_north_out[1]),
        .config_in(c_mux_north1)
    );
    
    MultiplexerSBIC mux_north2(
        .data_in({
            data_west_in[3],
            data_south_in[2], 
            data_east_in[4],
            data_from_les
        }),
        .data_out(data_north_out[2]),
        .config_in(c_mux_north2)
    );
    
    MultiplexerSBIC mux_north3(
        .data_in({
            data_west_in[4],
            data_south_in[3], 
            data_east_in[3],
            data_from_les
        }),
        .data_out(data_north_out[3]),
        .config_in(c_mux_north3)
    );
    
    MultiplexerSBIC mux_north4(
        .data_in({
            data_west_in[5],
            data_south_in[4], 
            data_east_in[2],
            data_from_les
        }),
        .data_out(data_north_out[4]),
        .config_in(c_mux_north4)
    );
    
    MultiplexerSBIC mux_north5(
        .data_in({
            data_west_in[0],
            data_south_in[5], 
            data_east_in[1],
            data_from_les
        }),
        .data_out(data_north_out[5]),
        .config_in(c_mux_north5)
    );
    

    // Side east
    MultiplexerSBIC mux_east0(
        .data_in({
            data_north_in[0],
            data_west_in[0],
            data_south_in[1],
            data_from_les
        }),
        .data_out(data_east_out[0]),
        .config_in(c_mux_east0)
    );
    
    MultiplexerSBIC mux_east1(
        .data_in({
            data_north_in[5],
            data_west_in[1],
            data_south_in[2],
            data_from_les
        }),
        .data_out(data_east_out[1]),
        .config_in(c_mux_east1)
    );
    
    MultiplexerSBIC mux_east2(
        .data_in({
            data_north_in[4],
            data_west_in[2],
            data_south_in[3],
            data_from_les
        }),
        .data_out(data_east_out[2]),
        .config_in(c_mux_east2)
    );
    
    MultiplexerSBIC mux_east3(
        .data_in({
            data_north_in[3],
            data_west_in[3],
            data_south_in[4],
            data_from_les
        }),
        .data_out(data_east_out[3]),
        .config_in(c_mux_east3)
    );
    
    MultiplexerSBIC mux_east4(
        .data_in({
            data_north_in[2],
            data_west_in[4],
            data_south_in[5],
            data_from_les
        }),
        .data_out(data_east_out[4]),
        .config_in(c_mux_east4)
    );
    
    MultiplexerSBIC mux_east5(
        .data_in({
            data_north_in[1],
            data_west_in[5],
            data_south_in[0],
            data_from_les
        }),
        .data_out(data_east_out[5]),
        .config_in(c_mux_east5)
    );
    

    // Side south
    MultiplexerSBIC mux_south0(
        .data_in({
            data_east_in[1],
            data_north_in[0],
            data_west_in[4],
            data_from_les
        }),
        .data_out(data_south_out[0]),
        .config_in(c_mux_south0)
    );
    
    MultiplexerSBIC mux_south1(
        .data_in({
            data_east_in[2],
            data_north_in[1],
            data_west_in[3],
            data_from_les
        }),
        .data_out(data_south_out[1]),
        .config_in(c_mux_south1)
    );
    
    MultiplexerSBIC mux_south2(
        .data_in({
            data_east_in[3],
            data_north_in[2],
            data_west_in[2],
            data_from_les
        }),
        .data_out(data_south_out[2]),
        .config_in(c_mux_south2)
    );
    
    MultiplexerSBIC mux_south3(
        .data_in({
            data_east_in[4],
            data_north_in[3],
            data_west_in[1],
            data_from_les
        }),
        .data_out(data_south_out[3]),
        .config_in(c_mux_south3)
    );
    
    MultiplexerSBIC mux_south4(
        .data_in({
            data_east_in[5],
            data_north_in[4],
            data_west_in[0],
            data_from_les
        }),
        .data_out(data_south_out[4]),
        .config_in(c_mux_south4)
    );
    
    MultiplexerSBIC mux_south5(
        .data_in({
            data_east_in[0],
            data_north_in[5],
            data_west_in[5],
            data_from_les
        }),
        .data_out(data_south_out[5]),
        .config_in(c_mux_south5)
    );
    

    // Side west
    MultiplexerSBIC mux_west0(
        .data_in({
            data_south_in[4],
            data_east_in[0],
            data_north_in[1],
            data_from_les
        }),
        .data_out(data_west_out[0]),
        .config_in(c_mux_west0)
    );
    
    MultiplexerSBIC mux_west1(
        .data_in({
            data_south_in[3],
            data_east_in[1],
            data_north_in[2],
            data_from_les
        }),
        .data_out(data_west_out[1]),
        .config_in(c_mux_west1)
    );
    
    MultiplexerSBIC mux_west2(
        .data_in({
            data_south_in[2],
            data_east_in[2],
            data_north_in[3],
            data_from_les
        }),
        .data_out(data_west_out[2]),
        .config_in(c_mux_west2)
    );
    
    MultiplexerSBIC mux_west3(
        .data_in({
            data_south_in[1],
            data_east_in[3],
            data_north_in[4],
            data_from_les
        }),
        .data_out(data_west_out[3]),
        .config_in(c_mux_west3)
    );
    
    MultiplexerSBIC mux_west4(
        .data_in({
            data_south_in[0],
            data_east_in[4],
            data_north_in[5],
            data_from_les
        }),
        .data_out(data_west_out[4]),
        .config_in(c_mux_west4)
    );
    
    MultiplexerSBIC mux_west5(
        .data_in({
            data_south_in[5],
            data_east_in[5],
            data_north_in[0],
            data_from_les
        }),
        .data_out(data_west_out[5]),
        .config_in(c_mux_west5)
    );
    

    // Le 
    
    MultiplexerSBLE mux_le0_i0(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[0]),
        .config_in(c_mux_le0_i0)
    );

    MultiplexerSBLE mux_le0_i1(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[1]),
        .config_in(c_mux_le0_i1)
    );

    MultiplexerSBLE mux_le0_i2(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[2]),
        .config_in(c_mux_le0_i2)
    );

    MultiplexerSBLE mux_le0_i3(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[3]),
        .config_in(c_mux_le0_i3)
    );

    MultiplexerSBLE mux_le1_i0(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[4]),
        .config_in(c_mux_le1_i0)
    );

    MultiplexerSBLE mux_le1_i1(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[5]),
        .config_in(c_mux_le1_i1)
    );

    MultiplexerSBLE mux_le1_i2(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[6]),
        .config_in(c_mux_le1_i2)
    );

    MultiplexerSBLE mux_le1_i3(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[7]),
        .config_in(c_mux_le1_i3)
    );


endmodule