module kFPGACore(
    input config_in,
    output config_out,
    input config_clock,
    input config_enable,
    input config_nreset,
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
    output [1:0] data_west_out
);
    genvar x, y;

    // North IO
    wire [0:0] north_io_config_out;
    wire [1:0] north_io_data_to_ic [0:0];
    for (x = 0; x < 1; x = x + 1) begin
        wire iot_config_out;
        NorthIOTileTop iot(
            .data_from_io(data_north_in[(x + 1) * 2 - 1:x * 2]),
            .data_to_io(data_north_out[(x + 1) * 2 - 1:x * 2]),
            .data_from_ic(lt_north_out[0 + x]),
            .data_to_ic(north_io_data_to_ic[x]),
            .config_in(lt_config_out[0][x]),
            .config_out(north_io_config_out[x]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end

    // East IO
    wire [0:0] east_io_config_out;
    wire [1:0] east_io_data_to_ic [0:0];
    for (y = 0; y < 1; y = y + 1) begin
        wire iot_config_out;
        wire [1:0] iot_data_to_ic;
        EastIOTileTop iot(
            .data_from_io(data_east_in[(y + 1) * 2 - 1:y * 2]),
            .data_to_io(data_east_out[(y + 1) * 2 - 1:y * 2]),
            .data_from_ic(lt_east_out[1 * (y + 1) - 1]),
            .data_to_ic(east_io_data_to_ic[y]),
            .config_in(y == 0 ? north_io_config_out[0] : east_io_config_out[y - 1]),
            .config_out(east_io_config_out[y]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end
    assign config_out = east_io_config_out[0];

    // South IO
    wire [0:0] south_io_config_out;
    wire [1:0] south_io_data_to_ic [0:0];
    for (x = 0; x < 1; x = x + 1) begin
        wire iot_config_out;
        wire [1:0] iot_data_to_ic;
        SouthIOTileTop iot(
            .data_from_io(data_south_in[(x + 1) * 2 - 1:x * 2]),
            .data_to_io(data_south_out[(x + 1) * 2 - 1:x * 2]),
            .data_from_ic(lt_south_out[x]),
            .data_to_ic(south_io_data_to_ic[x]),
            .config_in(x == 0 ? east_io_config_out[0] : north_io_config_out[x - 1]),
            .config_out(south_io_config_out[x]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end

    // West IO
    wire [0:0] west_io_config_out;
    wire [1:0] west_io_data_to_ic [0:0];
    for (y = 0; y < 1; y = y + 1) begin
        wire iot_config_out;
        wire [1:0] iot_data_to_ic;
        WestIOTileTop iot(
            .data_from_io(data_west_in[(y + 1) * 2 - 1:y * 2]),
            .data_to_io(data_west_out[(y + 1) * 2 - 1:y * 2]),
            .data_from_ic(lt_west_out[1 * y]),
            .data_to_ic(west_io_data_to_ic[y]),
            .config_in(y == 0 ? config_in : west_io_config_out[y - 1]),
            .config_out(west_io_config_out[y]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end

    // Logic tiles
    wire [0:0] lt_config_out [0:0];
    wire [1:0] lt_north_out [0:0];
    wire [1:0] lt_east_out [0:0];
    wire [1:0] lt_south_out [0:0];
    wire [1:0] lt_west_out [0:0];
    for (y = 0; y < 1; y = y + 1) begin
        for (x = 0; x < 1; x = x + 1) begin
            LogicTileTop lt(
                .data_north_in(y == 0 ? north_io_data_to_ic[x] : lt_south_out[(y + 1) * 1 + x]),
                .data_north_out(lt_north_out[y * 1 + x]),
                .data_east_in(x == 0 ? east_io_data_to_ic[y] : lt_west_out[y * 1 + x + 1]),
                .data_east_out(lt_east_out[y * 1 + x]),
                .data_south_in(y == 0 ? south_io_data_to_ic[x] : lt_north_out[(y - 1) * 1 + x]),
                .data_south_out(lt_south_out[y * 1 + x]),
                .data_west_in(x == 0 ? west_io_data_to_ic[y] : lt_east_out[y * 1 + x - 1]),
                .data_west_out(lt_west_out[y * 1 + x]),
                .clock(clock),
                .nreset(nreset),
                .enable(enable),
                .config_in(y == 0 ? south_io_config_out[x] : lt_config_out[y - 1][x]),
                .config_out(lt_config_out[y][x]),
                .config_clock(config_clock),
                .config_enable(config_enable),
                .config_nreset(config_nreset)
            );
        end
    end

endmodule