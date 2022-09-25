{% extends "verilog/base/Module.v" %}

{% block body %}
    {% for side in ("north", "east", "south", "west") %}
    // Side {{ side }}
    wire [{{ module.interconnect_pairs_count * 3 + module.cluster_size - 1}}:0] w_inputs_for_{{ side }} = { {%- for sside in ("north", "east", "south", "west") if sside != side %}data_{{ sside }}_in, {% endfor %}data_from_les};
    {% for i in range(module.interconnect_pairs_count) %}
    MultiplexerSBIC mux_{{ side }}{{ i }}(
        .data_in(w_inputs_for_{{ side }}),
        .data_out(data_{{ side }}_out[{{ i }}]),
        .config_in(c_mux_{{ side }}{{ i }})
    );
    {% endfor %}
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