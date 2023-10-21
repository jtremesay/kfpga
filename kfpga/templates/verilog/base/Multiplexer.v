{% extends "verilog/base/Module.v" %}
{% block body %}
    // Synthesizer is probably better than me to infer the best mux
    assign data_out = config_in < {{ module.size }} ? data_in[c_selector] : 0;
{%- endblock  %}