module LogicGrid(
    input [79:0] data_north_in,
    output [79:0] data_north_out,
    input [79:0] data_east_in,
    output [79:0] data_east_out,
    input [79:0] data_south_in,
    output [79:0] data_south_out,
    input [79:0] data_west_in,
    output [79:0] data_west_out,
    input clock,
    input nreset,
    input [41215:0] config_in
);
    // Dispatch the config 
    wire [5151:0] c_column0 = config_in[5151:0]; 
    wire [5151:0] c_column1 = config_in[10303:5152]; 
    wire [5151:0] c_column2 = config_in[15455:10304]; 
    wire [5151:0] c_column3 = config_in[20607:15456]; 
    wire [5151:0] c_column4 = config_in[25759:20608]; 
    wire [5151:0] c_column5 = config_in[30911:25760]; 
    wire [5151:0] c_column6 = config_in[36063:30912]; 
    wire [5151:0] c_column7 = config_in[41215:36064];

    // Instantiate the columns
    wire [79:0] lc0_east_out;
    
    LogicColumn lc0(
        .data_north_in(data_north_in[9:0]),
        .data_north_out(data_north_out[9:0]),
        .data_east_in(lc1_west_out),
        .data_east_out(lc0_east_out),
        .data_south_in(data_south_in[9:0]),
        .data_south_out(data_south_out[9:0]),
        .data_west_in(data_west_in),
        .data_west_out(data_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column0),
    );

    wire [79:0] lc1_east_out;
    wire [79:0] lc1_west_out;
    LogicColumn lc1(
        .data_north_in(data_north_in[19:10]),
        .data_north_out(data_north_out[19:10]),
        .data_east_in(lc2_west_out),
        .data_east_out(lc1_east_out),
        .data_south_in(data_south_in[19:10]),
        .data_south_out(data_south_out[19:10]),
        .data_west_in(lc0_east_out),
        .data_west_out(lc1_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column1),
    );

    wire [79:0] lc2_east_out;
    wire [79:0] lc2_west_out;
    LogicColumn lc2(
        .data_north_in(data_north_in[29:20]),
        .data_north_out(data_north_out[29:20]),
        .data_east_in(lc3_west_out),
        .data_east_out(lc2_east_out),
        .data_south_in(data_south_in[29:20]),
        .data_south_out(data_south_out[29:20]),
        .data_west_in(lc1_east_out),
        .data_west_out(lc2_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column2),
    );

    wire [79:0] lc3_east_out;
    wire [79:0] lc3_west_out;
    LogicColumn lc3(
        .data_north_in(data_north_in[39:30]),
        .data_north_out(data_north_out[39:30]),
        .data_east_in(lc4_west_out),
        .data_east_out(lc3_east_out),
        .data_south_in(data_south_in[39:30]),
        .data_south_out(data_south_out[39:30]),
        .data_west_in(lc2_east_out),
        .data_west_out(lc3_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column3),
    );

    wire [79:0] lc4_east_out;
    wire [79:0] lc4_west_out;
    LogicColumn lc4(
        .data_north_in(data_north_in[49:40]),
        .data_north_out(data_north_out[49:40]),
        .data_east_in(lc5_west_out),
        .data_east_out(lc4_east_out),
        .data_south_in(data_south_in[49:40]),
        .data_south_out(data_south_out[49:40]),
        .data_west_in(lc3_east_out),
        .data_west_out(lc4_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column4),
    );

    wire [79:0] lc5_east_out;
    wire [79:0] lc5_west_out;
    LogicColumn lc5(
        .data_north_in(data_north_in[59:50]),
        .data_north_out(data_north_out[59:50]),
        .data_east_in(lc6_west_out),
        .data_east_out(lc5_east_out),
        .data_south_in(data_south_in[59:50]),
        .data_south_out(data_south_out[59:50]),
        .data_west_in(lc4_east_out),
        .data_west_out(lc5_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column5),
    );

    wire [79:0] lc6_east_out;
    wire [79:0] lc6_west_out;
    LogicColumn lc6(
        .data_north_in(data_north_in[69:60]),
        .data_north_out(data_north_out[69:60]),
        .data_east_in(lc7_west_out),
        .data_east_out(lc6_east_out),
        .data_south_in(data_south_in[69:60]),
        .data_south_out(data_south_out[69:60]),
        .data_west_in(lc5_east_out),
        .data_west_out(lc6_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column6),
    );

    
    wire [79:0] lc7_west_out;
    LogicColumn lc7(
        .data_north_in(data_north_in[79:70]),
        .data_north_out(data_north_out[79:70]),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in[79:70]),
        .data_south_out(data_south_out[79:70]),
        .data_west_in(lc6_east_out),
        .data_west_out(lc7_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column7),
    );


endmodule