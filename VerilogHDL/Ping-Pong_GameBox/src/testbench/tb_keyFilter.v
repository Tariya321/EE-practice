`timescale 10ns/1ns
module tb_keyFilter ();

reg clk, rst;
reg key;
wire key_effPulse;

parameter period_clk = 1;      // 仿真时钟周期20ns, 对应50MHz
parameter period_pp = 500_000;     // 按键按下
parameter period_keyPress = 5_000_000;  // 按键时间50ms

initial begin
    clk <= 0;
    key <= 1;
    rst <= 1;
    #0.1 rst <= 0;        // 复位
    #0.1 rst <= 1;
    #(period_pp)    key <= 0;
    #(period_keyPress)  key <= 1;
end

always #(period_clk) clk = ~clk;

key_filter inst_keyFilter(
    .clk(clk),        
    .rst(rst),
    .key(key),
    .key_effPulse(key_effPulse)
);
endmodule

