
module avalon_mm_bridge #(
  parameter int ADDR_IN_W,
  parameter int ADDR_OUT_W,
  parameter int DATA_W
)(
  input         rst_i,
  input         clk_i,

  avalon_mm_if  amm_i,
  avalon_mm_if  amm_o
);

typedef enum {
  IDLE_S,

} state_t;

state_t next_state, state;

always_ff @(posedge clk_i,posedge rst_i)
  if(rst_i)
    state <= IDLE_S;
  else
    state <= next_state;

always_comb
begin
  next_state = state;
  case(state)
    IDLE_S:
  default: next_state = IDLE_S;
end

endmodule

