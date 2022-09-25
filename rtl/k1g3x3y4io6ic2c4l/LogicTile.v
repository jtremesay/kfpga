module LogicTile(
    input [5:0] data_north_in,
    output [5:0] data_north_out,
    input [5:0] data_east_in,
    output [5:0] data_east_out,
    input [5:0] data_south_in,
    output [5:0] data_south_out,
    input [5:0] data_west_in,
    output [5:0] data_west_out,
    input clock,
    input nreset,
    input [193:0] config_in
);
    // Dispatch the config 
    wire [16:0] c_le0 = config_in[16:0]; 
    wire [16:0] c_le1 = config_in[33:17]; 
    wire [159:0] c_switchbox = config_in[193:34];

    // Connection used between the logic element and the switchbox
    wire [7:0] w_to_les;
    wire [1:0] w_from_les;

    // Instantiate the switchbox
    SwitchBox sb(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_west_in(data_west_in),
        .data_west_out(data_west_out),
        .data_from_les(w_from_les),
        .data_to_les(w_to_les),
        .config_in(c_switchbox)
    );

    // Instantiate the logic elemenets
    LogicElement el0(
        .data_in(w_to_les[3:0]),
        .data_out(w_from_les[0]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_le0)
    );

    LogicElement el1(
        .data_in(w_to_les[7:4]),
        .data_out(w_from_les[1]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_le1)
    );

endmodule