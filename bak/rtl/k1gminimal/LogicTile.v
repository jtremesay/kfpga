module LogicTile(
    input clock,
    input nreset,
    input enable,
    input [1:0] data_north_in,
    output [1:0] data_north_out,
    input [1:0] data_east_in,
    output [1:0] data_east_out,
    input [1:0] data_south_in,
    output [1:0] data_south_out,
    input [1:0] data_west_in,
    output [1:0] data_west_out,
    input [28:0] config_in
);
    // Dispatch the config 
    wire [4:0] c_les = config_in[4:0]; 
    wire [23:0] c_switchbox = config_in[28:5];

    // Connection used between the logic element and the switchbox
    wire [1:0] w_to_les;
    wire [0:0] w_from_les;

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
    genvar i;
    for (i = 0; i < 1; i = i + 1) begin
        LogicElement el(
            .data_in(w_to_les[(i + 1) * 2 - 1:i * 2]),
            .data_out(w_from_les[i]),
            .clock(clock),
            .nreset(nreset),
            .enable(enable),
            .config_in(c_les)
        );
    end
endmodule