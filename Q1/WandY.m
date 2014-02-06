function [ y ] = WandY( t )
%WANDY Summary of this function goes here
%   Detailed explanation goes here

if t <= 4
    y = 0.3*sin(2*pi*t/4);
elseif t <= 8
    y = (t-4)/8;
elseif t <= 12
    y = 0.5 - (t-8) / 16;
end

end

