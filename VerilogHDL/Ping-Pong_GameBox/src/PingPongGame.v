module PingPongGame (
    input clk,
    input rst,
    input key_player1,
    input key_player2,
    output [7:0] position,
    output driver_pin_1,
    output driver_pin_2,
    output driver_pin_3
);

wire clk_2Hz;   // 用于乒乓球的位移
wire clk_1kHz;  // 用于数码管位选信号的动态切换
wire key_player1_eff;   // 甲有效按键脉冲
wire key_player2_eff;   // 乙有效按键脉冲
wire [3:0] score_player1;   // 甲分数
wire [3:0] score_player2;   // 乙分数

// 生成分频时钟
divider_clk inst_divider_clk(
    .rst(rst), 
    .clk(clk), 
    .clk_new1(clk_2Hz),
    .clk_new2(clk_1kHz)
);

// 按键的按键检测和转化（低有效）
key_filter inst_key_filter(
    .clk(clk), 
    .rst(rst), 
    .key_1(key_player1), 
    .key_2(key_player2), 
    .key1_effPulse(key_player1_eff),
    .key2_effPulse(key_player2_eff)
);

// gameCtrl模块的例化
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

// 分数显示模块的例化
disp_scores inst_disp_scores(
    .clk(clk), 
    .clk_1kHz(clk_1kHz),
    .rst(rst), 
    .cnt1(score_player1), 
    .cnt2(score_player2), 
	.driver_pin_1(driver_pin_1),        
	.driver_pin_2(driver_pin_2),
	.driver_pin_3(driver_pin_3)
);
endmodule