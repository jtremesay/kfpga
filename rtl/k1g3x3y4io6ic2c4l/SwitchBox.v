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
    input [159:0] config_in
);
    // Dispatch the config 
    wire [4:0] c_mux_north0 = config_in[4:0]; 
    wire [4:0] c_mux_north1 = config_in[9:5]; 
    wire [4:0] c_mux_north2 = config_in[14:10]; 
    wire [4:0] c_mux_north3 = config_in[19:15]; 
    wire [4:0] c_mux_north4 = config_in[24:20]; 
    wire [4:0] c_mux_north5 = config_in[29:25]; 
    wire [4:0] c_mux_east0 = config_in[34:30]; 
    wire [4:0] c_mux_east1 = config_in[39:35]; 
    wire [4:0] c_mux_east2 = config_in[44:40]; 
    wire [4:0] c_mux_east3 = config_in[49:45]; 
    wire [4:0] c_mux_east4 = config_in[54:50]; 
    wire [4:0] c_mux_east5 = config_in[59:55]; 
    wire [4:0] c_mux_south0 = config_in[64:60]; 
    wire [4:0] c_mux_south1 = config_in[69:65]; 
    wire [4:0] c_mux_south2 = config_in[74:70]; 
    wire [4:0] c_mux_south3 = config_in[79:75]; 
    wire [4:0] c_mux_south4 = config_in[84:80]; 
    wire [4:0] c_mux_south5 = config_in[89:85]; 
    wire [4:0] c_mux_west0 = config_in[94:90]; 
    wire [4:0] c_mux_west1 = config_in[99:95]; 
    wire [4:0] c_mux_west2 = config_in[104:100]; 
    wire [4:0] c_mux_west3 = config_in[109:105]; 
    wire [4:0] c_mux_west4 = config_in[114:110]; 
    wire [4:0] c_mux_west5 = config_in[119:115]; 
    wire [4:0] c_mux_le0_i0 = config_in[124:120]; 
    wire [4:0] c_mux_le0_i1 = config_in[129:125]; 
    wire [4:0] c_mux_le0_i2 = config_in[134:130]; 
    wire [4:0] c_mux_le0_i3 = config_in[139:135]; 
    wire [4:0] c_mux_le1_i0 = config_in[144:140]; 
    wire [4:0] c_mux_le1_i1 = config_in[149:145]; 
    wire [4:0] c_mux_le1_i2 = config_in[154:150]; 
    wire [4:0] c_mux_le1_i3 = config_in[159:155];

    
    // Side north
    wire [19:0] w_inputs_for_north = {data_east_in, data_south_in, data_west_in, data_from_les};
    
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
    
    
    // Side east
    wire [19:0] w_inputs_for_east = {data_north_in, data_south_in, data_west_in, data_from_les};
    
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
    
    
    // Side south
    wire [19:0] w_inputs_for_south = {data_north_in, data_east_in, data_west_in, data_from_les};
    
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
    
    
    // Side west
    wire [19:0] w_inputs_for_west = {data_north_in, data_east_in, data_south_in, data_from_les};
    
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
    
    

    // Le 
    wire [25:0] w_inputs_for_les = {data_north_in, data_east_in, data_south_in, data_west_in, data_from_les};
    
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
    
    MultiplexerSBLE mux_le1_i0(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[4]),
        .config_in(c_mux_le1_i0)
    );
    
    MultiplexerSBLE mux_le1_i1(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[5]),
        .config_in(c_mux_le1_i1)
    );
    
    MultiplexerSBLE mux_le1_i2(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[6]),
        .config_in(c_mux_le1_i2)
    );
    
    MultiplexerSBLE mux_le1_i3(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[7]),
        .config_in(c_mux_le1_i3)
    );
    

endmodule