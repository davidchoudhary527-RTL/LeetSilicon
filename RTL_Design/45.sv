// ============================================================
// ID: rtl17 — Binary Pointer + Gray Pointer (CDC/FIFO-style)
// ============================================================
// Goal: maintain binary counter and compute Gray version for safe CDC compare. 

module gray_ptr #(
  parameter int W = 4
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         inc,
  output logic [W-1:0] bin_ptr,
  output logic [W-1:0] gray_ptr
);

  // TODO: Binary pointer register increments when inc=1.
  // Why: binary pointer is convenient for local addressing.
  always_ff @(posedge clk or negedge rst_n) 
  begin
    if(!rst_n)
      bin_ptr <= 0 ;
    else
      bin_ptr <= (inc)? bin_ptr + 1'b1 : bin_ptr ;
  end

  // TODO: Compute Gray pointer.
  // Why: Gray code ensures only one bit changes per increment, safer for CDC sampling.
  assign gray_ptr = bin_ptr ^ (bin_ptr >> 1);

  // TODO: Decide whether gray_ptr is registered.

endmodule
