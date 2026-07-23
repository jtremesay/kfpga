module LogicTileConfig(
    input clock,
    input nreset,
    input enable,
    input data_in,
    output [28:0] data_out
);
    reg [28:0] r_data;
    always @(posedge clock) begin
        if (!nreset) begin
            r_data <= 0;
        end else begin
            if (enable) begin
                r_data <= {r_data[27:0], data_in};
            end
        end
    end
    assign data_out = r_data;   

endmodule