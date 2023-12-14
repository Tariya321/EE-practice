`timescale 10ns/1ns
module tb_disp ();
reg clk, rst;
reg [3:0] cnt1, cnt2;
wire [6:0] seg;
wire [3:0] sel;

parameter period_clk = 1;      // 仿真时钟周期20ns, 对应50MHz
parameter period_changeScore = 100000;    // 分数变化时间单位1ms

initial begin
    clk <= 0;
    rst <= 1;
    cnt1 <= 4'b0001;      // 固定分数测试
    cnt2 <= 4'b0001;
    #0.1 rst <= 0;
    #0.1 rst <= 1;
    #(4 * period_changeScore) cnt1 <= 4'b0011;    // 进行一次分数改动
    #(8 * period_changeScore) cnt2 <= 4'b0101;    // 再进行一次分数改动
end

always #(period_clk) clk = ~clk;

disp_scores inst_disp_scores(
    .clk(clk), 
    .clk(clk_1k)
    .rst(rst), 
    .cnt1(score_player1), 
    .cnt2(score_player2), 
	.driver_pin_1(driver_pin_1),        
	.driver_pin_2(driver_pin_2),
	.driver_pin_3(driver_pin_3)
);
endmodule