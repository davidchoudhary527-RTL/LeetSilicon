// ============================================================
// ID: rtl11 — Clock Divide-by-3 (~50% duty, glitch-free)
// ============================================================
// Goal: odd divider with ~50% duty typically uses posedge+negedge paths. 

module clk_div3_50 (
  input  logic clk,
  input  logic rst_n,
  output logic clk_div3_50
);

    logic [1:0] pos_cnt;
    logic [1:0] neg_cnt;

    logic pos_clk;
    logic neg_clk;

    // --------------------------------------------------------
    // Positive-edge path
    // Generates:
    //        10----20
    //        40----50
    // --------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 2'd0;
            pos_clk <= 1'b0;
        end
        else begin
            if (pos_cnt == 2'd2) begin
                pos_cnt <= 2'd0;
                pos_clk <= 1'b1;
            end
            else begin
                pos_cnt <= pos_cnt + 1'b1;
                pos_clk <= 1'b0;
            end
        end
    end

    // --------------------------------------------------------
    // Negative-edge path
    // Generates:
    //         5----15
    //        35----45
    // --------------------------------------------------------
    always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 2'd0;
            neg_clk <= 1'b0;
        end
        else begin
            if (neg_cnt == 2'd2) begin
                neg_cnt <= 2'd0;
                neg_clk <= 1'b1;
            end
            else begin
                neg_cnt <= neg_cnt + 1'b1;
                neg_clk <= 1'b0;
            end
        end
    end

    // Registered signals are combined.
    // No combinational feedback.
    assign clk_div3_50 = pos_clk | neg_clk;


endmodule
