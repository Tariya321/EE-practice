/*
clk     系统时钟信号, 50MHz
clk_1k  扫描时钟信号, 1kHz, 控制位选时间
sel_r   循环位选信号
disp_data[15:0]   显示数值(4*4位)
rst     数码管复位信号

divider_cnt 分频计数器
data_temp   每个刷新周期的显示数据
seg     根据数据译得的共阳极编码
driver_pin_x 驱动芯片的三个引脚
*/

module disp_scores(
    input clk, 
    input clk_1kHz,
    input rst, 
    input [3:0] cnt1, 
    input [3:0] cnt2, 
    output driver_pin_1, 
    output driver_pin_2, 
    output driver_pin_3
);

wire [6:0] seg;
wire [3:0] sel;
wire [15:0] disp_data;

// 合并分数并生成BCD码
merger_score inst_merger_score(
    .cnt1(cnt1),
    .cnt2(cnt2),
    .disp_data(disp_data)
);

// 得到周期变化的译码信息
encoder_dispData inst_encoder_disp(
    .rst(rst), 
    .clk(clk_1kHz), 
    .disp_data(disp_data),
    .seg(seg), 
    .sel(sel)
);

// 送入驱动芯片hc595
hc595_driver inst_hc595Driver(
    .clk(clk),   
	.rst(rst),
	.data({1'b1, seg, 4'b0, sel}),      // 因为这里我们只用了4个数码管, sel只有4位
	.s_en(1'b1),           
	.sh_cp(driver_pin_1),               // 驱动芯片的三个引脚
	.st_cp(driver_pin_2),
	.ds(driver_pin_3)
);

endmodule