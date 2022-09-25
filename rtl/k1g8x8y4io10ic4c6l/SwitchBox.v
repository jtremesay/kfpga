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
    input [383:0] config_in
);
    // Dispatch the config 
    wire [5:0] c_mux_north0 = config_in[5:0]; 
    wire [5:0] c_mux_north1 = config_in[11:6]; 
    wire [5:0] c_mux_north2 = config_in[17:12]; 
    wire [5:0] c_mux_north3 = config_in[23:18]; 
    wire [5:0] c_mux_north4 = config_in[29:24]; 
    wire [5:0] c_mux_north5 = config_in[35:30]; 
    wire [5:0] c_mux_north6 = config_in[41:36]; 
    wire [5:0] c_mux_north7 = config_in[47:42]; 
    wire [5:0] c_mux_north8 = config_in[53:48]; 
    wire [5:0] c_mux_north9 = config_in[59:54]; 
    wire [5:0] c_mux_east0 = config_in[65:60]; 
    wire [5:0] c_mux_east1 = config_in[71:66]; 
    wire [5:0] c_mux_east2 = config_in[77:72]; 
    wire [5:0] c_mux_east3 = config_in[83:78]; 
    wire [5:0] c_mux_east4 = config_in[89:84]; 
    wire [5:0] c_mux_east5 = config_in[95:90]; 
    wire [5:0] c_mux_east6 = config_in[101:96]; 
    wire [5:0] c_mux_east7 = config_in[107:102]; 
    wire [5:0] c_mux_east8 = config_in[113:108]; 
    wire [5:0] c_mux_east9 = config_in[119:114]; 
    wire [5:0] c_mux_south0 = config_in[125:120]; 
    wire [5:0] c_mux_south1 = config_in[131:126]; 
    wire [5:0] c_mux_south2 = config_in[137:132]; 
    wire [5:0] c_mux_south3 = config_in[143:138]; 
    wire [5:0] c_mux_south4 = config_in[149:144]; 
    wire [5:0] c_mux_south5 = config_in[155:150]; 
    wire [5:0] c_mux_south6 = config_in[161:156]; 
    wire [5:0] c_mux_south7 = config_in[167:162]; 
    wire [5:0] c_mux_south8 = config_in[173:168]; 
    wire [5:0] c_mux_south9 = config_in[179:174]; 
    wire [5:0] c_mux_west0 = config_in[185:180]; 
    wire [5:0] c_mux_west1 = config_in[191:186]; 
    wire [5:0] c_mux_west2 = config_in[197:192]; 
    wire [5:0] c_mux_west3 = config_in[203:198]; 
    wire [5:0] c_mux_west4 = config_in[209:204]; 
    wire [5:0] c_mux_west5 = config_in[215:210]; 
    wire [5:0] c_mux_west6 = config_in[221:216]; 
    wire [5:0] c_mux_west7 = config_in[227:222]; 
    wire [5:0] c_mux_west8 = config_in[233:228]; 
    wire [5:0] c_mux_west9 = config_in[239:234]; 
    wire [5:0] c_mux_le0_i0 = config_in[245:240]; 
    wire [5:0] c_mux_le0_i1 = config_in[251:246]; 
    wire [5:0] c_mux_le0_i2 = config_in[257:252]; 
    wire [5:0] c_mux_le0_i3 = config_in[263:258]; 
    wire [5:0] c_mux_le0_i4 = config_in[269:264]; 
    wire [5:0] c_mux_le0_i5 = config_in[275:270]; 
    wire [5:0] c_mux_le1_i0 = config_in[281:276]; 
    wire [5:0] c_mux_le1_i1 = config_in[287:282]; 
    wire [5:0] c_mux_le1_i2 = config_in[293:288]; 
    wire [5:0] c_mux_le1_i3 = config_in[299:294]; 
    wire [5:0] c_mux_le1_i4 = config_in[305:300]; 
    wire [5:0] c_mux_le1_i5 = config_in[311:306]; 
    wire [5:0] c_mux_le2_i0 = config_in[317:312]; 
    wire [5:0] c_mux_le2_i1 = config_in[323:318]; 
    wire [5:0] c_mux_le2_i2 = config_in[329:324]; 
    wire [5:0] c_mux_le2_i3 = config_in[335:330]; 
    wire [5:0] c_mux_le2_i4 = config_in[341:336]; 
    wire [5:0] c_mux_le2_i5 = config_in[347:342]; 
    wire [5:0] c_mux_le3_i0 = config_in[353:348]; 
    wire [5:0] c_mux_le3_i1 = config_in[359:354]; 
    wire [5:0] c_mux_le3_i2 = config_in[365:360]; 
    wire [5:0] c_mux_le3_i3 = config_in[371:366]; 
    wire [5:0] c_mux_le3_i4 = config_in[377:372]; 
    wire [5:0] c_mux_le3_i5 = config_in[383:378];

    
    // Side north
    wire [33:0] w_inputs_for_north = {data_east_in, data_south_in, data_west_in, data_from_les};
    
    MultiplexerSBIC mux_north0(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[0]),
        .config_in(c_mux_north0)
    );
    
    MultiplexerSBIC mux_north1(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[1]),
        .config_in(c_mux_north1)
    );
    
    MultiplexerSBIC mux_north2(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[2]),
        .config_in(c_mux_north2)
    );
    
    MultiplexerSBIC mux_north3(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[3]),
        .config_in(c_mux_north3)
    );
    
    MultiplexerSBIC mux_north4(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[4]),
        .config_in(c_mux_north4)
    );
    
    MultiplexerSBIC mux_north5(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[5]),
        .config_in(c_mux_north5)
    );
    
    MultiplexerSBIC mux_north6(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[6]),
        .config_in(c_mux_north6)
    );
    
    MultiplexerSBIC mux_north7(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[7]),
        .config_in(c_mux_north7)
    );
    
    MultiplexerSBIC mux_north8(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[8]),
        .config_in(c_mux_north8)
    );
    
    MultiplexerSBIC mux_north9(
        .data_in(w_inputs_for_north),
        .data_out(data_north_out[9]),
        .config_in(c_mux_north9)
    );
    
    
    // Side east
    wire [33:0] w_inputs_for_east = {data_north_in, data_south_in, data_west_in, data_from_les};
    
    MultiplexerSBIC mux_east0(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[0]),
        .config_in(c_mux_east0)
    );
    
    MultiplexerSBIC mux_east1(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[1]),
        .config_in(c_mux_east1)
    );
    
    MultiplexerSBIC mux_east2(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[2]),
        .config_in(c_mux_east2)
    );
    
    MultiplexerSBIC mux_east3(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[3]),
        .config_in(c_mux_east3)
    );
    
    MultiplexerSBIC mux_east4(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[4]),
        .config_in(c_mux_east4)
    );
    
    MultiplexerSBIC mux_east5(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[5]),
        .config_in(c_mux_east5)
    );
    
    MultiplexerSBIC mux_east6(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[6]),
        .config_in(c_mux_east6)
    );
    
    MultiplexerSBIC mux_east7(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[7]),
        .config_in(c_mux_east7)
    );
    
    MultiplexerSBIC mux_east8(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[8]),
        .config_in(c_mux_east8)
    );
    
    MultiplexerSBIC mux_east9(
        .data_in(w_inputs_for_east),
        .data_out(data_east_out[9]),
        .config_in(c_mux_east9)
    );
    
    
    // Side south
    wire [33:0] w_inputs_for_south = {data_north_in, data_east_in, data_west_in, data_from_les};
    
    MultiplexerSBIC mux_south0(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[0]),
        .config_in(c_mux_south0)
    );
    
    MultiplexerSBIC mux_south1(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[1]),
        .config_in(c_mux_south1)
    );
    
    MultiplexerSBIC mux_south2(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[2]),
        .config_in(c_mux_south2)
    );
    
    MultiplexerSBIC mux_south3(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[3]),
        .config_in(c_mux_south3)
    );
    
    MultiplexerSBIC mux_south4(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[4]),
        .config_in(c_mux_south4)
    );
    
    MultiplexerSBIC mux_south5(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[5]),
        .config_in(c_mux_south5)
    );
    
    MultiplexerSBIC mux_south6(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[6]),
        .config_in(c_mux_south6)
    );
    
    MultiplexerSBIC mux_south7(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[7]),
        .config_in(c_mux_south7)
    );
    
    MultiplexerSBIC mux_south8(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[8]),
        .config_in(c_mux_south8)
    );
    
    MultiplexerSBIC mux_south9(
        .data_in(w_inputs_for_south),
        .data_out(data_south_out[9]),
        .config_in(c_mux_south9)
    );
    
    
    // Side west
    wire [33:0] w_inputs_for_west = {data_north_in, data_east_in, data_south_in, data_from_les};
    
    MultiplexerSBIC mux_west0(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[0]),
        .config_in(c_mux_west0)
    );
    
    MultiplexerSBIC mux_west1(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[1]),
        .config_in(c_mux_west1)
    );
    
    MultiplexerSBIC mux_west2(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[2]),
        .config_in(c_mux_west2)
    );
    
    MultiplexerSBIC mux_west3(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[3]),
        .config_in(c_mux_west3)
    );
    
    MultiplexerSBIC mux_west4(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[4]),
        .config_in(c_mux_west4)
    );
    
    MultiplexerSBIC mux_west5(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[5]),
        .config_in(c_mux_west5)
    );
    
    MultiplexerSBIC mux_west6(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[6]),
        .config_in(c_mux_west6)
    );
    
    MultiplexerSBIC mux_west7(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[7]),
        .config_in(c_mux_west7)
    );
    
    MultiplexerSBIC mux_west8(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[8]),
        .config_in(c_mux_west8)
    );
    
    MultiplexerSBIC mux_west9(
        .data_in(w_inputs_for_west),
        .data_out(data_west_out[9]),
        .config_in(c_mux_west9)
    );
    
    

    // Le 
    wire [43:0] w_inputs_for_les = {data_north_in, data_east_in, data_south_in, data_west_in, data_from_les};
    
    MultiplexerSBLE mux_le0_i0(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[0]),
        .config_in(c_mux_le0_i0)
    );
    
    MultiplexerSBLE mux_le0_i1(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[1]),
        .config_in(c_mux_le0_i1)
    );
    
    MultiplexerSBLE mux_le0_i2(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[2]),
        .config_in(c_mux_le0_i2)
    );
    
    MultiplexerSBLE mux_le0_i3(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[3]),
        .config_in(c_mux_le0_i3)
    );
    
    MultiplexerSBLE mux_le0_i4(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[4]),
        .config_in(c_mux_le0_i4)
    );
    
    MultiplexerSBLE mux_le0_i5(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[5]),
        .config_in(c_mux_le0_i5)
    );
    
    MultiplexerSBLE mux_le1_i0(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[6]),
        .config_in(c_mux_le1_i0)
    );
    
    MultiplexerSBLE mux_le1_i1(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[7]),
        .config_in(c_mux_le1_i1)
    );
    
    MultiplexerSBLE mux_le1_i2(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[8]),
        .config_in(c_mux_le1_i2)
    );
    
    MultiplexerSBLE mux_le1_i3(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[9]),
        .config_in(c_mux_le1_i3)
    );
    
    MultiplexerSBLE mux_le1_i4(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[10]),
        .config_in(c_mux_le1_i4)
    );
    
    MultiplexerSBLE mux_le1_i5(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[11]),
        .config_in(c_mux_le1_i5)
    );
    
    MultiplexerSBLE mux_le2_i0(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[12]),
        .config_in(c_mux_le2_i0)
    );
    
    MultiplexerSBLE mux_le2_i1(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[13]),
        .config_in(c_mux_le2_i1)
    );
    
    MultiplexerSBLE mux_le2_i2(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[14]),
        .config_in(c_mux_le2_i2)
    );
    
    MultiplexerSBLE mux_le2_i3(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[15]),
        .config_in(c_mux_le2_i3)
    );
    
    MultiplexerSBLE mux_le2_i4(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[16]),
        .config_in(c_mux_le2_i4)
    );
    
    MultiplexerSBLE mux_le2_i5(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[17]),
        .config_in(c_mux_le2_i5)
    );
    
    MultiplexerSBLE mux_le3_i0(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[18]),
        .config_in(c_mux_le3_i0)
    );
    
    MultiplexerSBLE mux_le3_i1(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[19]),
        .config_in(c_mux_le3_i1)
    );
    
    MultiplexerSBLE mux_le3_i2(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[20]),
        .config_in(c_mux_le3_i2)
    );
    
    MultiplexerSBLE mux_le3_i3(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[21]),
        .config_in(c_mux_le3_i3)
    );
    
    MultiplexerSBLE mux_le3_i4(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[22]),
        .config_in(c_mux_le3_i4)
    );
    
    MultiplexerSBLE mux_le3_i5(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[23]),
        .config_in(c_mux_le3_i5)
    );
    

endmodule