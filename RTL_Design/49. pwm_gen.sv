// ============================================================
// ID: misc4 — Parameterizable PWM Generator (counter compare)
// ============================================================
// PWM basics: counter counts 0..PERIOD-1, and comparator sets output high while count < DUTY.
//
// TODO: Choose whether PERIOD/DUTY are parameters or runtime inputs.
// TODO: If runtime configurable, document update timing (immediate vs at period boundary to avoid glitches).

module pwm_gen #(
  parameter COUNTER_WIDTH = 8,
  parameter PERIOD        = 100,
  parameter DUTY          = 50
) (
  input  logic clk,
  input  logic rst_n,
  output logic pwm_out
);

  logic [COUNTER_WIDTH-1:0] cnt_q, cnt_d;

  // TODO: Counter update:
  // if (cnt_q == period-1) cnt_d = 0; else cnt_d = cnt_q + 1;

  // TODO: Comparator output:
  // pwm_out = (cnt_q < duty);  // edge cases: duty=0 => always 0, duty=period => always 1.

  // TODO: Reset: cnt_q=0, pwm_out=0 (or define initial).

  // TODO: Add parameter/legal checks:
  // - require 1 <= period <= 2^COUNTER_WIDTH
  // - require 0 <= duty <= period

  always_ff @(posedge clk or negedge rst_n )
  begin
    if(!rst_n)
    begin
      cnt_q <= 0 ;
    end
    else
    begin
      if(cnt_q == PERIOD - 1 )
      cnt_q <= 0 ;
      else 
      cnt_q <= cnt_q + 1'b1 ;
    end
  end

  assign pwm_out = (cnt_q < DUTY)? 1'b1 : 1'b0 ;

endmodule


