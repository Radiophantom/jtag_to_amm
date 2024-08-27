
module dut (
  input         rst_i,
  input         clk_i,

  avalon_mm_if  mem_if
);

parameter int SLV_BASE [2] = '{32, 1024};

avalon_mm_if #(32,16) mem_w_if (clk_i);

amm_conv amm_conv_inst (
  .amm_in_if  ( mem_if    ),
  .amm_out_if ( mem_w_if  )
);

avalon_mm_if #(32,16) mem_dmx_if [0:1] (clk_i);

amm_demux #(
  .SLV_CNT    ( 2             ),
  .SLV_BASE   ( SLV_BASE      )
) amm_demux_inst (
  .rst_i      ( rst_i         ),
  .clk_i      ( clk_i         ),
  .mst_mem_if ( mem_w_if      ),
  .slv_mem_if ( mem_dmx_if    )
);

amm_regs amm_regs_inst (
  .rst_i      ( rst_i         ),
  .clk_i      ( clk_i         ),
  .mem_if     ( mem_dmx_if[0] )
);

amm_mem #(
  .MEM_DEPTH  ( 1024          )
) amm_mem_inst (
  .rst_i      ( rst_i         ),
  .clk_i      ( clk_i         ),
  .mem_if     ( mem_dmx_if[1] )
);

endmodule

