// ============================================================
// ID: counter3 — Shift Register with Parallel Load + Serial Shift
// ============================================================
// Supports parallel load and serial shifting; serial_out is the shifted-out bit.
// TODO: Choose shift direction (RIGHT or LEFT) and document it.
// TODO: Decide whether to include serial_in; if not, fill with 0.
// TODO: Define control priority when load && shift asserted (common: load wins).

module shift_reg #(
  parameter WIDTH = 8
) (
  input  logic              clk,
  input  logic              rst_n,
  input  logic              load,
  input  logic              shift,
  input  logic [WIDTH-1:0]  data_in,
  input  logic              serial_in,
  output logic [WIDTH-1:0]  parallel_out,
  output logic              serial_out
);

  // TODO: serial_out definition depends on direction:
  // - right shift => serial_out = shreg_q[0]
  // - left shift  => serial_out = shreg_q[WIDTH-1]

  // TODO: Next-state logic:
  // - if load: shreg_d = data_in
  // - else if shift: shreg_d = shifted value (insert serial_in or 0)
  // - else hold
  //
  // TODO: Priority: document and implement load vs shift.
  logic [WIDTH-1:0] reg_val;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      reg_val <= '0;
    end else if (load) begin
      reg_val <= data_in;         // Load has priority
    end else if (shift) begin
      reg_val <= {serial_in, reg_val[WIDTH-1:1]};  // Shift right
    end
  end

  assign parallel_out = reg_val;

  // Register serial_out so it's stable after posedge
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) serial_out <= 0;
    else if (shift && !load) serial_out <= reg_val[0];
  end

endmodule


