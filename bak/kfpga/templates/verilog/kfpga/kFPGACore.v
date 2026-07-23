{% extends "verilog/base/Module.v" %}

{% block body %}
    genvar x, y;

    // North IO
    wire [{{ module.width - 1 }}:0] north_io_config_out;
    wire [{{ module.ic_pairs_count - 1}}:0] north_io_data_to_ic [{{ module.width - 1 }}:0];
    for (x = 0; x < {{ module.width }}; x = x + 1) begin
        wire iot_config_out;
        NorthIOTileTop iot(
            .data_from_io(data_north_in[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_to_io(data_north_out[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_from_ic(lt_north_out[{{ (module.height - 1) * module.width }} + x]),
            .data_to_ic(north_io_data_to_ic[x]),
            .config_in(lt_config_out[{{ module.height - 1 }}][x]),
            .config_out(north_io_config_out[x]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end

    // East IO
    wire [{{ module.height - 1 }}:0] east_io_config_out;
    wire [{{ module.ic_pairs_count - 1}}:0] east_io_data_to_ic [{{ module.height - 1 }}:0];
    for (y = 0; y < {{ module.height }}; y = y + 1) begin
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        EastIOTileTop iot(
            .data_from_io(data_east_in[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_to_io(data_east_out[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_from_ic(lt_east_out[{{ module.width }} * (y + 1) - 1]),
            .data_to_ic(east_io_data_to_ic[y]),
            .config_in(y == 0 ? north_io_config_out[{{ module.width - 1 }}] : east_io_config_out[y - 1]),
            .config_out(east_io_config_out[y]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end
    assign config_out = east_io_config_out[{{ module.height - 1 }}];

    // South IO
    wire [{{ module.width - 1 }}:0] south_io_config_out;
    wire [{{ module.ic_pairs_count - 1}}:0] south_io_data_to_ic [{{ module.width - 1 }}:0];
    for (x = 0; x < {{ module.width }}; x = x + 1) begin
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        SouthIOTileTop iot(
            .data_from_io(data_south_in[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_to_io(data_south_out[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_from_ic(lt_south_out[x]),
            .data_to_ic(south_io_data_to_ic[x]),
            .config_in(x == 0 ? east_io_config_out[{{ module.height - 1 }}] : north_io_config_out[x - 1]),
            .config_out(south_io_config_out[x]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end

    // West IO
    wire [{{ module.height - 1 }}:0] west_io_config_out;
    wire [{{ module.ic_pairs_count - 1}}:0] west_io_data_to_ic [{{ module.height - 1 }}:0];
    for (y = 0; y < {{ module.height }}; y = y + 1) begin
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        WestIOTileTop iot(
            .data_from_io(data_west_in[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_to_io(data_west_out[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_from_ic(lt_west_out[{{ module.width }} * y]),
            .data_to_ic(west_io_data_to_ic[y]),
            .config_in(y == 0 ? config_in : west_io_config_out[y - 1]),
            .config_out(west_io_config_out[y]),
            .config_clock(config_clock),
            .config_enable(config_enable),
            .config_nreset(config_nreset)
        );
    end

    // Logic tiles
    wire [{{ module.width - 1 }}:0] lt_config_out [{{ module.height - 1 }}:0];
    wire [{{ module.ic_pairs_count - 1}}:0] lt_north_out [{{ module.width * module.height - 1 }}:0];
    wire [{{ module.ic_pairs_count - 1}}:0] lt_east_out [{{ module.height * module.height - 1 }}:0];
    wire [{{ module.ic_pairs_count - 1}}:0] lt_south_out [{{ module.width * module.height - 1 }}:0];
    wire [{{ module.ic_pairs_count - 1}}:0] lt_west_out [{{ module.width * module.height - 1 }}:0];
    for (y = 0; y < {{ module.height }}; y = y + 1) begin
        for (x = 0; x < {{ module.width }}; x = x + 1) begin
            LogicTileTop lt(
                .data_north_in(y == {{ module.height - 1 }} ? north_io_data_to_ic[x] : lt_south_out[(y + 1) * {{ module.width }} + x]),
                .data_north_out(lt_north_out[y * {{ module.height }} + x]),
                .data_east_in(x == {{ module.width - 1 }} ? east_io_data_to_ic[y] : lt_west_out[y * {{ module .width }} + x + 1]),
                .data_east_out(lt_east_out[y * {{ module.height }} + x]),
                .data_south_in(y == 0 ? south_io_data_to_ic[x] : lt_north_out[(y - 1) * {{ module.width }} + x]),
                .data_south_out(lt_south_out[y * {{ module.height }} + x]),
                .data_west_in(x == 0 ? west_io_data_to_ic[y] : lt_east_out[y * {{ module.width }} + x - 1]),
                .data_west_out(lt_west_out[y * {{ module.height }} + x]),
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
{% endblock  %}