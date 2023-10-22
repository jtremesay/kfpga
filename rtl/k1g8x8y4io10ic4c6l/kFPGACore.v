module kFPGACore(
    input config_in,
    output config_out,
    input config_clock,
    input config_enable,
    input config_nreset,
    input clock,
    input nreset,
    input enable,
    input [31:0] data_north_in,
    output [31:0] data_north_out,
    input [31:0] data_east_in,
    output [31:0] data_east_out,
    input [31:0] data_south_in,
    output [31:0] data_south_out,
    input [31:0] data_west_in,
    output [31:0] data_west_out
);
    genvar x, y;

    // North IO
    for (x = 0; x < 8; x = x + 1) begin : north_io
        wire iot_config_out;
        wire [9:0] iot_data_to_ic;
        NorthIOTileTop iot(
            .data_from_io(data_north_in[(x + 1) * 4 - 1:x * 4]),
            .data_to_io(data_north_out[(x + 1) * 4 - 1:x * 4]),
            .data_from_ic(ltl[7].ltc[x].lt_north_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(ltl[7].ltc[x].lt_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // East IO
    for (y = 0; y < 8; y = y + 1) begin : east_io
        wire iot_config_out;
        wire [9:0] iot_data_to_ic;
        EastIOTileTop iot(
            .data_from_io(data_east_in[(y + 1) * 4 - 1:y * 4]),
            .data_to_io(data_east_out[(y + 1) * 4 - 1:y * 4]),
            .data_from_ic(ltl[y].ltc[7].lt_east_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(y == 0 ? north_io[7].iot_config_out : east_io[y - 1].iot_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end
    assign config_out = east_io[7].iot_config_out;

    // South IO
    for (x = 0; x < 8; x = x + 1) begin : south_io
        wire iot_config_out;
        wire [9:0] iot_data_to_ic;
        SouthIOTileTop iot(
            .data_from_io(data_south_in[(x + 1) * 4 - 1:x * 4]),
            .data_to_io(data_south_out[(x + 1) * 4 - 1:x * 4]),
            .data_from_ic(ltl[0].ltc[x].lt_south_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(x == 0 ? west_io[7].iot_config_out : north_io[x - 1].iot_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // West IO
    for (y = 0; y < 8; y = y + 1) begin : west_io
        wire iot_config_out;
        wire [9:0] iot_data_to_ic;
        WestIOTileTop iot(
            .data_from_io(data_west_in[(y + 1) * 4 - 1:y * 4]),
            .data_to_io(data_west_out[(y + 1) * 4 - 1:y * 4]),
            .data_from_ic(ltl[y].ltc[0].lt_west_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(y == 0 ? config_in : west_io[y - 1].iot_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // Logic tiles
    for (y = 0; y < 8; y = y + 1) begin : ltl
        for (x = 0; x < 8; x = x + 1) begin : ltc
            wire lt_config_out;
            wire [9:0] lt_north_out;
            wire [9:0] lt_east_out;
            wire [9:0] lt_south_out;
            wire [9:0] lt_west_out;
            LogicTileTop lt(
                .data_north_in(y == 7 ? north_io[x].iot_data_to_ic : ltl[y + 1].ltc[x].lt_south_out),
                .data_north_out(lt_north_out),
                .data_east_in(x == 7 ? east_io[y].iot_data_to_ic : ltl[y].ltc[x + 1].lt_west_out),
                .data_east_out(lt_east_out),
                .data_south_in(y == 0 ? south_io[x].iot_data_to_ic : ltl[y - 1].ltc[x].lt_north_out),
                .data_south_out(lt_south_out),
                .data_west_in(x == 0 ? west_io[y].iot_data_to_ic : ltl[y].ltc[x - 1].lt_east_out),
                .data_west_out(lt_west_out),
                .clock(clock),
                .nreset(nreset),
                .enable(enable),
                .config_in(y == 0 ? south_io[x].iot_config_out : ltl[y -1].ltc[x].lt_config_out),
                .config_out(lt_config_out),
                .config_clock(config_clock),
                .config_enable(config_nreset),
                .config_nreset(config_nreset)
            );
        end
    end

endmodule