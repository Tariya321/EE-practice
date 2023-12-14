// 分数合并和转换模块
module merger_score(
    input [3:0] cnt1,
    input [3:0] cnt2,
    output reg [15:0] disp_data
);

// 定义中间变量
reg [7:0] cnt1_BCD;
reg [7:0] cnt2_BCD;

// 甲选手分数信息
always @(cnt1)
    case(cnt1)
        4'b1010: cnt1_BCD = {4'b1, 4'b0};   // 10分
        4'b1011: cnt1_BCD = {4'b1, 4'b1};   // 11分
        default: cnt1_BCD = {4'b0, cnt1};
    endcase

// 乙选手分数信息
always @(cnt2)
    case(cnt2)
        4'b1010: cnt2_BCD = {4'b1, 4'b0};
        4'b1011: cnt2_BCD = {4'b1, 4'b1};
        default: cnt2_BCD = {4'b0, cnt2};
    endcase

// 数据合并
always @(cnt1_BCD or cnt2_BCD)
    disp_data = {cnt1_BCD, cnt2_BCD};

endmodule