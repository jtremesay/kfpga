{% extends "verilog/base/Module.v" %}

{% block body %}
    // Use Wilton switchbox
    // https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.4925&rep=rep1&type=pdf
    // 6.1.2: Logic Resources, p103

    // Side north
    {% for i in range(module.interconnect_pairs_count) %}
    wire [{{ 3 + module.cluster_size - 1 }}:0] w_inputs_for_north{{ i }} = {
        data_west_in[{{ (i + 1) % module.interconnect_pairs_count }}],
        data_south_in[{{ i }}], 
        data_east_in[{{ (module.interconnect_pairs_count - i) % module.interconnect_pairs_count }}],
        data_from_les
    };
    MultiplexerSBIC mux_north{{ i }}(
        .data_in(w_inputs_for_north{{ i }}),
        .data_out(data_north_out[{{ i }}]),
        .config_in(c_mux_north{{ i }})
    );
    {% endfor %}

    // Side east
    {% for i in range(module.interconnect_pairs_count) %}
    wire [{{3 + module.cluster_size - 1}}:0] w_inputs_for_east{{ i }} = {
        data_north_in[{{ (module.interconnect_pairs_count - i) % module.interconnect_pairs_count }}],
        data_west_in[{{ i }}],
        data_south_in[{{ (i + 1) % module.interconnect_pairs_count }}],
        data_from_les
    };
    MultiplexerSBIC mux_east{{ i }}(
        .data_in(w_inputs_for_east{{ i }}),
        .data_out(data_east_out[{{ i }}]),
        .config_in(c_mux_east{{ i }})
    );
    {% endfor %}

    // Side south
    {% for i in range(module.interconnect_pairs_count) %}
    wire [{{3 + module.cluster_size - 1}}:0] w_inputs_for_south{{ i }} = {
        data_east_in[{{ (i + 1) % module.interconnect_pairs_count }}],
        data_north_in[{{ i }}],
        data_west_in[{{ (2 * module.interconnect_pairs_count - 2 - i) % module.interconnect_pairs_count }}],
        data_from_les
    };
    MultiplexerSBIC mux_south{{ i }}(
        .data_in(w_inputs_for_south{{ i }}),
        .data_out(data_south_out[{{ i }}]),
        .config_in(c_mux_south{{ i }})
    );
    {% endfor %}

    // Side west
    {% for i in range(module.interconnect_pairs_count) %}
    wire [{{3 + module.cluster_size - 1}}:0] w_inputs_for_west{{ i }} = {
        data_south_in[{{ (2 * module.interconnect_pairs_count - 2 - i) % module.interconnect_pairs_count }}],
        data_east_in[{{ i }}],
        data_north_in[{{ (i + 1) % module.interconnect_pairs_count }}],
        data_from_les
    };
    MultiplexerSBIC mux_west{{ i }}(
        .data_in(w_inputs_for_west{{ i }}),
        .data_out(data_west_out[{{ i }}]),
        .config_in(c_mux_west{{ i }})
    );
    {% endfor %}

    // Le 
    wire [{{ module.interconnect_pairs_count * 4 + module.cluster_size - 1}}:0] w_inputs_for_les = { {%- for sside in ("north", "east", "south", "west") %}data_{{ sside }}_in, {% endfor %}data_from_les};
    {% for c in range(module.cluster_size) %}{% for i in range(module.lut_size) %}
    MultiplexerSBLE mux_le{{ c }}_i{{ i }}(
        .data_in(w_inputs_for_les),
        .data_out(data_to_les[{{ c * module.lut_size + i }}]),
        .config_in(c_mux_le{{ c }}_i{{ i}})
    );
    {% endfor %}{% endfor%}
{% endblock  %}