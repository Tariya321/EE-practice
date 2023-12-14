module gameCtrl (
    input clk,              // 系统时钟
    input clk_2Hz,          // 乒乓球单点转移时钟
    input rst,              // 复位信号
    input key_player1_eff,      // 甲球员有效按键(低有效)
    input key_player2_eff,      // 乙球员有效按键(低有效)
    output reg [7:0] position,      // 乒乓球的位置信号
    output reg [3:0] score_player1, // 甲分数(最大为11)
    output reg [3:0] score_player2  // 乙分数(最大为11)
);

reg [8:0] state;
reg ball_invalid;           // 乒乓球在非法区域内
reg ball_out;               // 乒乓球出界信号
reg on_game;                // 乒乓球正在运动的信号
reg start_game;             // 乒乓球开始运动的信号

parameter idle = 9'b00000_0000;      // 空闲态, 等待击球
parameter s1 = 9'b00000_0001;        // 甲已发球态, 等待响应
parameter s2 = 9'b00000_0010;        // 乙已发球态, 等待响应
parameter s3 = 9'b00000_0100;        // 乙越网击球
parameter s4 = 9'b00000_1000;        // 乙正确击球
parameter s5 = 9'b00001_0000;        // 乙未击球
parameter s6 = 9'b00010_0000;        // 甲越网击球
parameter s7 = 9'b00100_0000;        // 甲正确击球
parameter s8 = 9'b01000_0000;        // 甲未击球
parameter s9 = 9'b10000_0000;        // 某方先拿到11分, 胜出

// on_game信号的切换
always @(posedge clk or negedge rst) begin
    if (!rst) 
        on_game <= 0;
    else
        case(state)
            idle: on_game <= 0;
            s1: on_game <= 1;
            s2: on_game <= 1;
            s3: on_game <= 0;
            s4: on_game <= 1;
            s5: on_game <= 0;
            s6: on_game <= 0;
            s7: on_game <= 1;
            s8: on_game <= 0;
            s9: on_game <= 0;
            default: on_game <= 0;
        endcase
end

// 开始游戏和状态切换
always @(posedge clk or negedge rst or posedge ball_invalid or negedge key_player1_eff or negedge key_player2_eff) begin
    if (!rst) begin
        state <= idle;
        start_game <= 0;
    end
    else if(score_player1 == 4'b1011 || score_player2 == 4'b1011)     // 一人先拿到满分, 暂停游戏、等待复位
        state <= s9;
    else
        case(state)
            idle: begin
                start_game <= 0;
                if(!key_player1_eff) begin
                    state <= s1;
                    start_game <= 1;
                end
                else if(!key_player2_eff) begin
                    state <= s2;
                    start_game <= 1;
                end
                else 
                    state <= idle;    // 循环等待
            end
            s1: begin
                start_game <= 0;
                if(ball_invalid)
                    state <= s3;
                else if(ball_out)
                    state <= s5;
                else if(!key_player2_eff)
                    state <= s4;
                else
                    state <= s1;
            end
            s2: begin
                start_game <= 0;
                if(ball_invalid)
                    state <= s6;
                else if(ball_out)
                    state <= s8;
                else if(!key_player1_eff)
                    state <= s7;
                else
                    state <= s2;
            end
            s3: state <= idle;
            s4: state <= s2;
            s5: state <= idle;
            s6: state <= idle;
            s7: state <= s1;
            s8: state <= idle;
            s9: state <= s9;        // 锁存等待系统复位rst
            default: state <= idle;
        endcase
end

// 得分的切换
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        score_player1 <= 4'b0;
        score_player2 <= 4'b0;
    end
    else
        case(state)
            s3: score_player1 <= score_player1 + 1;
            s5: score_player1 <= score_player1 + 1;
            s6: score_player2 <= score_player2 + 1;
            s8: score_player2 <= score_player2 + 1;
            default: begin
                score_player1 <= score_player1;
                score_player2 <= score_player2;
            end
        endcase
end

// 位置的切换
always @(posedge clk or negedge rst) begin
    if(!rst)
        position <= 0;
    else
    case(state)
        idle: position <= 0;
        s1: begin
            if(start_game)
                position <= 8'b1000_0000;
            else if(clk_2Hz)
                position <= position >> 1;
            else
                position <= position;
        end
        s2: begin
            if(start_game)
                position <= 8'b0000_0001;
            else if(clk_2Hz)
                position <= position << 1;
            else
                position <= position;
        end
        s4: begin
            if(clk_2Hz)
                position <= position << 1;
            else
                position <= position;
        end
        s7: begin
                if(clk_2Hz)
                position <= position << 1;
            else
                position <= position;
        end
        default: position <= 0;
    endcase
end

// 一个clk的ball_invalid
always @(posedge clk or negedge rst or negedge key_player1_eff or negedge key_player2_eff) begin
    if(!rst)
        ball_invalid <= 0;
    else if(clk)
        case(state)
            s1: begin
                if(!key_player2_eff) begin
                    if(position >= 8'b0001_0000)
                        ball_invalid <= 1;
                    else
                        ball_invalid <= 0;
                end
                else
                    ball_invalid <= 0;
            end
            s2: begin
                if(!key_player1_eff) begin
                    if(position <= 8'b0000_1000)
                        ball_invalid <= 1;
                    else
                        ball_invalid <= 0;
                end
                else
                    ball_invalid <= 0;
            end
            default: ball_invalid <= 0;
        endcase
    else
        ball_invalid <= ball_invalid;
end

// 一个clk的ball_out
always @(posedge clk or negedge rst) begin
    if(!rst)
        ball_out <= 0;
    else
        case (state)
            s1: begin
                if(on_game && position == 0)
                    ball_out <= 1;
                else
                    ball_out <= 0;
            end
            s2: begin
                if(on_game && position == 0)
                    ball_out <= 1;
                else
                    ball_out <= 0;
            end
            default: 
                ball_out <= 0;
        endcase
end

endmodule