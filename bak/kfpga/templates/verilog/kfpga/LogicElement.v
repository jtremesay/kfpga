{% extends "verilog/base/Module.v" %}
{% block body %}
    // Instantiate the LUT
    wire lut_z;
    LookUpTable lut(
        .data_in(data_in),
        .data_out(lut_z),
        .config_in(c_lut)
    );

    // Register the output of the LUT
    reg lut_z_seq;
    always @(posedge clock) begin
        if (!nreset) begin
            lut_z_seq <= 0;
        end else if (enable) begin
            lut_z_seq <= lut_z;
        end
    end

    // Choose between the sequential and comb output
    assign data_out = c_comb_out ? lut_z : lut_z_seq;
{% endblock  %}