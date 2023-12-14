`timescale 10ns/1ns
module tb_gameCtrl ();

reg clk, rst;
reg key_1, key_2;

wire [7:0] position;
wire clk_2Hz;
wire key_player1_eff, key_player2_eff;
wire [2:0] score_player1, score_player2;

parameter period_clk = 1;      // 仿真时钟周期20ns, 对应50MHz
parameter period_pp = 50_000_000;       // 0.5s, 对应乒乓球流转一位的时间
parameter period_keyPress = 5_000_000;  // 按键时间50ms

initial begin
    clk <= 0;
    key_1 <= 1;
    key_2 <= 1;
    rst <= 1;
    #1 rst <= 0;        // 复位
    #1 rst <= 1;
    // 模拟动作1: 在0.5s时, 甲发球
    #(period_pp)    key_1 <= 0;
    #(period_keyPress)  key_1 <= 1;
    // 模拟动作2: 在1s时, 乙接球(甲得分)
    #(period_pp)    key_2 <= 0;
    #(period_keyPress)  key_2 <= 1;
    // 模拟动作3: 在1.5s时, 乙发球
    #(period_pp)    key_2 <= 0;
    #(period_keyPress)  key_2 <= 1;
    // 模拟动作4: 在2s时, 甲接球(乙得分)
    #(period_pp)    key_1 <= 0;
    #(period_keyPress)  key_1 <= 1;
    // 模拟动作5: 在2.5s时, 甲发球
    #(period_pp)    key_1 <= 0;
    #(period_keyPress)  key_1 <= 1;
    // 模拟动作6: 在5s时, 乙击球(球反向)
    #(period_pp * 5)    key_2 <= 0;
    #(period_keyPress)  key_2 <= 1;
    // 模拟动作7: 在8s时, 甲击球(球出界, 乙得分)
    #(period_pp * 6)    key_1 <= 0;
    #(period_keyPress)  key_1 <= 1;
end

always #(period_clk) clk = ~clk;

// divider_clk #(24'd12499999) inst_divider_clk(
//     .rst(rst), 
//     .clk(clk), 
//     .clk_new(clk_2Hz)
// );

divider_clk #(24'd12499999) inst_divider_clk(
    .rst(rst), 
    .clk(clk), 
    .clk_new(clk_2Hz)
);

key_filter f1(
    .clk(clk), 
    .rst(rst), 
    .key(key_1), 
    .key_effPulse(key_player1_eff)
);

key_filter f2(
    .clk(clk), 
    .rst(rst), 
    .key(key_2), 
    .key_effPulse(key_player2_eff)
);

gameCtrl inst_gameCtrl(
.clk(clk),             
.clk_2Hz(clk_2Hz),     
.rst(rst),        
.key_player1_eff(key_player1_eff),  
.key_player2_eff(key_player2_eff),    
.position(position),       
.score_player1(score_player1), 
.score_player2(score_player2)
);
endmodule