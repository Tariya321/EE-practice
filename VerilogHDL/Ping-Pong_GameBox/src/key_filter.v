module key_filter (
    input clk,        
    input rst,
    input key_1,
    input key_2,
    output reg key1_effPulse,
    output reg key2_effPulse
);

reg [19:0] cnt_1;
reg [19:0] cnt_2;

parameter key_delayPeriod = 20'd500_000 - 1;           // 系统时钟周期为20ns, 延时10ms需要500k个周期

// 甲按键
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt_1 <= 0;
        key1_effPulse <= 1;
    end
    else if(key_1 == 1) begin
        cnt_1 <= 0;
        key1_effPulse <= 1;
    end             
    else if(cnt_1 == key_delayPeriod) begin // 延时10ms期间, 按键仍有效
        key1_effPulse <= 0; 
        cnt_1 <= cnt_1 + 1;    
    end
    else if(cnt_1 == key_delayPeriod + 1)   // 关闭有效按键输出
        key1_effPulse <= 1;
    else                                    // 对应按键按下但未结束延时
        cnt_1 <= cnt_1 + 1;
end

// 乙按键
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt_2 <= 0;
        key2_effPulse <= 1;
    end
    else if(key_2 == 1) begin
        cnt_2 <= 0;
        key2_effPulse <= 1;
    end             
    else if(cnt_2 == key_delayPeriod) begin   
        key2_effPulse <= 0; 
        cnt_2 <= cnt_2 + 1;    
    end
    else if(cnt_2 == key_delayPeriod + 1)   
        key2_effPulse <= 1;
    else                                  
        cnt_2 <= cnt_2 + 1;
end

endmodule