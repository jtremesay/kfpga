module {{ module.name }}(
{%- for port in module.ports if port.width > 0 %}
    {{ port.direction.value }} 
    {%- if port.width > 1 %} [{{ port.width - 1 }}:0]{% endif %} {{ port.name }}
    {%- if not loop.last %},{% endif %}
{%- endfor %}
);
{%- if module.config and module.config.width > 0 %}
    // Dispatch the config
{%- for index, config in module.config.enumerate() if config.width > 0 %} 
    wire {% if config.width > 1 %}[{{ config.width - 1}}:0] {% endif %}c_{{ config.name }}{% if config.count > 1 %} [{{ config.count - 1 }}:0]{% endif %}{% if config.count == 1 %} = config_in{% if module.config.width > 1 %}[{% if config.width > 1 %}{{ index + config.width - 1 }}:{% endif %}{{ index }}]{% endif %}{% endif %};
    {%- if config.count > 1 %}{% for j in range(config.count) %}
    assign c_{{ config.name }}[{{j}}] = config_in[{% if config.width > 1 %}{{ index + (config.width * (j + 1)) - 1 }}:{% endif %}{{ index + (j * config.width) }}];
    {%- endfor %}{% endif %}
{%- endfor %}
{% endif %}

{%- block body %}{% endblock  %}
endmodule