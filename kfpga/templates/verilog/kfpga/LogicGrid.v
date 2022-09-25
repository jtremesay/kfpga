{% extends "verilog/base/Module.v" %}

{% block body %}
    // Instantiate the columns
{%- for x in range(width) %}
    {% if x < width - 1 %}wire [{{ interconnect_pairs_count * height - 1 }}:0] lc{{ x }}_east_out;{% endif %}
    {% if x > 0 %}wire [{{ interconnect_pairs_count * height  - 1 }}:0] lc{{ x }}_west_out;{% endif %}
    LogicColumn lc{{ x }}(
        .data_north_in(data_north_in[{{ (x + 1) * interconnect_pairs_count - 1 }}:{{ x * interconnect_pairs_count }}]),
        .data_north_out(data_north_out[{{ (x + 1) * interconnect_pairs_count - 1 }}:{{ x * interconnect_pairs_count }}]),
        .data_east_in({% if x == width - 1%}data_east_in{% else %}lc{{ x + 1 }}_west_out{% endif %}),
        .data_east_out({% if x == width - 1%}data_east_out{% else %}lc{{ x }}_east_out{% endif %}),
        .data_south_in(data_south_in[{{ (x + 1) * interconnect_pairs_count - 1 }}:{{ x * interconnect_pairs_count }}]),
        .data_south_out(data_south_out[{{ (x + 1) * interconnect_pairs_count - 1 }}:{{ x * interconnect_pairs_count }}]),
        .data_west_in({% if x == 0 %}data_west_in{% else %}lc{{ x - 1 }}_east_out{% endif %}),
        .data_west_out({% if x == 0 %}data_west_out{% else %}lc{{ x }}_west_out{% endif %}),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_column{{ x }}),
    );
{% endfor %}
{% endblock  %}