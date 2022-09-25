{% extends "verilog/base/Module.v" %}

{% block body %}
    // Connection used between the logic element and the switchbox
    wire [{{ cluster_size * lut_size - 1 }}:0] w_to_les;
    wire [{{ cluster_size - 1 }}:0] w_from_les;

    // Instantiate the switchbox
    SwitchBox sb(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_from_les(w_from_les),
        .data_to_les(w_to_les),
        .config_in(c_switchbox)
    );

    // Instantiate the logic elemenets
{%- for i in range(cluster_size) %}
    LogicElement el{{ i }}(
        .data_in(w_to_les[{{ (i + 1) * lut_size - 1 }}:{{ i * lut_size }}]),
        .data_out(w_from_les[{{ i }}]),
        .clock(clock),
        .nreset(nreset),
        .config_in(c_le{{ i }})
    );
{% endfor %}
{%- endblock  %}