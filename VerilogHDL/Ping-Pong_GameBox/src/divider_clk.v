module divider_clk (
    input rst, 
    input clk, 
    output reg clk_new1,    // 2Hz
    output reg clk_new2     // 1kHz
);

reg [27:0] divider_cnt1;
reg [15:0] divider_cnt2;

parameter cnt_1 = 28'd249_999_999;  // 对应2Hz 28'b1110 1110 0110 1011 0010 0111 1111
parameter cnt_2 = 16'd49_999;        // 对应1kHz 16'b1100 0011 0100 1111

// 2Hz
always @(posedge clk or negedge rst) begin
    if(!rst)
        divider_cnt1 <= 28'b0;
    else if(divider_cnt1 == cnt_1)      // 满cnt后，下一个一个clk到来时清零
        divider_cnt1 <= 28'b0;          
    else
        divider_cnt1 <= divider_cnt1 + 1;
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        clk_new1 <= 0;
    else if(divider_cnt1 == cnt_1)
        clk_new1 <= 1;               // 每隔cnt个时钟输出一个高脉冲
    else
        clk_new1 <= 0;               // 这样做的目的是防止生成意外的锁存器
end

// 1kHz
always @(posedge clk or negedge rst) begin
    if(!rst)
        divider_cnt2 <= 16'b0;
    else if(divider_cnt2 == cnt_2)
        divider_cnt2 <= 16'b0;           
    else
        divider_cnt2 <= divider_cnt2 + 1;
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        clk_new2 <= 0;
    else if(divider_cnt2 == cnt_2)
        clk_new2 <= 1;               
    else
        clk_new2 <= 0;              
end
endmodule