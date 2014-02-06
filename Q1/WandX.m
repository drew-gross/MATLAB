function [ x ] = WandX( t )
%WANDX Summary of this function goes here
%   Detailed explanation goes here

if t <= 4
    x = t/8;
elseif t <= 8
    x = 0.5;
elseif t <= 12
    x = 0.5 - (t-8)/4;
end

end

