dT=0.001;
Taxis5=-1.5*5:dT:1.5*5;
t=-1.5*5:dT:1.5*5;
xt5=zeros(size(t));
xt5=ur(t+0.5)+9*ur(t+0.1)-20*ur(t)+9*ur(t-0.1)+ur(t-0.5);
for k=1:5
xt5=xt5+ur(t+0.5-0.8*k)+9*ur(t+0.1-0.8*k)-20*ur(t-0.8*k)+9*ur(t-0.1-0.8*k)+ur(t-0.5-0.8*k);
xt5=xt5+ur(t+0.5+0.8*k)+9*ur(t+0.1+0.8*k)-20*ur(t+0.8*k)+9*ur(t-0.1+0.8*k)+ur(t-0.5+0.8*k);
end
N_fft5=length(Taxis5);
df5=1/(dT*N_fft5);
Faxis5=df5*((1:N_fft5)-N_fft5/2);
Fw5=dT*fftshift(fft(xt5));
xp5=angle(Fw5);
subplot(1,2,1)
plot(Faxis5,abs(Fw5),LineWidth=1.5)
legend('时域有交叠','Fontsize',22)
xlim([-15,15])

xt5s=ur(t+0.5)+9*ur(t+0.1)-20*ur(t)+9*ur(t-0.1)+ur(t-0.5);
for k=1:5
xt5s=xt5s+ur(t+0.5-3*k)+9*ur(t+0.1-3*k)-20*ur(t-3*k)+9*ur(t-0.1-3*k)+ur(t-0.5-3*k);
xt5s=xt5s+ur(t+0.5+3*k)+9*ur(t+0.1+3*k)-20*ur(t+3*k)+9*ur(t-0.1+3*k)+ur(t-0.5+3*k);
end
Fw5s=dT*fftshift(fft(xt5s));
subplot(1,2,2)
plot(Faxis5,abs(Fw5s),LineWidth=1.5)
sgtitle('对比图','Fontsize',24,color='r')
legend('时域无交叠','Fontsize',22)
xlim([-15,15])

