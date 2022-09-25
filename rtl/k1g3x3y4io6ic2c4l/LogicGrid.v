module LogicGrid(
    input [17:0] data_north_in,
    output [17:0] data_north_out,
    input [17:0] data_east_in,
    output [17:0] data_east_out,
    input [17:0] data_south_in,
    output [17:0] data_south_out,
    input [17:0] data_west_in,
    output [17:0] data_west_out,
    input clock,
    input nreset,
    input [1745:0] config_in
);
    // Dispatch the config 
    wire [581:0] c_column0 = config_in[581:0]; 
    wire [581:0] c_column1 = config_in[1163:582]; 
    wire [581:0] c_column2 = config_in[1745:1164];

    // Instantiate the columns
    wire [17:0] lc0_east_out;
    
    LogicColumn lc0(
        .data_north_in(data_north_in[5:0]),
        .data_north_out(data_north_out[5:0]),
        .data_east_in(lc1_west_out),
        .data_east_out(lc0_east_out),
        .data_south_in(data_south_in[5:0]),
        .data_south_out(data_south_out[5:0]),
        .data_west_in(data_west_in),
        .data_west_out(data_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column0),
    );

    wire [17:0] lc1_east_out;
    wire [17:0] lc1_west_out;
    LogicColumn lc1(
        .data_north_in(data_north_in[11:6]),
        .data_north_out(data_north_out[11:6]),
        .data_east_in(lc2_west_out),
        .data_east_out(lc1_east_out),
        .data_south_in(data_south_in[11:6]),
        .data_south_out(data_south_out[11:6]),
        .data_west_in(lc0_east_out),
        .data_west_out(lc1_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column1),
    );

    
    wire [17:0] lc2_west_out;
    LogicColumn lc2(
        .data_north_in(data_north_in[17:12]),
        .data_north_out(data_north_out[17:12]),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in[17:12]),
        .data_south_out(data_south_out[17:12]),
        .data_west_in(lc1_east_out),
        .data_west_out(lc2_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column2),
    );


endmodule