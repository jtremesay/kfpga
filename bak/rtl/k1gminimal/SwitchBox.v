module SwitchBox(
    input [1:0] data_north_in,
    output [1:0] data_north_out,
    input [1:0] data_east_in,
    output [1:0] data_east_out,
    input [1:0] data_south_in,
    output [1:0] data_south_out,
    input [1:0] data_west_in,
    output [1:0] data_west_out,
    input data_from_les,
    output [1:0] data_to_les,
    input [23:0] config_in
);
    // Dispatch the config 
    wire [1:0] c_muxes_north [1:0];
    assign c_muxes_north[0] = config_in[1:0];
    assign c_muxes_north[1] = config_in[3:2]; 
    wire [1:0] c_muxes_east [1:0];
    assign c_muxes_east[0] = config_in[5:4];
    assign c_muxes_east[1] = config_in[7:6]; 
    wire [1:0] c_muxes_south [1:0];
    assign c_muxes_south[0] = config_in[9:8];
    assign c_muxes_south[1] = config_in[11:10]; 
    wire [1:0] c_muxes_west [1:0];
    assign c_muxes_west[0] = config_in[13:12];
    assign c_muxes_west[1] = config_in[15:14]; 
    wire [3:0] c_muxes_les [1:0];
    assign c_muxes_les[0] = config_in[19:16];
    assign c_muxes_les[1] = config_in[23:20];

    // Use Wilton switchbox
    // https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.44.4925&rep=rep1&type=pdf
    // 6.1.2: Logic Resources, p103

    // Side north
    genvar i, j;
    for (i = 0; i < 2; i = i + 1 ) begin
        MultiplexerSBIC mux_north(
            .data_in({
                data_west_in[(i + 1) % 2],
                data_south_in[ i ], 
                data_east_in[(2 - i) % 2],
                data_from_les
            }),
            .data_out(data_north_out[i]),
            .config_in(c_muxes_north[i])
        );
    end

    // Side east
    for (i = 0; i < 2; i = i + 1 ) begin
        MultiplexerSBIC mux_east(
            .data_in({
                data_north_in[(2 - i) % 2],
                data_west_in[i],
                data_south_in[(i + 1) % 2],
                data_from_les
            }),
            .data_out(data_east_out[i]),
            .config_in(c_muxes_east[i])
        );
    end

    // Side south
    for (i = 0; i < 2; i = i + 1 ) begin
        MultiplexerSBIC mux_south(
            .data_in({
                data_east_in[( + 1) % 2],
                data_north_in[i],
                data_west_in[(2 - i) % 2],
                data_from_les
            }),
            .data_out(data_south_out[i]),
            .config_in(c_muxes_south[i])
        );
    end

    // Side west
    for (i = 0; i < 2; i = i + 1 ) begin
        MultiplexerSBIC mux_west(
            .data_in({
                data_south_in[(2 - i) % 2],
                data_east_in[i],
                data_north_in[(i + 1) % 2],
                data_from_les
            }),
            .data_out(data_west_out[i]),
            .config_in(c_muxes_west[i])
        );
    end

    // Le 
    for (i = 0; i < 1; i = i + 1) begin
        for (j = 0; j < 2; j = j + 1 ) begin
            MultiplexerSBLE mux_le(
                .data_in({ 
                    data_north_in,
                    data_east_in,
                    data_south_in,
                    data_west_in,
                    data_from_les
                }),
                .data_out(data_to_les[i * 2 + j]),
                .config_in(c_muxes_les[i * 2 + j])
            );
        end
    end

endmodule