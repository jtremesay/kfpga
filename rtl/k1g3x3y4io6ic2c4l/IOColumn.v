module IOColumn(
    input [11:0] data_from_io,
    output [11:0] data_to_io,
    input [17:0] data_from_ic,
    output [17:0] data_to_ic,
    input [71:0] config_in
);
    // Dispatch the config 
    wire [23:0] c_iot0 = config_in[23:0]; 
    wire [23:0] c_iot1 = config_in[47:24]; 
    wire [23:0] c_iot2 = config_in[71:48];

    
    IOTile iot0(
        .data_from_io(data_from_io[3:0]),
        .data_to_io(data_to_io[3:0]),
        .data_from_ic(data_from_ic[5:0]),
        .data_to_ic(data_to_ic[5:0]),
        .config_in(c_iot0)
    );
    
    IOTile iot1(
        .data_from_io(data_from_io[7:4]),
        .data_to_io(data_to_io[7:4]),
        .data_from_ic(data_from_ic[11:6]),
        .data_to_ic(data_to_ic[11:6]),
        .config_in(c_iot1)
    );
    
    IOTile iot2(
        .data_from_io(data_from_io[11:8]),
        .data_to_io(data_to_io[11:8]),
        .data_from_ic(data_from_ic[17:12]),
        .data_to_ic(data_to_ic[17:12]),
        .config_in(c_iot2)
    );
    

endmodule