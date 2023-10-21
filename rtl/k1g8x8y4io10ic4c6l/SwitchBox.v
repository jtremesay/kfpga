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
    wire [2:0] c_muxes_north [9:0];
    assign c_muxes_north[0] = config_in[2:0];
    assign c_muxes_north[1] = config_in[5:3];
    assign c_muxes_north[2] = config_in[8:6];
    assign c_muxes_north[3] = config_in[11:9];
    assign c_muxes_north[4] = config_in[14:12];
    assign c_muxes_north[5] = config_in[17:15];
    assign c_muxes_north[6] = config_in[20:18];
    assign c_muxes_north[7] = config_in[23:21];
    assign c_muxes_north[8] = config_in[26:24];
    assign c_muxes_north[9] = config_in[29:27]; 
    wire [2:0] c_muxes_east [9:0];
    assign c_muxes_east[0] = config_in[32:30];
    assign c_muxes_east[1] = config_in[35:33];
    assign c_muxes_east[2] = config_in[38:36];
    assign c_muxes_east[3] = config_in[41:39];
    assign c_muxes_east[4] = config_in[44:42];
    assign c_muxes_east[5] = config_in[47:45];
    assign c_muxes_east[6] = config_in[50:48];
    assign c_muxes_east[7] = config_in[53:51];
    assign c_muxes_east[8] = config_in[56:54];
    assign c_muxes_east[9] = config_in[59:57]; 
    wire [2:0] c_muxes_south [9:0];
    assign c_muxes_south[0] = config_in[62:60];
    assign c_muxes_south[1] = config_in[65:63];
    assign c_muxes_south[2] = config_in[68:66];
    assign c_muxes_south[3] = config_in[71:69];
    assign c_muxes_south[4] = config_in[74:72];
    assign c_muxes_south[5] = config_in[77:75];
    assign c_muxes_south[6] = config_in[80:78];
    assign c_muxes_south[7] = config_in[83:81];
    assign c_muxes_south[8] = config_in[86:84];
    assign c_muxes_south[9] = config_in[89:87]; 
    wire [2:0] c_muxes_west [9:0];
    assign c_muxes_west[0] = config_in[92:90];
    assign c_muxes_west[1] = config_in[95:93];
    assign c_muxes_west[2] = config_in[98:96];
    assign c_muxes_west[3] = config_in[101:99];
    assign c_muxes_west[4] = config_in[104:102];
    assign c_muxes_west[5] = config_in[107:105];
    assign c_muxes_west[6] = config_in[110:108];
    assign c_muxes_west[7] = config_in[113:111];
    assign c_muxes_west[8] = config_in[116:114];
    assign c_muxes_west[9] = config_in[119:117]; 
    wire [5:0] c_muxes_les [23:0];
    assign c_muxes_les[0] = config_in[125:120];
    assign c_muxes_les[1] = config_in[131:126];
    assign c_muxes_les[2] = config_in[137:132];
    assign c_muxes_les[3] = config_in[143:138];
    assign c_muxes_les[4] = config_in[149:144];
    assign c_muxes_les[5] = config_in[155:150];
    assign c_muxes_les[6] = config_in[161:156];
    assign c_muxes_les[7] = config_in[167:162];
    assign c_muxes_les[8] = config_in[173:168];
    assign c_muxes_les[9] = config_in[179:174];
    assign c_muxes_les[10] = config_in[185:180];
    assign c_muxes_les[11] = config_in[191:186];
    assign c_muxes_les[12] = config_in[197:192];
    assign c_muxes_les[13] = config_in[203:198];
    assign c_muxes_les[14] = config_in[209:204];
    assign c_muxes_les[15] = config_in[215:210];
    assign c_muxes_les[16] = config_in[221:216];
    assign c_muxes_les[17] = config_in[227:222];
    assign c_muxes_les[18] = config_in[233:228];
    assign c_muxes_les[19] = config_in[239:234];
    assign c_muxes_les[20] = config_in[245:240];
    assign c_muxes_les[21] = config_in[251:246];
    assign c_muxes_les[22] = config_in[257:252];
    assign c_muxes_les[23] = config_in[263:258];

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
            .config_in(c_muxes_north[i])
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
            .config_in(c_muxes_north[i])
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
            .config_in(c_muxes_south[i])
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
            .config_in(c_muxes_west[i])
        );
    end

    // Le 
    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 6; j = j + 1 ) begin
            MultiplexerSBLE mux_le(
                .data_in({ 
                    data_north_in,
                    data_east_in,
                    data_south_in,
                    data_west_in,
                    data_from_les
                }),
                .data_out(data_to_les[i * 6 + j]),
                .config_in(c_muxes_les[i][j])
            );
        end
    end

endmodule