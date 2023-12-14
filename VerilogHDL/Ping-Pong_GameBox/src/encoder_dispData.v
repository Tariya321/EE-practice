module encoder_dispData (
    input rst, 
    input clk,      // 注意其时钟信号为clk_1k
    input [15:0] disp_data,
    output reg [6:0] seg, 
    output reg [3:0] sel
);

// 中间变量定义
reg [3:0] data_temp;

// 实现位选
always @(posedge clk or negedge rst) begin
    if (!rst)
        sel <= 4'b0001;
    else if(sel == 4'b1000)     
        sel <= 4'b0001;      
    else
        sel <= sel << 1;        // 左移, 实现顺序位选
end

always@(disp_data or sel) 
    case(sel) 
        4'b0001:data_temp = disp_data[3:0]; 
        4'b0010:data_temp = disp_data[7:4]; 
        4'b0100:data_temp = disp_data[11:8]; 
        4'b1000:data_temp = disp_data[15:12]; 
        default:data_temp = 4'b0000; 
    endcase

// 显示数据译码---查找表LUT
always @(data_temp)
    case(data_temp)
        4'h0:seg = 7'b1000000; 
        4'h1:seg = 7'b1111001; 
        4'h2:seg = 7'b0100100; 
        4'h3:seg = 7'b0110000; 
        4'h4:seg = 7'b0011001; 
        4'h5:seg = 7'b0010010; 
        4'h6:seg = 7'b0000010; 
        4'h7:seg = 7'b1111000; 
        4'h8:seg = 7'b0000000; 
        4'h9:seg = 7'b0010000;
        default:seg = 7'b0000001;   // 一个横杠，只有计数错误时才会产生，这里只是为了防止生成一个意外的锁存器
    endcase
endmodule