module ConfigShiftRegister(
    input data_in,
    output [34687:0] data_out,
    input clock,
    input enable,
    input nreset
);
    reg [34687:0] r_data;
    always @(posedge clock) begin
        if (!nreset) begin
            r_data <= 0;
        end else begin
            if (enable) begin
                r_data <= {r_data[34686:0], data_in};
            end
        end
    end
    assign data_out = r_data;   

endmodule