clear;clc; close all;
% Dubins car model, driving around a circle

%% Create AVI object
vidObj = VideoWriter('dubins.avi');
vidObj.Quality = 100;
vidObj.FrameRate = 5;
open(vidObj);


% Time
dt = 0.01;
t = 0:dt:3;

% Wheel radius
r = 1;

% Distance from wheel to center
l = 0.2;

% Wheel 1 angular velocity command
n = length(t);
phid1 = .2*ones(1,n);
phid1(round(end/3):end) = 1;

% Wheel 2 angular velocity command
phid2 = 1*ones(1,n);
phid2(round(end/3):end) = 0.2;


% Linear, Angular Velocity
v = r*(phid1 + phid2)/2;
w = r*(phid2 - phid1)/(2*l);

% Body motion integration
xi = [0; 0; 0];
for i=1:length(t)
    R = [cos(xi(3,i)) 0 0; sin(xi(3,i)) 0 0; 0 0 1];
    xdb = [v(i) 0 w(i)]';
    xdi = R*xdb;
    xi(:,i+1) = xi(:,i)+ xdi*dt;
end

figure(1);clf;
for i=1:2:length(xi)
    clf;hold on;
    drawcar(xi(1,i),xi(2,i),xi(3,i),0.1,1)
    plot(xi(1,1:i), xi(2,1:i), 'bx');
    axis equal;
    axis([-0.2 1 -0.2 1.0]);
    drawnow;
    writeVideo(vidObj, getframe(gcf));
end

close(vidObj);
