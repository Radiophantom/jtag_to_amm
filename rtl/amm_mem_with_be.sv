
module amm_memory (
  input	          rst_i,
  input	          clk_i,
  input  [31:0]   amm_address,
  input           amm_read,
  input  [3:0]    amm_byteenable,
  input           amm_write,
  input  [31:0]   amm_writedata,
  output          amm_readdatavalid,
  output [31:0]   amm_readdata,
  output          amm_waitrequest
);

//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------

localparam int MEM_DEPTH  = 1024;
localparam int MEM_ADDR_W = $clog2(MEM_DEPTH);
localparam int MEM_DATA_W = 32;

//------------------------------------------------------------------------------

logic [3:0][7:0] mem [MEM_DEPTH];

//------------------------------------------------------------------------------

logic [MEM_ADDR_W-1:0] addr;

assign addr = amm_address[MEM_ADDR_W+1:2];

always_ff @(posedge clk_i)
  if(amm_write)
    for(int i = 0; i < 4; i++)
      if(amm_byteenable[i])
        mem[addr][i] <= amm_writedata[i*8+:8];

logic [31:0] readdata;

always_ff @(posedge clk_i)
  if(amm_read)
    readdata <= mem[addr];

logic readdatavalid;

always_ff @(posedge clk_i,posedge rst_i)
  if(rst_i)
    readdatavalid <= 1'b0;
  else
    readdatavalid <= amm_read;

assign amm_readdatavalid  = readdatavalid;
assign amm_readdata       = readdata;
assign amm_waitrequest    = 1'b0;

endmodule

