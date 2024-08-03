function [ y ] = Sa( x )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
if(x~=0)
    y=sin(x)./x;
else
    y=1;
end

end

