t0 = -2:0.01:4;
t1 = -4:0.01:8; %f3的定义域，由convolution theorem得到
f1 = -2.*(us(t0-0.5)-us(t0-2));
f2 = (2.*t0+2).*(us(t0+1)-us(t0-2)); %需要考虑使用t0是否会发生重复调用的问题
f3 = 0.01*conv(f1,f2); %这里0.01是本次选取的时间间隔
figure(1);
plot(t0,f1,t0,f2,t1,f3,LineWidth=1.5)
xlabel('t')
ylabel('f')
title('Plot of the Convolution','FontSize',14)
legend('f1','f2','f3')

figure(2);
f=-2*(t1+0.5).^2.*us(t1+0.5)+2*(t1-1).^2.*us(t1-1)+2*(t1-2.5).^2.*us(t1-2.5)-2*(t1-4).^2.*us(t1-4)+12*(t1-2.5).*us(t1-2.5)-12*(t1-4).*us(t1-4);
plot(t1,f3,t1,f,LineWidth=1.5)
title('卷积对比','FontSize',16)
xlabel('t')
ylabel('f')
legend('f3','f')

figure(3);
f4 = 0.01*conv(f1,f1);
plot(t0,f1,t1,f4,LineWidth=1.5)
xlabel('t')
ylabel('f')
title('矩形脉冲自卷积','FontSize',14)
legend('f1','f4')