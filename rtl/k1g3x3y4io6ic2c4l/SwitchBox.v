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
    wire [2:0] c_mux_north [5:0];
    assign c_mux_north[0] = config_in[2:0];
    assign c_mux_north[1] = config_in[5:3];
    assign c_mux_north[2] = config_in[8:6];
    assign c_mux_north[3] = config_in[11:9];
    assign c_mux_north[4] = config_in[14:12];
    assign c_mux_north[5] = config_in[17:15]; 
    wire [2:0] c_mux_east [5:0];
    assign c_mux_east[0] = config_in[20:18];
    assign c_mux_east[1] = config_in[23:21];
    assign c_mux_east[2] = config_in[26:24];
    assign c_mux_east[3] = config_in[29:27];
    assign c_mux_east[4] = config_in[32:30];
    assign c_mux_east[5] = config_in[35:33]; 
    wire [2:0] c_mux_south [5:0];
    assign c_mux_south[0] = config_in[38:36];
    assign c_mux_south[1] = config_in[41:39];
    assign c_mux_south[2] = config_in[44:42];
    assign c_mux_south[3] = config_in[47:45];
    assign c_mux_south[4] = config_in[50:48];
    assign c_mux_south[5] = config_in[53:51]; 
    wire [2:0] c_mux_west [5:0];
    assign c_mux_west[0] = config_in[56:54];
    assign c_mux_west[1] = config_in[59:57];
    assign c_mux_west[2] = config_in[62:60];
    assign c_mux_west[3] = config_in[65:63];
    assign c_mux_west[4] = config_in[68:66];
    assign c_mux_west[5] = config_in[71:69]; 
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
    genvar i, j;
    for (i = 0; i < 6; i = i + 1 ) begin
        MultiplexerSBIC mux_north(
            .data_in({
                data_west_in[(i + 1) % 6],
                data_south_in[ i ], 
                data_east_in[(6 - i) % 6],
                data_from_les
            }),
            .data_out(data_north_out[i]),
            .config_in(c_mux_north[i])
        );
    end

    // Side east
    for (i = 0; i < 6; i = i + 1 ) begin
        MultiplexerSBIC mux_east(
            .data_in({
                data_north_in[(6 - i) % 6],
                data_west_in[i],
                data_south_in[(i + 1) % 6],
                data_from_les
            }),
            .data_out(data_east_out[i]),
            .config_in(c_mux_north[i])
        );
    end

    // Side south
    for (i = 0; i < 6; i = i + 1 ) begin
        MultiplexerSBIC mux_south(
            .data_in({
                data_east_in[( + 1) % 6],
                data_north_in[i],
                data_west_in[(10 - i) % 6],
                data_from_les
            }),
            .data_out(data_south_out[i]),
            .config_in(c_mux_south[i])
        );
    end

    // Side west
    for (i = 0; i < 6; i = i + 1 ) begin
        MultiplexerSBIC mux_west(
            .data_in({
                data_south_in[(10 - i) % 6],
                data_east_in[i],
                data_north_in[(i + 1) % 6],
                data_from_les
            }),
            .data_out(data_west_out[i]),
            .config_in(c_mux_west[i])
        );
    end

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