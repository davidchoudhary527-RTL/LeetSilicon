// ============================================================
// ID: rtl15 — CDC 2-FF Synchronizer (1-bit)
// ============================================================
// Goal: synchronize async signal into dst_clk domain using two flops. 

module two_ff_sync (
  input  logic dst_clk,
  input  logic dst_rst_n,
  input  logic async_sig_in,
  output logic sig_sync
);

  // TODO: Two flops in destination domain.
  // Why: first flop may metastabilize; second flop greatly reduces propagation risk.
  logic s1, s2;

  // TODO: always_ff on dst_clk.
  // Why: synchronizer must be clocked only by destination clock.
  always_ff @(posedge dst_clk or negedge dst_rst_n) 
  begin
    if(!dst_rst_n)
    begin
      s1 <= 0 ; s2 <=0 ;
    end
    else
    begin
      s1 <= async_sig_in ;
      s2 <= s1 ;
    end
  end

  assign sig_sync = s2 ;

  // TODO: Assign output from second flop.
  // Why: use the stabilized version.
  // assign sig_sync = s2;

  // TODO: (Optional) attributes for sync regs.
  // Why: helps synthesis/STA treat these as CDC synchronizers.

endmodule
