// ============================================================
// ID: rtl13 — Glitch-Free Clock Gating Cell (ICG-style)
// ============================================================
// Goal: latch enable when clk is low, AND with clk to avoid glitches. 

module icg_cell (
  input  logic clk_in,
  input  logic enable,
  output logic clk_gated
);

  // TODO: Latch enable when clk_in is low.
  // Why: if enable changes while clk_in is high, gating must not create runt pulses.
  logic en_latched;

  // TODO: Implement latch (always_latch or negedge FF modeling).
  // Why: standard ICG uses level-sensitive latch transparent during clk low.
  always_latch if (!clk_in) en_latched <= enable;

  // TODO: Gate the clock.
  // Why: AND is typical for active-high enable.
  assign clk_gated = clk_in & en_latched;

  // TODO: (Optional) add test_enable/scan_enable to force clocks on in test.
  // Why: many flows require ungated clocks during scan.

endmodule
