// ============================================================
// ID: rtl14 — Reset: Async Assert, Sync Deassert
// ============================================================
// Goal: assert reset immediately, release reset cleanly on clk edge via 2FF chain. 

module reset_sync (
  input  logic clk,
  input  logic async_rst_n,
  output logic rst_n_sync
);

  // TODO: Two-stage synchronizer flops for deassertion.
  // Why: prevents metastability when async reset is released.
  logic r1, r2;

  // TODO: Use async clear on flops.
  // Why: async assertion requirement (reset takes effect without clock).
  always_ff @(posedge clk or negedge async_rst_n)
  begin
    if(!async_rst_n)
    begin
      r1 <= 0;
      r2 <= 0;
    end
    else
    begin
      r1 <= async_rst_n ;
      r2 <= r1 ;
    end
  end
  
  assign rst_n_sync = r2 ;


  // TODO: Shift in '1' when async_rst_n is high.
  // Why: deassert becomes synchronous after two cycles.
  // r1 <= 1'b1; r2 <= r1;

  // TODO: Drive rst_n_sync from last stage.
  // Why: clean synchronized reset for rest of logic.
  // assign rst_n_sync = r2;

endmodule
