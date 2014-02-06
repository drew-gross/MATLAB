% Gyro data reproduction

load('gyro.mat');

% Convert to degrees
gx = 180/pi*gx;
gy = 180/pi*gy;
gz = 180/pi*gz;

% Assume underlying motion is negligible, and measurements are independent
S = cov([gx gy gz]);
[SE,Se] = eig(S);

% Create a reproduction of gyro data
g_sim = SE*sqrt(Se)*randn(3,length(gx));

% Plot data for a certain time
tmin = 10;
tmax = 20;
t1= find(tg>tmin,1);
t2= find(tg>tmax,1);

figure(1);clf;
subplot(2,1,1); hold on;
plot(tg(t1:t2), gx(t1:t2), 'b--');
plot(tg(t1:t2), gy(t1:t2), 'r--');
plot(tg(t1:t2), gz(t1:t2), 'g--');
axis([tmin tmax -60 60])
title('Original Data')
xlabel('Time(s)')
ylabel('Rate (deg/s)')
subplot(2,1,2); hold on;
plot(tg(t1:t2), g_sim(1,(t1:t2)), 'b');
plot(tg(t1:t2), g_sim(2,(t1:t2)), 'r');
plot(tg(t1:t2), g_sim(3,(t1:t2)), 'g');
axis([tmin tmax -60 60]);
xlabel('Time(s)')
ylabel('Rate (deg/s)')
title('Unfiltered simulation')


% Moving average filter and subtract average from measurments
f_len = 3;
gxf = filter(ones(1,f_len)/f_len,1,gx);
gyf = filter(ones(1,f_len)/f_len,1,gy);
gzf = filter(ones(1,f_len)/f_len,1,gz);

ex = gx-gxf;
ey = gy-gyf;
ez = gz-gzf;

Sf = cov([ex ey ez]);
[SfE, Sfe]=eig(Sf);

% Create a reproduction of gyro data
g_simf = SfE*sqrt(Sfe)*randn(3,length(gxf));

% Plot data for a certain time
tmin = 10;
tmax = 20;
t1= find(tg>tmin,1);
t2= find(tg>tmax,1);

figure(2);clf;
subplot(2,1,1); hold on;
plot(tg(t1:t2), gx(t1:t2), 'b--');
plot(tg(t1:t2), gy(t1:t2), 'r--');
plot(tg(t1:t2), gz(t1:t2), 'g--');
axis([tmin tmax -60 60])
title('Original Data')
xlabel('Time(s)')
ylabel('Rate (deg/s)')
subplot(2,1,2); hold on;
subplot(2,1,2); hold on;
plot(tg(t1:t2), gxf(t1:t2)'+g_simf(1,t1:t2), 'b');
plot(tg(t1:t2), gyf(t1:t2)'+g_simf(2,t1:t2), 'r');
plot(tg(t1:t2), gzf(t1:t2)'+g_simf(3,t1:t2), 'g');
axis([tmin tmax -60 60]);
title('Filtered simulation')
xlabel('Time(s)')
ylabel('Rate (deg/s)')
