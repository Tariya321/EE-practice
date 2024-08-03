t = -3:0.001:5;
f0=cosine(5);
subplot(1,2,1)
plot(t,f0,LineWidth=2)
title('k=5余弦波合成')
f=cosine(20);
subplot(1,2,2)
plot(t,f,LineWidth=2)
title('k=20余弦波合成')
function f=cosine(k)
t = -3:0.001:5;
f=1/2;
total=0;
for n=1:k
    a=1/n^2*(sin(n*pi/2))^2.*cos(n.*t);
    total=total+a;
end
f=f+4/pi^2*total;
end