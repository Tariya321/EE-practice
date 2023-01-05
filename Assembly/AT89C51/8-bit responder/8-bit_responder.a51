; LCD相关位定义
RS BIT P2.5         ; 数据/命令
RW BIT P2.4         ; 读/写
E  BIT P2.3         ; 使能
BF BIT P0.7         ; 忙标志

; 主持人按键定义
KEY_TIME_SET BIT P3.1   ; 时间设置
KEY_HOST     BIT P3.2   ; 启动或手动复位（中断内使用）

; 选手按键位定义
KEY_PLAYER_1 BIT P1.0
KEY_PLAYER_2 BIT P1.1
KEY_PLAYER_3 BIT P1.2
KEY_PLAYER_4 BIT P1.3
KEY_PLAYER_5 BIT P1.4
KEY_PLAYER_6 BIT P1.5
KEY_PLAYER_7 BIT P1.6
KEY_PLAYER_8 BIT P1.7

; 其它位定义
GND_MATRIX_KEY BIT P3.7    ; 提供矩阵键盘低电平
; F0：复用标志位，设置时间阶段为启动标志，等待复位阶段为复位标志

ORG 0000H
AJMP MAIN
ORG 0003H
AJMP INT_0
ORG 0050H                  
MAIN:         
    MOV DPTR, #TAB          
    CLR GND_MATRIX_KEY          ; 提供矩阵键盘低电平
    CLR F0                      ; 约定的检测标志位
RESET:                  ; 复位
    CLR TR1                     ; 关闭时钟
    ACALL INIT_LCD              ; LCD初始化
    ACALL INIT_TIMER            ; 定时器初始化
    SETB EA
    ACALL TIME_SET              ; 设置抢答时间和等待启动
    CLR EA
START:                  ; 启动
    ACALL BEEP_HALF_SECOND      ; 启动提示音
    SETB TR1                    ; 启动倒计时
    ACALL SCAN_KEY              ; 开始选手按键扫描
JUDGE:
    JBC F0, RESET               ; F0=1，则为手动复位，转RESET
    ACALL BEEP_HALF_SECOND                    
    AJMP RESET                  ; 否则为无人响应，蜂鸣器响0.5s后自动复位  
;**************************************************************************;
INIT_LCD:
    ACALL DELAY_0           ; 使能后需等待高电平建立
    MOV R0, #38H            ; 设置16X2显示，5×7点阵，8位数据接口
    ACALL W_CONTROL
    MOV R0, #0CH            ; 设置开显示，不显示光标
    ACALL W_CONTROL
    MOV R0, #06H            ; 写一个字符后地址指针加1
    ACALL W_CONTROL
    MOV R0, #01H            ; 显示清0，数据指针清0
    ACALL W_CONTROL
    RET
;**************************************************************************;
INIT_TIMER:
    MOV TMOD, #10H              ; 使用定时器1，选择工作方式1定时
    MOV R4, #1CH                ; 循环计数值28，配合定时器计时1s
    CLR IT0                     ; 设置外部中断0为跳变沿触发
    SETB EX0            
    RET
;**************************************************************************;
TIME_SET:
CLEAR: 
    MOV R5, #00H                    ; R5清零
    ACALL LCD_ROW1                  ; LCD第一行显示当前设置的时间
L1_TIME_SET:   
    JBC F0, BACK_FROM_TIME_SET      ; F0有效，则退出时间设置，启动
    JNB KEY_TIME_SET, RECONFIRM_TIME_SET            ; 若检测到时间设置按键按下，则延时再确认
    AJMP L1_TIME_SET
RECONFIRM_TIME_SET:
    ACALL DELAY_0         
    JNB KEY_TIME_SET, RECONFIRM_TURE_TIME_SET       ; 仍为按下，则为有效按键
    AJMP  L1_TIME_SET
RECONFIRM_TURE_TIME_SET:  
    JNB KEY_TIME_SET, $                     ; 松开按键后才进行下一步操作
    INC R5                                  ; 每检测一次有效按下，R5加1
    CJNE R5, #31, DISP_THEN_TIME_SET        ; R5超过30则清零
    AJMP CLEAR
DISP_THEN_TIME_SET:                         ; 显示增1之后的时间值
    ACALL LCD_ROW1
    AJMP L1_TIME_SET
BACK_FROM_TIME_SET:
    RET         
;*************************************************************************;
INT_0:                              ; 中断服务子程序：确认有效才置位F0
    JNB KEY_HOST, RECONFIRM_INT0    
    RETI
