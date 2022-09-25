{% extends "verilog/base/Module.v" %}

{% block body %}
    reg [{{ module.width - 1}}:0] r_data;
    always @(posedge clock) begin
        if (!nreset) begin
            r_data <= 0;
        end else begin
            if (enable) begin
                {% for i in range(module.width) %}
                r_data[{{ i }}] <= {% if i == 0 %}data_in{% else %}r_data[{{ i - 1 }}]{% endif %};
                {% endfor %}
            end
        end
    end
    assign data_out = r_data;   
{% endblock  %}