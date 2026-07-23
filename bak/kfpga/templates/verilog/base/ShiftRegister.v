{% extends "verilog/base/Module.v" %}

{% block body %}
    reg [{{ module.width - 1 }}:0] r_data;
    always @(posedge clock) begin
        if (!nreset) begin
            r_data <= 0;
        end else begin
            if (enable) begin
                r_data <= {r_data[{{ module.width - 2}}:0], data_in};
            end
        end
    end
    assign data_out = r_data;   
{% endblock  %}