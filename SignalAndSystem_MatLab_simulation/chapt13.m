f=[];
for n=1:10
    if (mod(n,2)==0)
        f(n)=0;     %偶次项为0
    else
        f(n)=8/(n*pi);  
    end
end
k=1:10;
stem(k,f,LineWidth=2)
xlabel('k','FontSize',16)
ylabel('value','FontSize',16)
title('Plot of Value','FontSize',20)

