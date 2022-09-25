{% extends "verilog/base/Module.v" %}

{% block body %}
    // Declare the data wire used by the grid 
    wire [{{ module.interconnect_pairs_count * module.width -1 }}:0] grid_north_in;
    wire [{{ module.interconnect_pairs_count * module.width -1 }}:0] grid_north_out;
    wire [{{ module.interconnect_pairs_count * module.height -1 }}:0] grid_east_in;
    wire [{{ module.interconnect_pairs_count * module.height -1 }}:0] grid_east_out;
    wire [{{ module.interconnect_pairs_count * module.width -1 }}:0] grid_south_in;
    wire [{{ module.interconnect_pairs_count * module.width -1 }}:0] grid_south_out;
    wire [{{ module.interconnect_pairs_count * module.height -1 }}:0] grid_west_in;
    wire [{{ module.interconnect_pairs_count * module.height -1 }}:0] grid_west_out;

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
{% endblock  %}