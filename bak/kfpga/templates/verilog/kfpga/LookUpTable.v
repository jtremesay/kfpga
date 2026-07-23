{% extends "verilog/base/Module.v" %}
{% block body %}
    // Implement the LUT with a mux
    MultiplexerLUT lut(
        .data_in(c_truth_table),
        .data_out(data_out),
        .config_in(data_in)
    );
{%- endblock  %}