function [ tn, robotn, thetan ] = robot(t, robot, theta, dt, v, delta)
%SIM1 Summary of this function goes here
%   Detailed explanation goes here
x = robot(1);
y = robot(2);
L = 0.3; %300mm

tn = t + dt;

if (delta < -30)
    delta = 30;
end

if (delta > 30)
    delta = 30;
end

delta = delta * pi / 180; %10000ms
% these ones need noise
thetan = theta + v*dt*tan(delta)/L + normrnd(0, (1*pi/180)*dt); %1 degree/s noise (std.dev)

while thetan > pi
    thetan = thetan - pi*2;
end
while thetan < -pi
    thetan = thetan + pi*2;
end
    
xn = x + v*dt * cos(theta) + normrnd(0, 0.02*dt); %20mm/s noise (std.dev)
yn = y + v*dt * sin(theta) + normrnd(0, 0.02*dt); %20mm/s noise (std.dev)

robotn = [xn; yn];

end