// ============================================================
// Asynchronous FIFO (Dual-Clock, Gray code CDC)
// ============================================================
// Key ideas:
// - Maintain binary pointers locally (for addressing), convert to Gray for CDC.
// - Synchronize Gray pointers across domains with 2-FF synchronizers.
// - Empty in read domain: rgray_next == synced wgray.
// - Full in write domain: wgray_next equals synced rgray with MSBs inverted.
//
// TODO: Decide reset strategy:
// - Separate resets per domain (write_rst_n, read_rst_n) OR shared async reset.
// TODO: Decide memory: true dual-port RAM recommended for independent rd/wr clocks.

module async_fifo #(
  parameter int unsigned DEPTH = 16,   // must be power of 2 [per spec]
  parameter int unsigned WIDTH = 8
) (
  // Write domain
  input  logic               write_clk,
  input  logic               write_rst_n,
  input  logic               write_en,
  input  logic [WIDTH-1:0]   write_data,
  output logic               full,

  // Read domain
  input  logic               read_clk,
  input  logic               read_rst_n,
  input  logic               read_en,
  output logic [WIDTH-1:0]   read_data,
  output logic               empty
);

  localparam int unsigned ADDR_W = $clog2(DEPTH);
  // Use ADDR_W+1 pointer bits (extra bit disambiguates full vs empty).
  localparam int unsigned PTR_W  = ADDR_W + 1;

  // Memory (dual-port)
  logic [WIDTH-1:0] mem [0:DEPTH-1];

  // Write pointers
  logic [PTR_W-1:0] wbin,  wbin_next;
  logic [PTR_W-1:0] wgray, wgray_next;

  // Read pointers
  logic [PTR_W-1:0] rbin,  rbin_next;
  logic [PTR_W-1:0] rgray, rgray_next;

  // Synchronized Gray pointers
  logic [PTR_W-1:0] rgray_sync_w; // read pointer synced into write clock domain
  logic [PTR_W-1:0] wgray_sync_r; // write pointer synced into read clock domain

  // 2-FF sync stages (no comb logic between stages).
  logic [PTR_W-1:0] rgray_w_q1, rgray_w_q2;
  logic [PTR_W-1:0] wgray_r_q1, wgray_r_q2;

  // ----------------------------
  // TODO: Utility functions
  // ----------------------------
  function automatic logic [PTR_W-1:0] bin2gray(input logic [PTR_W-1:0] bin);
  // TODO: gray = (bin >> 1) ^ bin.
  bin2gray =  (bin >> 1) ^ bin;
  endfunction

  function automatic logic [PTR_W-1:0] gray2bin(input logic [PTR_W-1:0] gray);
  // TODO: Only needed if you compute occupancy; optional in this design.
  gray2bin = '0;
  endfunction

  assign wbin_next = (write_en && !full) ? (wbin + 1'b1) : wbin;
  assign wgray = bin2gray(wbin) ;
  assign wgray_next = bin2gray(wbin_next) ;

  assign rbin_next = (read_en && !empty) ? (rbin + 1'b1) : rbin;
  assign rgray = bin2gray(rbin) ;
  assign rgray_next = bin2gray(rbin_next) ;
  always_ff @(posedge write_clk or negedge write_rst_n)
  begin
    if(!write_rst_n)
    begin
      rgray_w_q1 <= 'b0 ;
      rgray_w_q2 <= 'b0 ;
    end
    else
    begin
        rgray_w_q1 <= rgray ;
        rgray_w_q2 <= rgray_w_q1 ;
    end
  end
  assign rgray_sync_w = rgray_w_q2 ;
  always_ff @(posedge read_clk or negedge read_rst_n)
  begin
    if(!read_rst_n)
    begin
      wgray_r_q1 <= 'b0 ;
      wgray_r_q2 <= 'b0 ;
    end
    else
    begin
        wgray_r_q1 <= wgray ;
        wgray_r_q2 <= wgray_r_q1 ;
    end
  end
  assign wgray_sync_r = wgray_r_q2 ;
  // ----------------------------
  // TODO: Write-domain logic
  // ----------------------------
  // TODO: Compute wbin_next/wgray_next based on write_en && !full.
  // TODO: Memory write on write_clk when wr_fire:
  // mem[wbin[ADDR_W-1:0]] <= write_data;
  always_ff @(posedge write_clk or negedge write_rst_n)
  begin
    if(!write_rst_n)
    begin
      wbin <= 'b0 ;
    end
    else
    begin
      if(write_en && !full)
      begin
        mem[wbin] <= write_data ;
        wbin <= wbin + wbin_next ;
      end
    end
  end

  // TODO: Full detection in write domain using Gray comparison:
  // full = (wgray_next == {~rgray_sync_w[PTR_W-1:PTR_W-2], rgray_sync_w[PTR_W-3:0]});
  // TODO: Confirm which MSBs to invert for your PTR_W (the standard inverts top 2 bits).
  assign full = (wgray_next == {~rgray_sync_w[PTR_W-1:PTR_W-2], rgray_sync_w[PTR_W-3:0]});
  // ----------------------------
  // TODO: Read-domain logic
  // ----------------------------
  // TODO: Compute rbin_next/rgray_next based on read_en && !empty.
  // TODO: Memory read on read_clk when rd_fire:
  // read_data <= mem[rbin[ADDR_W-1:0]];
  //
  // TODO: Empty detection in read domain:
  // empty = (rgray_next == wgray_sync_r);
  always_ff @(posedge read_clk or negedge read_rst_n)
  begin
    if(!read_rst_n)
    begin
      rbin <= 'b0 ;
      read_data <= 'b0 ;
    end
    else
    begin
      if(read_en && !empty)
      begin
        read_data <= mem[rbin] ;
        rbin <= rbin + rbin_next ;
      end
    end
  end
  assign empty = (rgray_next == wgray_sync_r);
  // ----------------------------
  // TODO: Synchronizers
  // ----------------------------
  // TODO: In write_clk domain: synchronize rgray into write domain with 2 FFs.
  // TODO: In read_clk domain: synchronize wgray into read domain with 2 FFs.
  // TODO: Assign rgray_sync_w = rgray_w_q2; wgray_sync_r = wgray_r_q2;
  
  // ----------------------------
  // TODO: Reset behavior
  // ----------------------------
  // TODO: On reset in each domain:
  // - local bin/gray pointers to 0
  // - sync chains to 0
  // results in empty=1, full=0 after both domains reset as intended.

endmodule
