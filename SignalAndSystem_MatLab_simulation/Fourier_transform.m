dT=0.001;
t=-1.5:dT:1.5;
xt=ur(t+0.5)+9*ur(t+0.1)-20*ur(t)+9*ur(t-0.1)+ur(t-0.5);

figure(1);   %���xtʱ����
subplot(3,1,1);
plot(t,xt,'LineWidth',2);
title('ʱ���ź�')
hold on;
N_fft=length(t);
df=1/(dT*N_fft); 
Faxis=df*((1:N_fft)-ceil(N_fft/2)); %����Ƶ����
Fshift=dT*fftshift(fft(xt));
power=abs(Fshift);
theta=angle(Fshift)/pi*180;
subplot(3,1,2);
plot(Faxis,abs(Fshift),LineWidth=1);     %���Ƴ�������
xlim([-20,20])
title('������')
hold on;
subplot(3,1,3);
plot(Faxis,theta);     %���Ƴ���λ��
title('��λ��')

figure(2);
Pshift=0.1*(12-50)*Faxis;       %����λ������������Ƶ�ʵ���λ�ƶ����ȹ�����ѧ�Ź��������ƴ�С
Fshift_p=Fshift.*exp(1j*Pshift);   %Ƶ��λ��
xt_p=df*N_fft*ifft(ifftshift(Fshift_p));
plot(t,xt_p,'LineWidth',2)
hold on;
plot(t,xt,'LineWidth',2);
xlabel('t')
ylabel('value')
title('ʱ���ź�','Fontsize',16)
legend('ʱ�ƺ���ź�','ԭ�ź�')

%�������źű�������ź�
figure(3); 
title('k=1','Fontsize',14)
subplot(2,2,1);
plot(Faxis,abs(Fshift),LineWidth=1);
title('ԭ�źŵķ�����','FontSize',16)
xlim([-15,15])

Taxis5=-1.5*5:dT:1.5*5;
t=-1.5*5:dT:1.5*5;
xt5=zeros(size(t));
xt5=ur(t+0.5)+9*ur(t+0.1)-20*ur(t)+9*ur(t-0.1)+ur(t-0.5);
for k=1:5
xt5=xt5+ur(t+0.5-3*k)+9*ur(t+0.1-3*k)-20*ur(t-3*k)+9*ur(t-0.1-3*k)+ur(t-0.5-3*k);
xt5=xt5+ur(t+0.5+3*k)+9*ur(t+0.1+3*k)-20*ur(t+3*k)+9*ur(t-0.1+3*k)+ur(t-0.5+3*k);
end
N_fft5=length(Taxis5);
df5=1/(dT*N_fft5);
Faxis5=df5*((1:N_fft5)-N_fft5/2);
Fw5=dT*fftshift(fft(xt5));
xf5=abs(Fw5);
xp5=angle(Fw5);
subplot(2,2,2);
plot(Faxis5,xf5);     %5����ķ�����
title('k=5','Fontsize',14)
xlim([-15,15])
hold on;

Taxis11=-1.5*11:0.001:1.5*11;
t=-1.5*11:0.001:1.5*11;
xt11=zeros(size(t));
xt11=ur(t+0.5)+9*ur(t+0.1)-20*ur(t)+9*ur(t-0.1)+ur(t-0.5);
for k=1:11
xt11=xt11+ur(t+0.5-3*k)+9*ur(t+0.1-3*k)-20*ur(t-3*k)+9*ur(t-0.1-3*k)+ur(t-0.5-3*k);
xt11=xt11+ur(t+0.5+3*k)+9*ur(t+0.1+3*k)-20*ur(t+3*k)+9*ur(t-0.1+3*k)+ur(t-0.5+3*k);
end
N_fft11=length(Taxis11);
df11=1/(dT*N_fft11);
Faxis11=df11*((1:N_fft11)-N_fft11/2);
Fw11=dT*fftshift(fft(xt11));
xf11=abs(Fw11);
xp11=angle(Fw11);
subplot(2,2,3);
plot(Faxis11,xf11);     %11����ķ�����
title('k=11','Fontsize',14)
xlim([-15,15])
hold on;

Taxis101=-1.5*101:0.001:1.5*101;
t=-1.5*101:0.001:1.5*101;
xt101=zeros(size(t));
xt101=ur(t+0.5)+9*ur(t+0.1)-20*ur(t)+9*ur(t-0.1)+ur(t-0.5);
for k=1:101
xt101=xt101+ur(t+0.5-3*k)+9*ur(t+0.1-3*k)-20*ur(t-3*k)+9*ur(t-0.1-3*k)+ur(t-0.5-3*k);
xt101=xt101+ur(t+0.5+3*k)+9*ur(t+0.1+3*k)-20*ur(t+3*k)+9*ur(t-0.1+3*k)+ur(t-0.5+3*k);
end
N_fft101=length(Taxis101);
df101=1/(dT*N_fft101);
Faxis101=df101*((1:N_fft101)-N_fft101/2);
Fw101=dT*fftshift(fft(xt101));
Fshift101=abs(Fw101);
subplot(2,2,4);
plot(Faxis101,Fshift101);     %101����ķ�����
title('k=101','Fontsize',14)
xlim([-15,15])