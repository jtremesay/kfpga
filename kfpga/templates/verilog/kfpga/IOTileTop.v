{% extends "verilog/kfpga/TileTop.v" %}

{% block subbody %}
    IOTile iot(
        .data_from_io(data_from_io),
        .data_to_io(data_to_io),
        .data_from_ic(data_from_ic),
        .data_to_ic(data_to_ic),
        .config_in(config_data),
    );
{%- endblock  %}