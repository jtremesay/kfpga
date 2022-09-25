{% extends "verilog/base/Module.v" %}
{% block body %}
    // Implement a pipelined mux
    // At each stage, we divide the search space by two.

    // First step of the pipeline
    wire [{{ 2 ** module.stages - 1 }}:0] stage{{ module.stages }} = { {% if 2 ** module.stages > module.size %}{{ 2 ** module.stages - module.size }}'b0, {% endif %}data_in };
    
    // Build the pipeline
    {% for index in range(module.stages - 1, 0, -1) -%}
    wire [{{ 2 ** index - 1 }}:0] stage{{ index }} = c_selector[{{ index }}] ? stage{{ index + 1 }}[{{ 2 ** (index + 1) - 1 }}:{{ 2 ** index }}] : stage{{ index + 1}}[{{ 2 ** index - 1}}:0];
    {% endfor %}
    // Final stage
    assign data_out = c_selector[0] ? stage1[1] : stage1[0] ;
{%- endblock  %}