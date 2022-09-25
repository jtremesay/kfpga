{% extends "verilog/base/Module.v" %}

{% block body %}
    // Instantiate the config shift register
    wire [{{ module.config_width - 1 }}:0] config_data;
    ConfigShiftRegister config_sr(
        .data_in(config_in),
        .data_out(config_data),
        .clock(config_clock),
        .enable(config_enable),
        .nreset(config_nreset),
    );
    assign config_out = config_data[{{ module.config_width - 1 }}];

    // Instantiate the grid
    kFPGACore core(
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
        .config_in(config_data)
    );
{% endblock  %}