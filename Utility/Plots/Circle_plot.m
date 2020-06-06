function [] = Circle_plot(x,y,r,nr)
%CIRCLE Summary of this function goes here
%   Detailed explanation goes here
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
label=join(['R',string(nr),'=',string(r)]);
plot(xunit, yunit,'DisplayName',label);
end

