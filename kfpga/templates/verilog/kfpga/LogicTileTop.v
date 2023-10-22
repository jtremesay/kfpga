{% extends "verilog/kfpga/TileTop.v" %}

{% block subbody %}
    LogicTile lt(
        .data_north_in(data_north_in),
        .data_north_out(data_north_out),
        .data_east_in(data_east_in),
        .data_east_out(data_east_out),
        .data_south_in(data_south_in),
        .data_south_out(data_south_out),
        .data_west_in(data_west_in),
        .data_west_out(data_west_out),
        .clock(clock),
        .nreset(nreset),
        .enable(enable),
        .config_in(config_data)
    );
{%- endblock  %}