%如何定义存储波形的数组？
t = -0.5:0.001:7;

%不同级数的影响
f1=mysum(3,1);
f2=mysum(20,1);
f3=mysum(100,1);
figure(1);  %图一
subplot(2,2,1);
plot(t,f1,LineWidth=1)
xlabel('t')
ylabel('f(t)')
legend('k=3')
subplot(2,2,2);
plot(t,f2,LineWidth=1)
xlabel('t')
ylabel('f(t)')
legend('k=20')
subplot(2,2,3);
plot(t,f3,LineWidth=1)
xlabel('t')
ylabel('f(t)')
legend('k=100')
sgtitle('不同级数对合成波形的影响');

%幅度失真
f4=mysum(500,21);
f5=mysum(500,22);
figure(2);
subplot(1,2,1);
plot(t,f4,LineWidth=1)
subplot(1,2,2);
plot(t,f5,LineWidth=1)
title('幅度失真','Fontsize',16)

%相位失真
f6=mysum(500,31);
f7=mysum(500,32);
figure(3);
subplot(1,2,1);
plot(t,f6,LineWidth=1)
subplot(1,2,2);
plot(t,f7,LineWidth=1)
title('相位失真','Fontsize',16)

%filter
RC1=0.1;
RC2=0.3;
RC3=1;
RC4=3;
figure(4);
plot(t,filter(RC1),LineWidth=2)
hold on;
plot(t,filter(RC2),LineWidth=2)
hold on;
plot(t,filter(RC3),LineWidth=2)
hold on;
plot(t,filter(RC4),LineWidth=2)
legend('RC=0.1','RC=0.3','RC=1','RC=3')
title('filter','Fontsize',16);
hold off

%定义求和函数
function ms=mysum(N,flag)   %flag用于定义两种题目要求的计算方式,0表示无相移的
t = -0.5:0.001:7;
if flag==1
    ms=0.5;
    for n=0:N
        ms=ms+ (2/pi) * sin((2*n+1).*t)/(2*n+1);
    end
elseif flag==21
    ms=0.25;
    for n=0:N
        ms=ms+ (1/pi) * sin((2*n+1).*t)/(2*n+1);    %所有分量变为原来的1/2
    end
elseif flag==22
    ms=0.5;
    for n=0:N
        if n==1     %将k=1对应谐波缩小
            ms=ms+ 0.05*(2/pi) * sin((2*n+1).*t)/(2*n+1);
        else
           ms=ms+ (2/pi) * sin((2*n+1).*t)/(2*n+1); 
        end
    end
elseif flag==31
    ms=0.5;
    for n=0:N
        ms=ms+ (2/pi) * sin((2*n+1).*t+(2*n+1)*pi/3)/(2*n+1);   %均附加相移
    end
elseif flag==32
    ms=0.5;
    for n=0:N
        if n==1
            ms=ms+ (2/pi) * sin((2*n+1).*t+pi)/(2*n+1);
        else
            ms=ms+ (2/pi) * sin((2*n+1).*t)/(2*n+1);    %k=1处附加相移
        end
    end
end

end

function ms=filter(product)
t = -0.5:0.001:7;
N=500;
ms=0.5;
for n=0:N
    b=((2*n+1)*product)^2;
    A=1/sqrt(1+b);
    ms=ms+ (2/pi) *A* sin(((2*n+1).*t-atan((2*n+1)*product)))/(2*n+1);
end
end