`timescale 1 ns / 1 ns

module top_tb;

parameter int CLK_T = 10;

bit rst;
bit clk;

initial
begin
  rst <= 1;
  #(10*CLK_T);
  fork
    forever
      #(CLK_T/2) clk = !clk;
  join_none
  repeat(10)
    @(posedge clk);
  rst <= 0;
end

avalon_mm_if #(32,32) mem_if (clk);

int DBG_LEVEL = 1;

`include "amm_transaction.sv"

task automatic read(amm_transaction tr);
  repeat(tr.gap)
    @mem_if.cb;
  mem_if.cb.address    <= {tr.addr[31:2],2'b00};
  mem_if.cb.byteenable <= tr.addr[1] ? 4'b1100 : 4'b0011;
  mem_if.cb.read       <= 1;
  do
    @mem_if.cb;
  while(mem_if.cb.waitrequest);
  mem_if.cb.read <= 0;
  while(!mem_if.cb.readdatavalid)
    @mem_if.cb;
  tr.rddata = mem_if.cb.readdata;
  if(DBG_LEVEL > 0)
    $display("@%0t [read] addr - %0d. data - %h",$time(),tr.addr,tr.rddata);
endtask

task automatic write(amm_transaction tr);
  repeat(tr.gap)
    @mem_if.cb;
  mem_if.cb.address    <= {tr.addr[31:2],2'b00};
  mem_if.cb.byteenable <= tr.addr[1] ? 4'b1100 : 4'b0011;
  mem_if.cb.writedata  <= tr.wrdata;
  mem_if.cb.write      <= 1;
  do
    @mem_if.cb;
  while(mem_if.cb.waitrequest);
  mem_if.cb.write      <= 0;
  if(DBG_LEVEL > 0)
    $display("@%0t: [write] addr - %0d. data - %h",$time(),tr.addr,tr.wrdata);
endtask

//------------------------------------------------------------------------------
// Test
//------------------------------------------------------------------------------

amm_transaction tr;

initial
begin

  tr = new();
  tr.ADDR_W = 32;
  tr.DATA_W = 32;

  mem_if.read   = '0;
  mem_if.write  = '0;

  @(negedge rst);

  repeat(100)
    @mem_if.cb;
  
  for(int i = 0; i < 32; i++)
  begin
    assert(tr.randomize() with {addr == i*2; op == WRITE;});
    write(tr);
  end

  repeat(10)
    @mem_if.cb;

  for(int i = 32; i < 1024; i++)
  begin
    assert(tr.randomize() with {addr == i*2; op == WRITE;});
    write(tr);
  end

  repeat(10)
    @mem_if.cb;

  repeat(10)
  begin
    assert(tr.randomize() with {addr >= 2048; op == WRITE;});
    write(tr);
  end

  repeat(10)
    @mem_if.cb;

  repeat(10)
  begin
    assert(tr.randomize() with {addr < 64; op == READ;});
    read(tr);
  end

  repeat(10)
    @mem_if.cb;

  repeat(10)
  begin
    assert(tr.randomize() with {addr >= 64; addr < 2048; op == READ;});
    read(tr);
  end

  repeat(10)
    @mem_if.cb;

  repeat(10)
  begin
    assert(tr.randomize() with {addr >= 2048; op == READ;});
    read(tr);
  end

  $display("Simulation finished!");
  $stop();
end

//------------------------------------------------------------------------------
// DUT
//------------------------------------------------------------------------------

dut DUT (
  .rst_i ( rst    ),
  .clk_i ( clk    ),
  
  .mem_if( mem_if )
);

endmodule