RECONFIRM_INT0:
    ACALL DELAY_0
    JNB KEY_HOST, WAIT_LOOSE_INT0
    RETI
WAIT_LOOSE_INT0:
    JNB KEY_HOST, $
    SETB F0                         ; 设定的START、RESET标志位
BACK_FROM_INT0:
    RETI
;************************************************************************;
SCAN_KEY: 
K0:
    JBC TF1, DEAL0              ; 查询定时器是否溢出，溢出则跳转到处理分支
    AJMP NO_DEAL0
DEAL0:
    ACALL DEAL_TIME
    CJNE R5, #00H, NO_DEAL0
    AJMP BACK_FROM_K0           ; 若R5=0，则表示无人应答，应退出子程序，警报后复位
NO_DEAL0:      
    JNB KEY_PLAYER_1, DISP_0            ; 判断是否按下
    AJMP K1                             ; 否则转去检测下一个按键，进行循环扫描
DISP_0:                         ; 显示选手编号和抢答时间
    SETB EA             ; 开EA，允许事件触发中断置位F0
    CLR TR1             ; 暂停时钟
    MOV R2, #01H
    ACALL LCD           ; 屏幕显示
    JNB F0, $           ; 等待复位，F0=1时退出SCAN_KEY
    CLR EA
BACK_FROM_K0:
    RET
;*********************************************************
K1:  
    JBC TF1, DEAL1      
    AJMP NO_DEAL1
DEAL1:
    ACALL DEAL_TIME   
    CJNE R5, #00H, NO_DEAL1
    AJMP BACK_FROM_K1         
NO_DEAL1:  
    JNB KEY_PLAYER_2, DISP_1
    AJMP K2
DISP_1:
    SETB EA      
    CLR TR1         
    MOV R2, #02H
    ACALL LCD        
    JNB F0, $ 
    CLR EA    
BACK_FROM_K1:
    RET
;********************************************************************
K2:
    JBC TF1, DEAL2             
    AJMP NO_DEAL2
DEAL2:
    ACALL DEAL_TIME   
    CJNE R5, #00H, NO_DEAL2
    AJMP BACK_FROM_K2        
NO_DEAL2:
    JNB KEY_PLAYER_3, DISP_2
    AJMP K3
DISP_2:
    SETB EA    
    CLR TR1      
    MOV R2, #03H
    ACALL LCD       
    JNB F0, $
    CLR EA    
BACK_FROM_K2:
    RET
;************************************************************************
K3:
    JBC TF1, DEAL3       
    AJMP NO_DEAL3
DEAL3:
    ACALL DEAL_TIME 
    CJNE R5, #00H, NO_DEAL3
    AJMP BACK_FROM_K3    
NO_DEAL3:
    JNB KEY_PLAYER_4, DISP_3
    AJMP K4
DISP_3:
    SETB EA     
    CLR TR1         
    MOV R2, #04H
    ACALL LCD    
    JNB F0, $ 
    CLR EA       
BACK_FROM_K3:
    RET
;*******************************************************************
K4:
    JBC TF1, DEAL4          
    AJMP NO_DEAL4
DEAL4:
    ACALL DEAL_TIME  
    CJNE R5, #00H, NO_DEAL4
    AJMP BACK_FROM_K4  
NO_DEAL4:
    JNB KEY_PLAYER_5, DISP_4
    AJMP K5
DISP_4:
    SETB EA       
    CLR TR1         
    MOV R2, #05H
    ACALL LCD          
    JNB F0, $    
    CLR EA    
BACK_FROM_K4:
    RET
;*******************************************************************
K5:
    JBC TF1, DEAL5             
    AJMP NO_DEAL5
DEAL5:
    ACALL DEAL_TIME       
    CJNE R5, #00H, NO_DEAL5
    AJMP BACK_FROM_K5  
NO_DEAL5:
    JNB KEY_PLAYER_6, DISP_5
    AJMP K6
DISP_5:
    SETB EA    
    CLR TR1     
    MOV R2, #06H
    ACALL LCD      
    JNB F0, $    
    CLR EA  
BACK_FROM_K5:
    RET
;*****************************************************************
K6:
    JBC TF1, DEAL6     
    AJMP NO_DEAL6
DEAL6:
    ACALL DEAL_TIME      
    CJNE R5, #00H, NO_DEAL6
    AJMP BACK_FROM_K6      
NO_DEAL6:
    JNB KEY_PLAYER_7, DISP_6
    AJMP K7
DISP_6:
    SETB EA        
    CLR TR1           
    MOV R2, #07H
    ACALL LCD        
    JNB F0, $   
    CLR EA    
