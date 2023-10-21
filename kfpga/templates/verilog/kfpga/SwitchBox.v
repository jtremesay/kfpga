{% extends "verilog/base/Module.v" %}

{% block body %}
    // Use Wilton switchbox
    // https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.4925&rep=rep1&type=pdf
    // 6.1.2: Logic Resources, p103

    // Side north
    genvar i, j;
    for (i = 0; i < {{ module.interconnect_pairs_count}}; i = i + 1 ) begin
        MultiplexerSBIC mux_north(
            .data_in({
                data_west_in[(i + 1) % {{ module.interconnect_pairs_count }}],
                data_south_in[ i ], 
                data_east_in[({{ module.interconnect_pairs_count }} - i) % {{ module.interconnect_pairs_count }}],
                data_from_les
            }),
            .data_out(data_north_out[i]),
            .config_in(c_muxes_north[i])
        );
    end

    // Side east
    for (i = 0; i < {{ module.interconnect_pairs_count}}; i = i + 1 ) begin
        MultiplexerSBIC mux_east(
            .data_in({
                data_north_in[({{ module.interconnect_pairs_count }} - i) % {{ module.interconnect_pairs_count }}],
                data_west_in[i],
                data_south_in[(i + 1) % {{ module.interconnect_pairs_count }}],
                data_from_les
            }),
            .data_out(data_east_out[i]),
            .config_in(c_muxes_north[i])
        );
    end

    // Side south
    for (i = 0; i < {{ module.interconnect_pairs_count}}; i = i + 1 ) begin
        MultiplexerSBIC mux_south(
            .data_in({
                data_east_in[({{ i }} + 1) % {{ module.interconnect_pairs_count }}],
                data_north_in[i],
                data_west_in[({{ 2 *  module.interconnect_pairs_count - 2 }} - i) % {{ module.interconnect_pairs_count }}],
                data_from_les
            }),
            .data_out(data_south_out[i]),
            .config_in(c_muxes_south[i])
        );
    end

    // Side west
    for (i = 0; i < {{ module.interconnect_pairs_count}}; i = i + 1 ) begin
        MultiplexerSBIC mux_west(
            .data_in({
                data_south_in[({{ 2 * module.interconnect_pairs_count - 2 }} - i) % {{ module.interconnect_pairs_count }}],
                data_east_in[i],
                data_north_in[(i + 1) % {{ module.interconnect_pairs_count }}],
                data_from_les
            }),
            .data_out(data_west_out[i]),
            .config_in(c_muxes_west[i])
        );
    end

    // Le 
    for (i = 0; i < {{ module.cluster_size }}; i = i + 1) begin
        for (j = 0; j < {{ module.lut_size }}; j = j + 1 ) begin
            MultiplexerSBLE mux_le(
                .data_in({ 
                    data_north_in,
                    data_east_in,
                    data_south_in,
                    data_west_in,
                    data_from_les
                }),
                .data_out(data_to_les[i * {{ module.lut_size }} + j]),
                .config_in(c_muxes_les[i][j])
            );
        end
    end
{% endblock  %}