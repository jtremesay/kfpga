module SouthIOTileTop(
    input config_in,
    output config_out,
    input config_clock,
    input config_enable,
    input config_nreset,
    input [3:0] data_from_io,
    output [3:0] data_to_io,
    input [5:0] data_from_ic,
    output [5:0] data_to_ic
);
    // Instantiate the config shift register
    wire [23:0] config_data;
    IOTileConfig config_sr(
        .data_in(config_in),
        .data_out(config_data),
        .clock(config_clock),
        .enable(config_enable),
        .nreset(config_nreset),
    );
    assign config_out = config_data[23];

    IOTile iot(
        .data_from_io(data_from_io),
        .data_to_io(data_to_io),
        .data_from_ic(data_from_ic),
        .data_to_ic(data_to_ic),
        .config_in(config_data),
    );
endmodule