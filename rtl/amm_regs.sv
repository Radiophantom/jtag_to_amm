
module amm_regs (
  input           rst_i,
  input           clk_i,
  avalon_mm_if    mem_if
);

import amm_regs_pkg::*;

//------------------------------------------------------------------------------
logic [15:0] regs [32];
//------------------------------------------------------------------------------

logic [4:0]   addr;
logic [15:0]  writedata;

assign addr       = mem_if.address  [4:0];
assign writedata  = mem_if.writedata[15:0];

always_ff @(posedge clk_i,posedge rst_i)
  if(rst_i)
    regs <= REGS_INIT;
  else
    if(mem_if.write)
      for(int i = 0; i < 16; i++)
        if(!REGS_RO_MASK[addr][i])
          regs[addr][i] <= writedata[i];

//------------------------------------------------------------------------------

logic [15:0] readdata;

always_ff @(posedge clk_i)
  if(mem_if.read)
    readdata <= regs[addr];

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

