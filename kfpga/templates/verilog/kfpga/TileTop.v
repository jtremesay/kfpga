{% extends "verilog/base/Module.v" %}

{% block body %}
    // Instantiate the config shift register
    wire [{{ module.csr.width - 1 }}:0] config_data;
    {{ module.csr.name }} config_sr(
        .data_in(config_in),
        .data_out(config_data),
        .clock(config_clock),
        .enable(config_enable),
        .nreset(config_nreset),
    );
    assign config_out = config_data[{{ module.csr.width - 1 }}];
{% block subbody %}{% endblock %}
{%- endblock  %}