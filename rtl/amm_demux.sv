
module amm_demux #(
  parameter int SLV_CNT,
  parameter int SLV_BASE [SLV_CNT]
)(
  input         rst_i,
  input         clk_i,

  avalon_mm_if  mst_mem_if,
  avalon_mm_if  slv_mem_if [SLV_CNT]
);

//------------------------------------------------------------------------------
// Parameters
//------------------------------------------------------------------------------

parameter DUMMY_SLV_INDX = SLV_CNT;

function int get_slave_index(bit [31:0] address);
  for(int i = 0; i < SLV_CNT; i++)
    if(mst_mem_if.address < SLV_BASE[i])
      return i;
  return DUMMY_SLV_INDX;
endfunction

int current_slave_index;

assign current_slave_index = get_slave_index(mst_mem_if.address);

//------------------------------------------------------------------------------
// Demux outputs
//------------------------------------------------------------------------------

logic [SLV_CNT-1:0]       slv_mem_readdatavalid;
logic [SLV_CNT-1:0][15:0] slv_mem_readdata;
logic [SLV_CNT-1:0]       slv_mem_waitrequest;

genvar g;
generate
  for(g = 0; g < SLV_CNT; g++)
  begin : slv_if_assign

    assign slv_mem_if[g].write     = (current_slave_index == g) && mst_mem_if.write;
    assign slv_mem_if[g].read      = (current_slave_index == g) && mst_mem_if.read;
    assign slv_mem_if[g].address   = mst_mem_if.address;
    assign slv_mem_if[g].writedata = mst_mem_if.writedata;

    assign slv_mem_readdatavalid[g] = slv_mem_if[g].readdatavalid;
    assign slv_mem_readdata[g]      = slv_mem_if[g].readdata;
    assign slv_mem_waitrequest[g]   = slv_mem_if[g].waitrequest;

  end
endgenerate

//------------------------------------------------------------------------------
// DUMMY read interface
//------------------------------------------------------------------------------

logic readdatavalid;

always_ff @(posedge clk_i,posedge rst_i)
  if(rst_i)
    readdatavalid <= 1'b0;
  else
    readdatavalid <= mem_if.read;

//------------------------------------------------------------------------------
// Mux inputs
//------------------------------------------------------------------------------

assign mst_mem_if.readdatavalid  = (current_slave_index == DUMMY_SLV_INDX) ? readdatavalid  : slv_mem_readdatavalid [current_slave_index];
assign mst_mem_if.readdata       = (current_slave_index == DUMMY_SLV_INDX) ? 16'hBEAF       : slv_mem_readdata      [current_slave_index];
assign mst_mem_if.waitrequest    = (current_slave_index == DUMMY_SLV_INDX) ? 1'b0           : slv_mem_waitrequest   [current_slave_index];

endmodule

