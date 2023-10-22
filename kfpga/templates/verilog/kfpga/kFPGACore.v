{% extends "verilog/base/Module.v" %}

{% block body %}
    genvar x, y;

    // North IO
    for (x = 0; x < {{ module.width }}; x = x + 1) begin : north_io
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        NorthIOTileTop iot(
            .data_from_io(data_north_in[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_to_io(data_north_out[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_from_ic(ltl[{{ module.height - 1 }}].ltc[x].lt_north_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(ltl[{{ module.height - 1 }}].ltc[x].lt_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // East IO
    for (y = 0; y < {{ module.height }}; y = y + 1) begin : east_io
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        EastIOTileTop iot(
            .data_from_io(data_east_in[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_to_io(data_east_out[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_from_ic(ltl[y].ltc[{{ module.width - 1 }}].lt_east_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(y == 0 ? north_io[{{ module.width -1 }}].iot_config_out : east_io[y - 1].iot_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end
    assign config_out = east_io[{{ module.height -1 }}].iot_config_out;

    // South IO
    for (x = 0; x < {{ module.width }}; x = x + 1) begin : south_io
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        SouthIOTileTop iot(
            .data_from_io(data_south_in[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_to_io(data_south_out[(x + 1) * {{ module.io_pairs_count }} - 1:x * {{ module.io_pairs_count }}]),
            .data_from_ic(ltl[0].ltc[x].lt_south_out),
            .data_to_ic(iot_data_to_ic),
            .config_in(x == 0 ? west_io[{{ module.height - 1}}].iot_config_out : north_io[x - 1].iot_config_out),
            .config_out(iot_config_out),
            .config_clock(config_clock),
            .config_enable(config_nreset),
            .config_nreset(config_nreset)
        );
    end

    // West IO
    for (y = 0; y < {{ module.height }}; y = y + 1) begin : west_io
        wire iot_config_out;
        wire [{{ module.ic_pairs_count - 1}}:0] iot_data_to_ic;
        WestIOTileTop iot(
            .data_from_io(data_west_in[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
            .data_to_io(data_west_out[(y + 1) * {{ module.io_pairs_count }} - 1:y * {{ module.io_pairs_count }}]),
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
    for (y = 0; y < {{ module.height }}; y = y + 1) begin : ltl
        for (x = 0; x < {{ module.width }}; x = x + 1) begin : ltc
            wire lt_config_out;
            wire [{{ module.ic_pairs_count - 1}}:0] lt_north_out;
            wire [{{ module.ic_pairs_count - 1}}:0] lt_east_out;
            wire [{{ module.ic_pairs_count - 1}}:0] lt_south_out;
            wire [{{ module.ic_pairs_count - 1}}:0] lt_west_out;
            LogicTileTop lt(
                .data_north_in(y == {{ module.height - 1}} ? north_io[x].iot_data_to_ic : ltl[y + 1].ltc[x].lt_south_out),
                .data_north_out(lt_north_out),
                .data_east_in(x == {{ module.width - 1}} ? east_io[y].iot_data_to_ic : ltl[y].ltc[x + 1].lt_west_out),
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
{% endblock  %}