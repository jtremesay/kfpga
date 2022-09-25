module IOColumn(
    input [31:0] data_from_io,
    output [31:0] data_to_io,
    input [79:0] data_from_ic,
    output [79:0] data_to_ic,
    input [287:0] config_in
);
    // Dispatch the config 
    wire [35:0] c_iot0 = config_in[35:0]; 
    wire [35:0] c_iot1 = config_in[71:36]; 
    wire [35:0] c_iot2 = config_in[107:72]; 
    wire [35:0] c_iot3 = config_in[143:108]; 
    wire [35:0] c_iot4 = config_in[179:144]; 
    wire [35:0] c_iot5 = config_in[215:180]; 
    wire [35:0] c_iot6 = config_in[251:216]; 
    wire [35:0] c_iot7 = config_in[287:252];

    
    IOTile iot0(
        .data_from_io(data_from_io[3:0]),
        .data_to_io(data_to_io[3:0]),
        .data_from_ic(data_from_ic[9:0]),
        .data_to_ic(data_to_ic[9:0]),
        .config_in(c_iot0)
    );
    
    IOTile iot1(
        .data_from_io(data_from_io[7:4]),
        .data_to_io(data_to_io[7:4]),
        .data_from_ic(data_from_ic[19:10]),
        .data_to_ic(data_to_ic[19:10]),
        .config_in(c_iot1)
    );
    
    IOTile iot2(
        .data_from_io(data_from_io[11:8]),
        .data_to_io(data_to_io[11:8]),
        .data_from_ic(data_from_ic[29:20]),
        .data_to_ic(data_to_ic[29:20]),
        .config_in(c_iot2)
    );
    
    IOTile iot3(
        .data_from_io(data_from_io[15:12]),
        .data_to_io(data_to_io[15:12]),
        .data_from_ic(data_from_ic[39:30]),
        .data_to_ic(data_to_ic[39:30]),
        .config_in(c_iot3)
    );
    
    IOTile iot4(
        .data_from_io(data_from_io[19:16]),
        .data_to_io(data_to_io[19:16]),
        .data_from_ic(data_from_ic[49:40]),
        .data_to_ic(data_to_ic[49:40]),
        .config_in(c_iot4)
    );
    
    IOTile iot5(
        .data_from_io(data_from_io[23:20]),
        .data_to_io(data_to_io[23:20]),
        .data_from_ic(data_from_ic[59:50]),
        .data_to_ic(data_to_ic[59:50]),
        .config_in(c_iot5)
    );
    
    IOTile iot6(
        .data_from_io(data_from_io[27:24]),
        .data_to_io(data_to_io[27:24]),
        .data_from_ic(data_from_ic[69:60]),
        .data_to_ic(data_to_ic[69:60]),
        .config_in(c_iot6)
    );
    
    IOTile iot7(
        .data_from_io(data_from_io[31:28]),
        .data_to_io(data_to_io[31:28]),
        .data_from_ic(data_from_ic[79:70]),
        .data_to_ic(data_to_ic[79:70]),
        .config_in(c_iot7)
    );
    

endmodule