{% extends "verilog/base/Module.v" %}

{% block body %}
    // IC
    {% for i in range(module.interconnect_pairs_count) %}
    Multiplexer{{ module.io_pairs_count }} mux_ic{{ i }}(
        .data_in(data_from_io),
        .data_out(data_to_ic[{{ i }}]),
        .config_in(c_mux_ic{{ i }})
    );
    {% endfor %}

    // IO
    {% for i in range(module.io_pairs_count) %}
    Multiplexer{{ module.interconnect_pairs_count }} mux_io{{ i }}(
        .data_in(data_from_ic),
        .data_out(data_to_io[{{ i }}]),
        .config_in(c_mux_io{{ i }})
    );
    {% endfor %}
{% endblock  %}