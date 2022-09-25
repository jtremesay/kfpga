module kFPGACore(
    input [31:0] data_north_in,
    output [31:0] data_north_out,
    input [31:0] data_east_in,
    output [31:0] data_east_out,
    input [31:0] data_south_in,
    output [31:0] data_south_out,
    input [31:0] data_west_in,
    output [31:0] data_west_out,
    input clock,
    input nreset,
    input [42367:0] config_in
);
    // Dispatch the config 
    wire [287:0] c_io_north = config_in[287:0]; 
    wire [287:0] c_io_east = config_in[575:288]; 
    wire [287:0] c_io_south = config_in[863:576]; 
    wire [287:0] c_io_west = config_in[1151:864]; 
    wire [41215:0] c_grid = config_in[42367:1152];

    // Declare the data wire used by the grid 
    wire [79:0] grid_north_in;
    wire [79:0] grid_north_out;
    wire [79:0] grid_east_in;
    wire [79:0] grid_east_out;
    wire [79:0] grid_south_in;
    wire [79:0] grid_south_out;
    wire [79:0] grid_west_in;
    wire [79:0] grid_west_out;

    // Instantiate the IO ports
    IOLine iol_north(
        .data_from_io(data_north_in),
        .data_to_io(data_north_out),
        .data_from_ic(grid_north_out),
        .data_to_ic(grid_north_in),
    );

    IOColumn ioc_east(
        .data_from_io(data_east_in),
        .data_to_io(data_east_out),
        .data_from_ic(grid_east_out),
        .data_to_ic(grid_east_in),
    );

    IOLine iol_south(
        .data_from_io(data_south_in),
        .data_to_io(data_south_out),
        .data_from_ic(grid_south_out),
        .data_to_ic(grid_south_in),
    );

    IOColumn ioc_west(
        .data_from_io(data_west_in),
        .data_to_io(data_west_out),
        .data_from_ic(grid_west_out),
        .data_to_ic(grid_west_in),
    );

    // Instantiate the grid
    LogicGrid grid(
        .data_north_in(grid_north_in),
        .data_north_out(grid_north_out),
        .data_east_in(grid_east_in),
        .data_east_out(grid_east_out),
        .data_south_in(grid_south_in),
        .data_south_out(grid_south_out),
        .data_west_in(grid_west_in),
        .data_west_out(grid_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_grid)
    );

endmodule