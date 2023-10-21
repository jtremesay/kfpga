module LogicTileTop(
    input config_in,
    output config_out,
    input config_enable,
    input config_nreset,
    input [5:0] data_north_in,
    output [5:0] data_north_out,
    input [5:0] data_east_in,
    output [5:0] data_east_out,
    input [5:0] data_south_in,
    output [5:0] data_south_out,
    input [5:0] data_west_in,
    output [5:0] data_west_out,
    input clock,
    input nreset
);
    // Instantiate the config shift register
    wire [145:0] config_data;
    LogicTileConfig config_sr(
        .data_in(config_in),
        .data_out(config_data),
        .clock(clock),
        .enable(config_enable),
        .nreset(config_nreset),
    );
    assign config_out = config_data[145];

    LogicTile lt(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_west_in(data_west_in),
        .data_west_out(data_west_out),
        .clock(clock),
        .nreset(nreset),
        .config_in(config_data),
    );
endmodule