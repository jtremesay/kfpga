{% extends "verilog/base/Module.v" %}

{% block body %}
    // Instantiate the tiles
{%- for y in range(height) %}
    {% if y < height - 1 %}wire [{{ interconnect_pairs_count - 1 }}:0] lt{{ y }}_north_out;{% endif %}
    {% if y > 0 %}wire [{{ interconnect_pairs_count - 1 }}:0] lt{{ y }}_south_out;{% endif %}
    LogicTile lt{{ y }}(
        .data_north_in({% if y == height -1 %}data_north_in{% else %}lt{{ y + 1 }}_south_out{% endif %}),
        .data_north_out({% if y == height -1 %}data_north_out{% else %}lt{{ y }}_north_out{% endif %}),
        .data_east_in(data_east_in[{{ (y + 1) * interconnect_pairs_count - 1 }}:{{ y * interconnect_pairs_count }}]),
        .data_east_out(data_east_out[{{ (y + 1) * interconnect_pairs_count - 1 }}:{{ y * interconnect_pairs_count }}]),
        .data_south_in({% if y == 0 %}data_south_in{% else %}lt{{ y - 1 }}_north_out{% endif %}),
        .data_south_out({% if y == 0 %}data_south_out{% else %}lt{{ y }}_south_out{% endif %}),
        .data_west_in(data_west_in[{{ (y + 1) * interconnect_pairs_count - 1 }}:{{ y * interconnect_pairs_count }}]),
        .data_west_out(data_west_out[{{ (y + 1) * interconnect_pairs_count - 1 }}:{{ y * interconnect_pairs_count }}]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_tile{{ y }}),
    );
{% endfor %}
{% endblock  %}