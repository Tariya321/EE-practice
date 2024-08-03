%定义一个可以复用的函数，作用是针对输入的不同fs参数自动完成抽样信号的信号波形
function mysample(fs,flag)  %参数flag为图像标号
dt=0.0002;
t=-0.4:dt:0.4;
xt=0.02*(1+0.4*cos(60*pi.*t))./(0.0001+t.^2);   
Ts=1/fs;
N_ts=floor(Ts/dt);
xs=zeros(size(xt));
for k=1:length(xt)
    if (mod((k-1),N_ts)==0)
        xs(k)=xt(k);
    end
end
figure(flag);
plot(t,xt,'g','LineWidth',1);
if fs==200
    title('高抽样后的时域波形','Fontsize',16)    %下一步的工作：将原信号绘在此图中
else
    title('低抽样后的时域波形','Fontsize',16)
end
hold on;grid on;
stem(t, xs,'LineWidth',1,'MarkerSize',3);   %时域上抽样（无滤波）对比
legend('原信号','抽样信号')
xlabel('t')
ylabel('value')

%对抽样信号fft
figure(flag+1);
N_fft=length(t);
df=1/(N_fft*dt);
Faxis=df*((1:N_fft)-N_fft/2);
Fs=(N_ts*dt)*fftshift(fft(xs));
plot(Faxis,abs(Fs))
if fs==200
    title('高抽样信号的频谱','Fontsize',16)
else
    title('低抽样信号的频谱','Fontsize',16)
end
xlabel('frequency')
ylabel('|F|')

%滤波
fc=fs/2;
H=(abs(Faxis)<fc);
Fc=H.*Fs;

%还原为时域
figure(flag+2);
xc=df*N_fft*ifft(ifftshift(Fc));
%时域上抽样（有滤波）对比
plot(t,xc,'LineWidth',1)
hold on;
plot(t,xt,'LineWidth',1)
legend('还原信号','原信号')
if fs==200
    title('高抽样并滤波后的时域波形','Fontsize',16)
else
    title('低抽样并滤波后的时域波形','Fontsize',16)
end
xlabel('t')
ylabel('value')
end
