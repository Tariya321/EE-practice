%����һ�����Ը��õĺ������������������Ĳ�ͬfs�����Զ���ɳ����źŵ��źŲ���
function mysample(fs,flag)  %����flagΪͼ����
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
    title('�߳������ʱ����','Fontsize',16)    %��һ���Ĺ�������ԭ�źŻ��ڴ�ͼ��
else
    title('�ͳ������ʱ����','Fontsize',16)
end
hold on;grid on;
stem(t, xs,'LineWidth',1,'MarkerSize',3);   %ʱ���ϳ��������˲����Ա�
legend('ԭ�ź�','�����ź�')
xlabel('t')
ylabel('value')

%�Գ����ź�fft
figure(flag+1);
N_fft=length(t);
df=1/(N_fft*dt);
Faxis=df*((1:N_fft)-N_fft/2);
Fs=(N_ts*dt)*fftshift(fft(xs));
plot(Faxis,abs(Fs))
if fs==200
    title('�߳����źŵ�Ƶ��','Fontsize',16)
else
    title('�ͳ����źŵ�Ƶ��','Fontsize',16)
end
xlabel('frequency')
ylabel('|F|')

%�˲�
fc=fs/2;
H=(abs(Faxis)<fc);
Fc=H.*Fs;

%��ԭΪʱ��
figure(flag+2);
xc=df*N_fft*ifft(ifftshift(Fc));
%ʱ���ϳ��������˲����Ա�
plot(t,xc,'LineWidth',1)
hold on;
plot(t,xt,'LineWidth',1)
legend('��ԭ�ź�','ԭ�ź�')
if fs==200
    title('�߳������˲����ʱ����','Fontsize',16)
else
    title('�ͳ������˲����ʱ����','Fontsize',16)
end
xlabel('t')
ylabel('value')
end
