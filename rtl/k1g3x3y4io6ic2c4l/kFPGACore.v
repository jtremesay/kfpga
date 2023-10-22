module kFPGACore(
    input config_in,
    output config_out,
    input config_clock,
    input config_enable,
    input config_nreset,
    input clock,
    input nreset,
    input enable,
    input [11:0] data_north_in,
    output [11:0] data_north_out,
    input [11:0] data_east_in,
    output [11:0] data_east_out,
    input [11:0] data_south_in,
    output [11:0] data_south_out,
    input [11:0] data_west_in,
    output [11:0] data_west_out
);
    genvar x, y;

    // North IO
    wire [2:0] north_io_config_out;
    wire [5:0] north_io_data_to_ic [2:0];
    for (x = 0; x < 3; x = x + 1) begin
        wire iot_config_out;
        NorthIOTileTop iot(
            .data_from_io(data_north_in[(x + 1) * 4 - 1:x * 4]),
            .data_to_io(data_north_out[(x + 1) * 4 - 1:x * 4]),
            .data_from_ic(lt_north_out[6 + x]),
            .data_to_ic(north_io_data_to_ic[x]),
            .config_in(lt_config_out[2][x]),
            .config_out(north_io_config_out[x]),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // East IO
    wire [2:0] east_io_config_out;
    wire [5:0] east_io_data_to_ic [2:0];
    for (y = 0; y < 3; y = y + 1) begin
        wire iot_config_out;
        wire [5:0] iot_data_to_ic;
        EastIOTileTop iot(
            .data_from_io(data_east_in[(y + 1) * 4 - 1:y * 4]),
            .data_to_io(data_east_out[(y + 1) * 4 - 1:y * 4]),
            .data_from_ic(lt_east_out[3 * (y + 1) - 1]),
            .data_to_ic(east_io_data_to_ic[y]),
            .config_in(y == 0 ? north_io_config_out[2] : east_io_config_out[y - 1]),
            .config_out(east_io_config_out[y]),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end
    assign config_out = east_io_config_out[2];

    // South IO
    wire [2:0] south_io_config_out;
    wire [5:0] south_io_data_to_ic [2:0];
    for (x = 0; x < 3; x = x + 1) begin
        wire iot_config_out;
        wire [5:0] iot_data_to_ic;
        SouthIOTileTop iot(
            .data_from_io(data_south_in[(x + 1) * 4 - 1:x * 4]),
            .data_to_io(data_south_out[(x + 1) * 4 - 1:x * 4]),
            .data_from_ic(lt_south_out[x]),
            .data_to_ic(south_io_data_to_ic[x]),
            .config_in(x == 0 ? east_io_config_out[2] : north_io_config_out[x - 1]),
            .config_out(south_io_config_out[x]),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // West IO
    wire [2:0] west_io_config_out;
    wire [5:0] west_io_data_to_ic [2:0];
    for (y = 0; y < 3; y = y + 1) begin
        wire iot_config_out;
        wire [5:0] iot_data_to_ic;
        WestIOTileTop iot(
            .data_from_io(data_west_in[(y + 1) * 4 - 1:y * 4]),
            .data_to_io(data_west_out[(y + 1) * 4 - 1:y * 4]),
            .data_from_ic(lt_west_out[3 * y]),
            .data_to_ic(west_io_data_to_ic[y]),
            .config_in(y == 0 ? config_in : west_io_config_out[y - 1]),
            .config_out(west_io_config_out[y]),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // Logic tiles
    wire [2:0] lt_config_out [2:0];
    wire [5:0] lt_north_out [8:0];
    wire [5:0] lt_east_out [8:0];
    wire [5:0] lt_south_out [8:0];
    wire [5:0] lt_west_out [8:0];
    for (y = 0; y < 3; y = y + 1) begin
        for (x = 0; x < 3; x = x + 1) begin
            LogicTileTop lt(
                .data_north_in(y == 2 ? north_io_data_to_ic[x] : lt_south_out[(y + 1) * 3 + x]),
                .data_north_out(lt_north_out[y * 3 + x]),
                .data_east_in(x == 2 ? east_io_data_to_ic[y] : lt_west_out[y * 3 + x + 1]),
                .data_east_out(lt_east_out[y * 3 + x]),
                .data_south_in(y == 0 ? south_io_data_to_ic[x] : lt_north_out[(y - 1) * 3 + x]),
                .data_south_out(lt_south_out[y * 3 + x]),
                .data_west_in(x == 0 ? west_io_data_to_ic[y] : lt_east_out[y * 3 + x - 1]),
                .data_west_out(lt_west_out[y * 3 + x]),
                .clock(clock),
                .nreset(nreset),
                .enable(enable),
                .config_in(y == 0 ? south_io_config_out[x] : lt_config_out[(y - 1) * 3 + x]),
                .config_out(lt_config_out[y][x]),
                .config_clock(config_clock),
                .config_enable(config_nreset),
                .config_nreset(config_nreset)
            );
        end
    end

endmodule