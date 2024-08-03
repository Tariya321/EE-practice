function chapt4  %参数flag：0表示floor方法，1表示ceil方法
fs=80;
dt=0.0002;
t=-0.4:dt:0.4;
xt=0.02*(1+0.4*cos(60*pi.*t))./(0.0001+t.^2);   
Ts=1/fs;
N_tsf=floor(Ts/dt);
N_tsc=ceil(Ts/dt);
xsf=zeros(size(xt));
xsc=zeros(size(xt));
for k=1:length(xt)
    if (mod((k-1),N_tsf)==0)
        xsf(k)=xt(k);
    end
end
for k=1:length(xt)
    if (mod((k-1),N_tsc)==0)
        xsc(k)=xt(k);
    end
end
%subplot(1,2,1)
stem(t, xsf,'LineWidth',1,'MarkerSize',3)

hold on;
grid on;
%subplot(1,2,2)
stem(t, xsc,'LineWidth',1.5,'MarkerSize',3);   %时域上抽样（无滤波）对比
legend('floor方法','ceil方法','Fontsize',16)
%legend('ceil方法','Fontsize',16)
xlabel('t','FontSize',16)
ylabel('value','FontSize',16)
title('对比图','FontSize',22)