// ============================================================
// ID: rtl12 — Clock Divide-by-N (~50% duty)
// ============================================================
// Goal: support even/odd N; keep output glitch-free. 

module clk_divN #(
  parameter int N = 4
) (
  input  logic clk,
  input  logic rst_n,
  output logic clk_divN
);

  // TODO: Validate N >= 2 (optional assert).
  // Why: divider must have a meaningful period.
  localparam HALF = N / 2;
  localparam ODD  = N[0];   // 1 if N is odd

  logic [$clog2(N)-1:0] cnt_pos;
  logic                   pos_out;

  // Posedge counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_pos <= 0;
      pos_out <= 0;
    end else begin
      if (cnt_pos == N - 1) cnt_pos <= 0;
      else cnt_pos <= cnt_pos + 1;
      pos_out <= (cnt_pos < HALF);
    end
  end

  // For even N: use posedge output directly (50% duty)
  // For odd N: also generate negedge version and OR them
  generate
    if (ODD) begin : gen_odd
      logic [$clog2(N)-1:0] cnt_neg;
      logic                   neg_out;

      always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
          cnt_neg <= 0;
          neg_out <= 0;
        end else begin
          if (cnt_neg == N - 1) cnt_neg <= 0;
          else cnt_neg <= cnt_neg + 1;
          neg_out <= (cnt_neg < HALF);
        end
      end

      assign clk_divN = pos_out & neg_out;
    end else begin : gen_even
      assign clk_divN = pos_out;
    end
  endgenerate


endmodule
