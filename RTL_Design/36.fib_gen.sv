// ============================================================
// ID: rtl8 — Fibonacci Generator (enable)
// ============================================================
// Goal: maintain (a,b), update on enable: (a,b)<-(b,a+b). 

module fib_gen #(
  parameter int W = 32
) (
  input  logic         clk,
  input  logic         rst_n,
  input  logic         enable,
  output logic [W-1:0] fib_out
);

  // TODO: Two registers a and b.
  // Why: Fibonacci recurrence needs previous two values.
  logic [W-1:0] a, b;

  // TODO: Define output convention.


  // TODO: Compute sum.
  logic [W-1:0] sum;

  // TODO: always_ff update on enable.
  always_ff @(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
    begin
      a <= 0 ;
      b <= 1 ;
      fib_out <= 'h0 ;
    end
    else
    begin
      a <= (enable)? b : a ;
      b <= (enable)? a+b : b ;
      fib_out <= (enable)? {fib_out[W-3:0], a,b} : fib_out ;
    end 
  end



  // TODO: Reset init values.

endmodule
