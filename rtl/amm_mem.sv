
module amm_mem #(
  parameter int MEM_DEPTH
)(
  input	          rst_i,
  input	          clk_i,
  avalon_mm_if    mem_if
);

//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------

localparam int MEM_ADDR_W = $clog2(MEM_DEPTH);

//------------------------------------------------------------------------------
logic [15:0] mem [MEM_DEPTH];
//------------------------------------------------------------------------------

logic [MEM_ADDR_W-1:0]  addr;
logic [15:0]            writedata;

assign addr       = mem_if.address[MEM_ADDR_W-1:0];
assign writedata  = mem_if.writedata[15:0];

always_ff @(posedge clk_i)
  if(mem_if.write)
    mem[addr] <= writedata;

//------------------------------------------------------------------------------

logic [15:0] readdata;

always_ff @(posedge clk_i)
  if(mem_if.read)
    readdata <= mem[addr];

logic readdatavalid;

always_ff @(posedge clk_i,posedge rst_i)
  if(rst_i)
    readdatavalid <= 1'b0;
  else
    readdatavalid <= mem_if.read;

//------------------------------------------------------------------------------

assign mem_if.readdatavalid  = readdatavalid;
assign mem_if.readdata       = readdata;
assign mem_if.waitrequest    = 1'b0;

endmodule

