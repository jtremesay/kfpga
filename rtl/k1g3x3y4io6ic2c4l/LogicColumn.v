module LogicColumn(
    input [5:0] data_north_in,
    output [5:0] data_north_out,
    input [17:0] data_east_in,
    output [17:0] data_east_out,
    input [5:0] data_south_in,
    output [5:0] data_south_out,
    input [17:0] data_west_in,
    output [17:0] data_west_out,
    input clock,
    input nreset,
    input [581:0] config_in
);
    // Dispatch the config 
    wire [193:0] c_tile0 = config_in[193:0]; 
    wire [193:0] c_tile1 = config_in[387:194]; 
    wire [193:0] c_tile2 = config_in[581:388];

    // Instantiate the tiles
    wire [5:0] lt0_north_out;
    
    LogicTile lt0(
        .data_north_in(lt1_south_out),
        .data_north_out(lt0_north_out),
        .data_east_in(data_east_in[5:0]),
        .data_east_out(data_east_out[5:0]),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_west_in(data_west_in[5:0]),
        .data_west_out(data_west_out[5:0]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile0),
    );

    wire [5:0] lt1_north_out;
    wire [5:0] lt1_south_out;
    LogicTile lt1(
        .data_north_in(lt2_south_out),
        .data_north_out(lt1_north_out),
        .data_east_in(data_east_in[11:6]),
        .data_east_out(data_east_out[11:6]),
        .data_south_in(lt0_north_out),
        .data_south_out(lt1_south_out),
        .data_west_in(data_west_in[11:6]),
        .data_west_out(data_west_out[11:6]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile1),
    );

    
    wire [5:0] lt2_south_out;
    LogicTile lt2(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in[17:12]),
        .data_east_out(data_east_out[17:12]),
        .data_south_in(lt1_north_out),
        .data_south_out(lt2_south_out),
        .data_west_in(data_west_in[17:12]),
        .data_west_out(data_west_out[17:12]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile2),
    );


endmodule