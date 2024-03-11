function [x2,y2] = convgauss(x,y,wid,lgth,elim)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
y=y(x>elim(1) & x<elim(2));
x=x(x>elim(1) & x<elim(2));
x2=linspace(elim(1),elim(2),lgth)';
fgauss=@(x,x0,wid) exp(-pi*(2*x-2*x0).^2/(0.5*wid*(pi/ log(2))^1/2).^2);
y2=zeros(lgth,1);
for i=1:length(y)
    y2=y2+y(i)*fgauss(x2,x(i),wid)./sum(fgauss(x2,x(i),wid))*lgth./length(x);
end
end