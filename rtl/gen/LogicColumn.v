module LogicColumn(
    input [9:0] data_north_in,
    output [9:0] data_north_out,
    input [79:0] data_east_in,
    output [79:0] data_east_out,
    input [9:0] data_south_in,
    output [9:0] data_south_out,
    input [79:0] data_west_in,
    output [79:0] data_west_out,
    input clock,
    input nreset,
    input [5151:0] config_in
);
    // Dispatch the config 
    wire [643:0] c_tile0 = config_in[643:0]; 
    wire [643:0] c_tile1 = config_in[1287:644]; 
    wire [643:0] c_tile2 = config_in[1931:1288]; 
    wire [643:0] c_tile3 = config_in[2575:1932]; 
    wire [643:0] c_tile4 = config_in[3219:2576]; 
    wire [643:0] c_tile5 = config_in[3863:3220]; 
    wire [643:0] c_tile6 = config_in[4507:3864]; 
    wire [643:0] c_tile7 = config_in[5151:4508];

    // Instantiate the tiles
    wire [9:0] lt0_north_out;
    
    LogicTile lt0(
        .data_north_in(lt1_south_out),
        .data_north_out(lt0_north_out),
        .data_east_in(data_east_in[9:0]),
        .data_east_out(data_east_out[9:0]),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_west_in(data_west_in[9:0]),
        .data_west_out(data_west_out[9:0]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile0),
    );

    wire [9:0] lt1_north_out;
    wire [9:0] lt1_south_out;
    LogicTile lt1(
        .data_north_in(lt2_south_out),
        .data_north_out(lt1_north_out),
        .data_east_in(data_east_in[19:10]),
        .data_east_out(data_east_out[19:10]),
        .data_south_in(lt0_north_out),
        .data_south_out(lt1_south_out),
        .data_west_in(data_west_in[19:10]),
        .data_west_out(data_west_out[19:10]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile1),
    );

    wire [9:0] lt2_north_out;
    wire [9:0] lt2_south_out;
    LogicTile lt2(
        .data_north_in(lt3_south_out),
        .data_north_out(lt2_north_out),
        .data_east_in(data_east_in[29:20]),
        .data_east_out(data_east_out[29:20]),
        .data_south_in(lt1_north_out),
        .data_south_out(lt2_south_out),
        .data_west_in(data_west_in[29:20]),
        .data_west_out(data_west_out[29:20]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile2),
    );

    wire [9:0] lt3_north_out;
    wire [9:0] lt3_south_out;
    LogicTile lt3(
        .data_north_in(lt4_south_out),
        .data_north_out(lt3_north_out),
        .data_east_in(data_east_in[39:30]),
        .data_east_out(data_east_out[39:30]),
        .data_south_in(lt2_north_out),
        .data_south_out(lt3_south_out),
        .data_west_in(data_west_in[39:30]),
        .data_west_out(data_west_out[39:30]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile3),
    );

    wire [9:0] lt4_north_out;
    wire [9:0] lt4_south_out;
    LogicTile lt4(
        .data_north_in(lt5_south_out),
        .data_north_out(lt4_north_out),
        .data_east_in(data_east_in[49:40]),
        .data_east_out(data_east_out[49:40]),
        .data_south_in(lt3_north_out),
        .data_south_out(lt4_south_out),
        .data_west_in(data_west_in[49:40]),
        .data_west_out(data_west_out[49:40]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile4),
    );

    wire [9:0] lt5_north_out;
    wire [9:0] lt5_south_out;
    LogicTile lt5(
        .data_north_in(lt6_south_out),
        .data_north_out(lt5_north_out),
        .data_east_in(data_east_in[59:50]),
        .data_east_out(data_east_out[59:50]),
        .data_south_in(lt4_north_out),
        .data_south_out(lt5_south_out),
        .data_west_in(data_west_in[59:50]),
        .data_west_out(data_west_out[59:50]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile5),
    );

    wire [9:0] lt6_north_out;
    wire [9:0] lt6_south_out;
    LogicTile lt6(
        .data_north_in(lt7_south_out),
        .data_north_out(lt6_north_out),
        .data_east_in(data_east_in[69:60]),
        .data_east_out(data_east_out[69:60]),
        .data_south_in(lt5_north_out),
        .data_south_out(lt6_south_out),
        .data_west_in(data_west_in[69:60]),
        .data_west_out(data_west_out[69:60]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile6),
    );

    
    wire [9:0] lt7_south_out;
    LogicTile lt7(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in[79:70]),
        .data_east_out(data_east_out[79:70]),
        .data_south_in(lt6_north_out),
        .data_south_out(lt7_south_out),
        .data_west_in(data_west_in[79:70]),
        .data_west_out(data_west_out[79:70]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile7),
    );


endmodule