BACK_FROM_K6:
    RET
;**********************************************************
K7:
    JBC TF1, DEAL7              ; 查询到中断标志位有效，则清除标志位后跳转
    AJMP NO_DEAL7
DEAL7:
    ACALL DEAL_TIME          
    CJNE R5, #00H, NO_DEAL7
    AJMP BACK_FROM_K7         
NO_DEAL7:
    JNB KEY_PLAYER_8, DISP_7
    AJMP K0
DISP_7:              
    SETB EA             
    CLR TR1             
    MOV R2, #08H
    ACALL LCD          
    JNB F0, $  
    CLR EA        
BACK_FROM_K7:
    RET
;**************************************************************************;
DEAL_TIME:            ; TF=1时刷新倒计时并重装载
    DJNZ R4, BACK_FROM_DEAL_TIME    ; 若R4到0，则刷新时间值
    CLR TR1
    MOV R4, #1CH 
    DEC R5                          ; 剩余时间减1
    ACALL LCD_ROW1                  ; 刷新倒计时                   
    SETB TR1
BACK_FROM_DEAL_TIME: 
    RET
;**************************************************************************;
LCD:                        ; 显示当前剩余时间和选手编号
    ACALL LCD_ROW1
    ACALL LCD_ROW2
    RET

LCD_ROW1:               ; 第一行开头，80H，用于显示倒计时时间
    MOV R0, #01H            ; 显示清0，数据指针清0
    ACALL W_CONTROL
    MOV R0, #80H            ; 00+偏移地址80H
    ACALL F_BUSY
    ACALL W_CONTROL         ; 第一行偏移地址（0——27H）第二行偏移地址（40-67h）
    MOV B, #02H             ; 配合定义的TABLE序列
    MOV A, R5               ; 取出R5中保存的当前剩余时间
    MUL AB
    MOVC A, @A+DPTR
    MOV R1, A               ; R1存放数据
    ACALL F_BUSY
    ACALL W_DATA
    MOV B, #02H
    MOV A, R5
    MUL AB
    INC A                   ; 指向下一个单元
    MOVC A, @A+DPTR
    MOV R1, A
    ACALL F_BUSY
    ACALL W_DATA
    RET

LCD_ROW2:               ; 第二行开头，80H+40H=0C0H. 用于显示竞答选手编号
    MOV R0, #0C0H           
    ACALL F_BUSY
    ACALL W_CONTROL
    MOV A, R2
    ADD A, #30H             ; 转换为ASCII码
    MOV R1, A
    ACALL F_BUSY              
    ACALL W_DATA
    RET    

W_CONTROL:                                        
    CLR RS              
    CLR RW              ; RS=RW=0，写命令
    CLR E
    MOV P0, R0      
    SETB E
    ACALL DELAY_1       ; 5ms高电平脉冲
    CLR E               
    RET

W_DATA:                 ; 写数据函数，调用它之前先把数据放到R1中                         
    SETB RS             
    CLR RW              ; 写数据
    ACALL DELAY_1
    MOV P0, R1          
    CLR E               ; 下跳沿触发写入
    RET

F_BUSY:                         ; 子程序功能：检测忙状态位D7
	SETB P0.7					; 读引脚前写1
    CLR RS
    SETB RW                     ; 读LCD状态
    SETB E
    ACALL DELAY_1         
    JB BF, $                    ; 忙标志为0时才可传输信息
    RET
;**************************************************************************;
BEEP_HALF_SECOND:   ; 蜂鸣器响0.5s
    CLR P3.6            ; 蜂鸣器开
    MOV R3, #50            
L1_BEEP:                
    MOV R6, #100      
L2_BEEP:
    MOV R7, #100
L3_BEEP:                
    DJNZ R7, L3_BEEP
    DJNZ R6, L2_BEEP
    DJNZ R3, L1_BEEP
    SETB P3.6           ; 蜂鸣器关
    RET
;**************************************************************************;
DELAY_0:                ; 延时15ms
    MOV R6, #60              
L2_DELAY_0:                
    MOV R7, #250      
L1_DELAY_0:                
    DJNZ R7, L1_DELAY_0
    DJNZ R6, L2_DELAY_0
    RET 

DELAY_1:                ; 延时5ms      
    MOV R6, #20             
L2_DELAY_1:                
    MOV R7, #250      
L1_DELAY_1:                
    DJNZ R7, L1_DELAY_1
    DJNZ R6, L2_DELAY_1
    RET
;**************************************************************************;
TAB: 
    DB "00010203040506070809101112131415161718192021222324252627282930"
END