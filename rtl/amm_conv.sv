
/*
  Convert byte Avalon-MM interface into word base interface
*/

module amm_conv (
  avalon_mm_if    amm_in_if,
  avalon_mm_if    amm_out_if
);

assign amm_out_if.address        = amm_in_if.address[31:1] + ( amm_in_if.byteenable[1:0] == 2'b00 );
assign amm_out_if.read           = amm_in_if.read;
assign amm_out_if.byteenable     = '1;
assign amm_out_if.write          = amm_in_if.write;
assign amm_out_if.writedata      = ( amm_in_if.byteenable[1:0] == 2'b00 ) ? amm_in_if.writedata[31:16] : amm_in_if.writedata[15:0];

assign amm_in_if.readdatavalid   = amm_out_if.readdatavalid;
assign amm_in_if.readdata        = ( amm_in_if.byteenable[1:0] == 2'b00 ) ? ( amm_out_if.readdata[15:0] << 16 ) : ( amm_out_if.readdata[15:0] << 0 );
assign amm_in_if.waitrequest     = amm_out_if.waitrequest;

endmodule

