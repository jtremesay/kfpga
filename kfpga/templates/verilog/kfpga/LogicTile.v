{% extends "verilog/base/Module.v" %}

{% block body %}
    // Connection used between the logic element and the switchbox
    wire [{{ module.cluster_size * module.lut_size - 1 }}:0] w_to_les;
    wire [{{ module.cluster_size - 1 }}:0] w_from_les;

    // Instantiate the switchbox
    SwitchBox sb(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_west_in(data_west_in),
        .data_west_out(data_west_out),
        .data_from_les(w_from_les),
        .data_to_les(w_to_les),
        .config_in(c_switchbox)
    );

    // Instantiate the logic elemenets
    genvar i;
    for (i = 0; i < {{ module.cluster_size }}; i = i + 1) begin
        LogicElement el(
            .data_in(w_to_les[(i + 1) * {{ module.lut_size }} - 1:i * {{ module.lut_size }}]),
            .data_out(w_from_les[i]),
            .clock(clock),
            .nreset(nreset),
            .enable(enable),
            .config_in(c_les[i])
        );
    end
{%- endblock  %}