{% extends "verilog/base/Module.v" %}

{% block body %}
    {% for i in range(module.width) %}
    IOTile iot{{ i }}(
        .data_from_io(data_from_io[{{ (i + 1) * module.io_pairs_count - 1 }}:{{ i * module.io_pairs_count }}]),
        .data_to_io(data_to_io[{{ (i + 1) * module.io_pairs_count - 1 }}:{{ i * module.io_pairs_count }}]),
        .data_from_ic(data_from_ic[{{ (i + 1) * module.interconnect_pairs_count - 1 }}:{{ i * module.interconnect_pairs_count }}]),
        .data_to_ic(data_to_ic[{{ (i + 1) * module.interconnect_pairs_count - 1 }}:{{ i * module.interconnect_pairs_count }}]),
        .config_in(c_iot{{i}})
    );
    {% endfor %}
{% endblock  %}