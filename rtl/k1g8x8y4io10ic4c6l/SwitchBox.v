module SwitchBox(
    input [9:0] data_north_in,
    output [9:0] data_north_out,
    input [9:0] data_east_in,
    output [9:0] data_east_out,
    input [9:0] data_south_in,
    output [9:0] data_south_out,
    input [9:0] data_west_in,
    output [9:0] data_west_out,
    input [3:0] data_from_les,
    output [23:0] data_to_les,
    input [263:0] config_in
);
    // Dispatch the config 
    wire [2:0] c_mux_north [9:0];
    assign c_mux_north[0] = config_in[2:0];
    assign c_mux_north[1] = config_in[5:3];
    assign c_mux_north[2] = config_in[8:6];
    assign c_mux_north[3] = config_in[11:9];
    assign c_mux_north[4] = config_in[14:12];
    assign c_mux_north[5] = config_in[17:15];
    assign c_mux_north[6] = config_in[20:18];
    assign c_mux_north[7] = config_in[23:21];
    assign c_mux_north[8] = config_in[26:24];
    assign c_mux_north[9] = config_in[29:27]; 
    wire [2:0] c_mux_east [9:0];
    assign c_mux_east[0] = config_in[32:30];
    assign c_mux_east[1] = config_in[35:33];
    assign c_mux_east[2] = config_in[38:36];
    assign c_mux_east[3] = config_in[41:39];
    assign c_mux_east[4] = config_in[44:42];
    assign c_mux_east[5] = config_in[47:45];
    assign c_mux_east[6] = config_in[50:48];
    assign c_mux_east[7] = config_in[53:51];
    assign c_mux_east[8] = config_in[56:54];
    assign c_mux_east[9] = config_in[59:57]; 
    wire [2:0] c_mux_south [9:0];
    assign c_mux_south[0] = config_in[62:60];
    assign c_mux_south[1] = config_in[65:63];
    assign c_mux_south[2] = config_in[68:66];
    assign c_mux_south[3] = config_in[71:69];
    assign c_mux_south[4] = config_in[74:72];
    assign c_mux_south[5] = config_in[77:75];
    assign c_mux_south[6] = config_in[80:78];
    assign c_mux_south[7] = config_in[83:81];
    assign c_mux_south[8] = config_in[86:84];
    assign c_mux_south[9] = config_in[89:87]; 
    wire [2:0] c_mux_west [9:0];
    assign c_mux_west[0] = config_in[92:90];
    assign c_mux_west[1] = config_in[95:93];
    assign c_mux_west[2] = config_in[98:96];
    assign c_mux_west[3] = config_in[101:99];
    assign c_mux_west[4] = config_in[104:102];
    assign c_mux_west[5] = config_in[107:105];
    assign c_mux_west[6] = config_in[110:108];
    assign c_mux_west[7] = config_in[113:111];
    assign c_mux_west[8] = config_in[116:114];
    assign c_mux_west[9] = config_in[119:117]; 
    wire [5:0] c_mux_le0_i0 = config_in[125:120]; 
    wire [5:0] c_mux_le0_i1 = config_in[131:126]; 
    wire [5:0] c_mux_le0_i2 = config_in[137:132]; 
    wire [5:0] c_mux_le0_i3 = config_in[143:138]; 
    wire [5:0] c_mux_le0_i4 = config_in[149:144]; 
    wire [5:0] c_mux_le0_i5 = config_in[155:150]; 
    wire [5:0] c_mux_le1_i0 = config_in[161:156]; 
    wire [5:0] c_mux_le1_i1 = config_in[167:162]; 
    wire [5:0] c_mux_le1_i2 = config_in[173:168]; 
    wire [5:0] c_mux_le1_i3 = config_in[179:174]; 
    wire [5:0] c_mux_le1_i4 = config_in[185:180]; 
    wire [5:0] c_mux_le1_i5 = config_in[191:186]; 
    wire [5:0] c_mux_le2_i0 = config_in[197:192]; 
    wire [5:0] c_mux_le2_i1 = config_in[203:198]; 
    wire [5:0] c_mux_le2_i2 = config_in[209:204]; 
    wire [5:0] c_mux_le2_i3 = config_in[215:210]; 
    wire [5:0] c_mux_le2_i4 = config_in[221:216]; 
    wire [5:0] c_mux_le2_i5 = config_in[227:222]; 
    wire [5:0] c_mux_le3_i0 = config_in[233:228]; 
    wire [5:0] c_mux_le3_i1 = config_in[239:234]; 
    wire [5:0] c_mux_le3_i2 = config_in[245:240]; 
    wire [5:0] c_mux_le3_i3 = config_in[251:246]; 
    wire [5:0] c_mux_le3_i4 = config_in[257:252]; 
    wire [5:0] c_mux_le3_i5 = config_in[263:258];

    // Use Wilton switchbox
    // https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.4925&rep=rep1&type=pdf
    // 6.1.2: Logic Resources, p103

    // Side north
    genvar i, j;
    for (i = 0; i < 10; i = i + 1 ) begin
        MultiplexerSBIC mux_north(
            .data_in({
                data_west_in[(i + 1) % 10],
                data_south_in[ i ], 
                data_east_in[(10 - i) % 10],
                data_from_les
            }),
            .data_out(data_north_out[i]),
            .config_in(c_mux_north[i])
        );
    end

    // Side east
    for (i = 0; i < 10; i = i + 1 ) begin
        MultiplexerSBIC mux_east(
            .data_in({
                data_north_in[(10 - i) % 10],
                data_west_in[i],
                data_south_in[(i + 1) % 10],
                data_from_les
            }),
            .data_out(data_east_out[i]),
            .config_in(c_mux_north[i])
        );
    end

    // Side south
    for (i = 0; i < 10; i = i + 1 ) begin
        MultiplexerSBIC mux_south(
            .data_in({
                data_east_in[( + 1) % 10],
                data_north_in[i],
                data_west_in[(18 - i) % 10],
                data_from_les
            }),
            .data_out(data_south_out[i]),
            .config_in(c_mux_south[i])
        );
    end

    // Side west
    for (i = 0; i < 10; i = i + 1 ) begin
        MultiplexerSBIC mux_west(
            .data_in({
                data_south_in[(18 - i) % 10],
                data_east_in[i],
                data_north_in[(i + 1) % 10],
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

    MultiplexerSBLE mux_le0_i4(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[4]),
        .config_in(c_mux_le0_i4)
    );

    MultiplexerSBLE mux_le0_i5(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[5]),
        .config_in(c_mux_le0_i5)
    );

    MultiplexerSBLE mux_le1_i0(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[6]),
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
        .data_out(data_to_les[7]),
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
        .data_out(data_to_les[8]),
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
        .data_out(data_to_les[9]),
        .config_in(c_mux_le1_i3)
    );

    MultiplexerSBLE mux_le1_i4(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[10]),
        .config_in(c_mux_le1_i4)
    );

    MultiplexerSBLE mux_le1_i5(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[11]),
        .config_in(c_mux_le1_i5)
    );

    MultiplexerSBLE mux_le2_i0(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[12]),
        .config_in(c_mux_le2_i0)
    );

    MultiplexerSBLE mux_le2_i1(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[13]),
        .config_in(c_mux_le2_i1)
    );

    MultiplexerSBLE mux_le2_i2(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[14]),
        .config_in(c_mux_le2_i2)
    );

    MultiplexerSBLE mux_le2_i3(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[15]),
        .config_in(c_mux_le2_i3)
    );

    MultiplexerSBLE mux_le2_i4(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[16]),
        .config_in(c_mux_le2_i4)
    );

    MultiplexerSBLE mux_le2_i5(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[17]),
        .config_in(c_mux_le2_i5)
    );

    MultiplexerSBLE mux_le3_i0(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[18]),
        .config_in(c_mux_le3_i0)
    );

    MultiplexerSBLE mux_le3_i1(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[19]),
        .config_in(c_mux_le3_i1)
    );

    MultiplexerSBLE mux_le3_i2(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[20]),
        .config_in(c_mux_le3_i2)
    );

    MultiplexerSBLE mux_le3_i3(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[21]),
        .config_in(c_mux_le3_i3)
    );

    MultiplexerSBLE mux_le3_i4(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[22]),
        .config_in(c_mux_le3_i4)
    );

    MultiplexerSBLE mux_le3_i5(
        .data_in({ 
            data_north_in,
            data_east_in,
            data_south_in,
            data_west_in,
            data_from_les
        }),
        .data_out(data_to_les[23]),
        .config_in(c_mux_le3_i5)
    );


endmodule