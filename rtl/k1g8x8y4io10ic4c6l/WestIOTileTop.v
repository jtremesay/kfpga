module WestIOTileTop(
    input config_in,
    output config_out,
    input config_enable,
    input config_nreset,
    input clock,
    input nreset,
    input enable,
    input [3:0] data_from_io,
    output [3:0] data_to_io,
    input [9:0] data_from_ic,
    output [9:0] data_to_ic
);
    // Instantiate the config shift register
    wire [35:0] config_data;
    IOTileConfig config_sr(
        .data_in(config_in),
        .data_out(config_data),
        .clock(clock),
        .enable(config_enable),
        .nreset(config_nreset),
    );
    assign config_out = config_data[35];

    IOTile iot(
        .data_from_io(data_from_io),
        .data_to_io(data_to_io),
        .data_from_ic(data_from_ic),
        .data_to_ic(data_to_ic),
        .config_in(config_data),
    );
endmodule