module LogicElement(
    input clock,
    input nreset,
    input enable,
    input [3:0] data_in,
    output data_out,
    input [16:0] config_in
);
    // Dispatch the config 
    wire [15:0] c_lut = config_in[15:0]; 
    wire c_comb_out = config_in[16];

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

endmodule