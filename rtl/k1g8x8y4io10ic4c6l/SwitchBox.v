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
    wire [2:0] c_mux_north0 = config_in[2:0]; 
    wire [2:0] c_mux_north1 = config_in[5:3]; 
    wire [2:0] c_mux_north2 = config_in[8:6]; 
    wire [2:0] c_mux_north3 = config_in[11:9]; 
    wire [2:0] c_mux_north4 = config_in[14:12]; 
    wire [2:0] c_mux_north5 = config_in[17:15]; 
    wire [2:0] c_mux_north6 = config_in[20:18]; 
    wire [2:0] c_mux_north7 = config_in[23:21]; 
    wire [2:0] c_mux_north8 = config_in[26:24]; 
    wire [2:0] c_mux_north9 = config_in[29:27]; 
    wire [2:0] c_mux_east0 = config_in[32:30]; 
    wire [2:0] c_mux_east1 = config_in[35:33]; 
    wire [2:0] c_mux_east2 = config_in[38:36]; 
    wire [2:0] c_mux_east3 = config_in[41:39]; 
    wire [2:0] c_mux_east4 = config_in[44:42]; 
    wire [2:0] c_mux_east5 = config_in[47:45]; 
    wire [2:0] c_mux_east6 = config_in[50:48]; 
    wire [2:0] c_mux_east7 = config_in[53:51]; 
    wire [2:0] c_mux_east8 = config_in[56:54]; 
    wire [2:0] c_mux_east9 = config_in[59:57]; 
    wire [2:0] c_mux_south0 = config_in[62:60]; 
    wire [2:0] c_mux_south1 = config_in[65:63]; 
    wire [2:0] c_mux_south2 = config_in[68:66]; 
    wire [2:0] c_mux_south3 = config_in[71:69]; 
    wire [2:0] c_mux_south4 = config_in[74:72]; 
    wire [2:0] c_mux_south5 = config_in[77:75]; 
    wire [2:0] c_mux_south6 = config_in[80:78]; 
    wire [2:0] c_mux_south7 = config_in[83:81]; 
    wire [2:0] c_mux_south8 = config_in[86:84]; 
    wire [2:0] c_mux_south9 = config_in[89:87]; 
    wire [2:0] c_mux_west0 = config_in[92:90]; 
    wire [2:0] c_mux_west1 = config_in[95:93]; 
    wire [2:0] c_mux_west2 = config_in[98:96]; 
    wire [2:0] c_mux_west3 = config_in[101:99]; 
    wire [2:0] c_mux_west4 = config_in[104:102]; 
    wire [2:0] c_mux_west5 = config_in[107:105]; 
    wire [2:0] c_mux_west6 = config_in[110:108]; 
    wire [2:0] c_mux_west7 = config_in[113:111]; 
    wire [2:0] c_mux_west8 = config_in[116:114]; 
    wire [2:0] c_mux_west9 = config_in[119:117]; 
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
            data_east_in[9],
            data_from_les
        }),
        .data_out(data_north_out[1]),
        .config_in(c_mux_north1)
    );
    
    MultiplexerSBIC mux_north2(
        .data_in({
            data_west_in[3],
            data_south_in[2], 
            data_east_in[8],
            data_from_les
        }),
        .data_out(data_north_out[2]),
        .config_in(c_mux_north2)
    );
    
    MultiplexerSBIC mux_north3(
        .data_in({
            data_west_in[4],
            data_south_in[3], 
            data_east_in[7],
            data_from_les
        }),
        .data_out(data_north_out[3]),
        .config_in(c_mux_north3)
    );
    
    MultiplexerSBIC mux_north4(
        .data_in({
            data_west_in[5],
            data_south_in[4], 
            data_east_in[6],
            data_from_les
        }),
        .data_out(data_north_out[4]),
        .config_in(c_mux_north4)
    );
    
    MultiplexerSBIC mux_north5(
        .data_in({
            data_west_in[6],
            data_south_in[5], 
            data_east_in[5],
            data_from_les
        }),
        .data_out(data_north_out[5]),
        .config_in(c_mux_north5)
    );
    
    MultiplexerSBIC mux_north6(
        .data_in({
            data_west_in[7],
            data_south_in[6], 
            data_east_in[4],
            data_from_les
        }),
        .data_out(data_north_out[6]),
        .config_in(c_mux_north6)
    );
    
    MultiplexerSBIC mux_north7(
        .data_in({
            data_west_in[8],
            data_south_in[7], 
            data_east_in[3],
            data_from_les
        }),
        .data_out(data_north_out[7]),
        .config_in(c_mux_north7)
    );
    
    MultiplexerSBIC mux_north8(
        .data_in({
            data_west_in[9],
            data_south_in[8], 
            data_east_in[2],
            data_from_les
        }),
        .data_out(data_north_out[8]),
        .config_in(c_mux_north8)
    );
    
    MultiplexerSBIC mux_north9(
        .data_in({
            data_west_in[0],
            data_south_in[9], 
            data_east_in[1],
            data_from_les
        }),
        .data_out(data_north_out[9]),
        .config_in(c_mux_north9)
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
            data_north_in[9],
            data_west_in[1],
            data_south_in[2],
            data_from_les
        }),
        .data_out(data_east_out[1]),
        .config_in(c_mux_east1)
    );
    
    MultiplexerSBIC mux_east2(
        .data_in({
            data_north_in[8],
            data_west_in[2],
            data_south_in[3],
            data_from_les
        }),
        .data_out(data_east_out[2]),
        .config_in(c_mux_east2)
    );
    
    MultiplexerSBIC mux_east3(
        .data_in({
            data_north_in[7],
            data_west_in[3],
            data_south_in[4],
            data_from_les
        }),
        .data_out(data_east_out[3]),
        .config_in(c_mux_east3)
    );
    
    MultiplexerSBIC mux_east4(
        .data_in({
            data_north_in[6],
            data_west_in[4],
            data_south_in[5],
            data_from_les
        }),
        .data_out(data_east_out[4]),
        .config_in(c_mux_east4)
    );
    
    MultiplexerSBIC mux_east5(
        .data_in({
            data_north_in[5],
            data_west_in[5],
            data_south_in[6],
            data_from_les
        }),
        .data_out(data_east_out[5]),
        .config_in(c_mux_east5)
    );
    
    MultiplexerSBIC mux_east6(
        .data_in({
            data_north_in[4],
            data_west_in[6],
            data_south_in[7],
            data_from_les
        }),
        .data_out(data_east_out[6]),
        .config_in(c_mux_east6)
    );
    
    MultiplexerSBIC mux_east7(
        .data_in({
            data_north_in[3],
            data_west_in[7],
            data_south_in[8],
            data_from_les
        }),
        .data_out(data_east_out[7]),
        .config_in(c_mux_east7)
    );
    
    MultiplexerSBIC mux_east8(
        .data_in({
            data_north_in[2],
            data_west_in[8],
            data_south_in[9],
            data_from_les
        }),
        .data_out(data_east_out[8]),
        .config_in(c_mux_east8)
    );
    
    MultiplexerSBIC mux_east9(
        .data_in({
            data_north_in[1],
            data_west_in[9],
            data_south_in[0],
            data_from_les
        }),
        .data_out(data_east_out[9]),
        .config_in(c_mux_east9)
    );
    

    // Side south
    MultiplexerSBIC mux_south0(
        .data_in({
            data_east_in[1],
            data_north_in[0],
            data_west_in[8],
            data_from_les
        }),
        .data_out(data_south_out[0]),
        .config_in(c_mux_south0)
    );
    
    MultiplexerSBIC mux_south1(
        .data_in({
            data_east_in[2],
            data_north_in[1],
            data_west_in[7],
            data_from_les
        }),
        .data_out(data_south_out[1]),
        .config_in(c_mux_south1)
    );
    
    MultiplexerSBIC mux_south2(
        .data_in({
            data_east_in[3],
            data_north_in[2],
            data_west_in[6],
            data_from_les
        }),
        .data_out(data_south_out[2]),
        .config_in(c_mux_south2)
    );
    
    MultiplexerSBIC mux_south3(
        .data_in({
            data_east_in[4],
            data_north_in[3],
            data_west_in[5],
            data_from_les
        }),
        .data_out(data_south_out[3]),
        .config_in(c_mux_south3)
    );
    
    MultiplexerSBIC mux_south4(
        .data_in({
            data_east_in[5],
            data_north_in[4],
            data_west_in[4],
            data_from_les
        }),
        .data_out(data_south_out[4]),
        .config_in(c_mux_south4)
    );
    
    MultiplexerSBIC mux_south5(
        .data_in({
            data_east_in[6],
            data_north_in[5],
            data_west_in[3],
            data_from_les
        }),
        .data_out(data_south_out[5]),
        .config_in(c_mux_south5)
    );
    
    MultiplexerSBIC mux_south6(
        .data_in({
            data_east_in[7],
            data_north_in[6],
            data_west_in[2],
            data_from_les
        }),
        .data_out(data_south_out[6]),
        .config_in(c_mux_south6)
    );
    
    MultiplexerSBIC mux_south7(
        .data_in({
            data_east_in[8],
            data_north_in[7],
            data_west_in[1],
            data_from_les
        }),
        .data_out(data_south_out[7]),
        .config_in(c_mux_south7)
    );
    
    MultiplexerSBIC mux_south8(
        .data_in({
            data_east_in[9],
            data_north_in[8],
            data_west_in[0],
            data_from_les
        }),
        .data_out(data_south_out[8]),
        .config_in(c_mux_south8)
    );
    
    MultiplexerSBIC mux_south9(
        .data_in({
            data_east_in[0],
            data_north_in[9],
            data_west_in[9],
            data_from_les
        }),
        .data_out(data_south_out[9]),
        .config_in(c_mux_south9)
    );
    

    // Side west
    MultiplexerSBIC mux_west0(
        .data_in({
            data_south_in[8],
            data_east_in[0],
            data_north_in[1],
            data_from_les
        }),
        .data_out(data_west_out[0]),
        .config_in(c_mux_west0)
    );
    
    MultiplexerSBIC mux_west1(
        .data_in({
            data_south_in[7],
            data_east_in[1],
            data_north_in[2],
            data_from_les
        }),
        .data_out(data_west_out[1]),
        .config_in(c_mux_west1)
    );
    
    MultiplexerSBIC mux_west2(
        .data_in({
            data_south_in[6],
            data_east_in[2],
            data_north_in[3],
            data_from_les
        }),
        .data_out(data_west_out[2]),
        .config_in(c_mux_west2)
    );
    
    MultiplexerSBIC mux_west3(
        .data_in({
            data_south_in[5],
            data_east_in[3],
            data_north_in[4],
            data_from_les
        }),
        .data_out(data_west_out[3]),
        .config_in(c_mux_west3)
    );
    
    MultiplexerSBIC mux_west4(
        .data_in({
            data_south_in[4],
            data_east_in[4],
            data_north_in[5],
            data_from_les
        }),
        .data_out(data_west_out[4]),
        .config_in(c_mux_west4)
    );
    
    MultiplexerSBIC mux_west5(
        .data_in({
            data_south_in[3],
            data_east_in[5],
            data_north_in[6],
            data_from_les
        }),
        .data_out(data_west_out[5]),
        .config_in(c_mux_west5)
    );
    
    MultiplexerSBIC mux_west6(
        .data_in({
            data_south_in[2],
            data_east_in[6],
            data_north_in[7],
            data_from_les
        }),
        .data_out(data_west_out[6]),
        .config_in(c_mux_west6)
    );
    
    MultiplexerSBIC mux_west7(
        .data_in({
            data_south_in[1],
            data_east_in[7],
            data_north_in[8],
            data_from_les
        }),
        .data_out(data_west_out[7]),
        .config_in(c_mux_west7)
    );
    
    MultiplexerSBIC mux_west8(
        .data_in({
            data_south_in[0],
            data_east_in[8],
            data_north_in[9],
            data_from_les
        }),
        .data_out(data_west_out[8]),
        .config_in(c_mux_west8)
    );
    
    MultiplexerSBIC mux_west9(
        .data_in({
            data_south_in[9],
            data_east_in[9],
            data_north_in[0],
            data_from_les
        }),
        .data_out(data_west_out[9]),
        .config_in(c_mux_west9)
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