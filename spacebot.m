%% Spacebot
% Includes a KF and LQR
clear; clc;
%% Simulation setup
% Time
t0 = 0;
tf = 10;
dt = 0.5;
T = t0:dt:tf;
M = 20;

% Initial position
x0 = [2 0 2  0 2 0]';

% Desired position
xd = [10 0 4 0 5 0]';

%% Motion model

% State x = [x vx y vy z]
A=[1 dt 0 0 0 0; 0 1 0 0 0 0;
   0 0 1 dt 0 0; 0 0 0 1 0 0;
   0 0 0 0 1 dt; 0 0 0 0 0 1];

B=[0 0 0; dt/M 0 0; 0 0 0; 0 dt/M 0; 0 0 0; 0 0 dt/M];
n = length(A);
m = length(B(1,:));

%% Measurement model
C=[1 0 0 0 0 0; -1 0 0 0 0 0; 
   0 0 1 0 0 0; 0 0 -1 0 0 0;
   0 0 0 0 1 0; 0 0 0 0 -1 0];
q = length(C(1,:));
y_off = [ .50; -19.50; .50; -9.50; .50; -9.50];



%% LQR costs
Qc = 100*eye(n);
Rc = 0.1*eye(m);

%% Kalman covariances
Qe = 0.01*eye(n);
Re = 0.0001*eye(q);
[QeV, Qev] = eig(Qe);
[ReV, Rev] = eig(Re);
mu = x0;
S = 2*eye(n);

%% Simulation

% Setup storage variables
x = zeros(n,length(T));
x(:,1) = x0;
u = zeros(m,length(T)-1);
y = zeros(q,length(T));
mup_S = zeros(n,length(T));
mu_S = zeros(n,length(T));

P = zeros(n,n,length(T));
P_S(:,:,length(T)) = Qc;
Pn = P_S(:,:,length(T));

Ke_S = zeros(q,n,length(T));

%% Presolve for costate
for t=length(T)-1:-1:1
    P = Qc+A'*Pn*A - A'*Pn*B*inv(B'*Pn*B+Rc)*B'*Pn*A;
    P_S(:,:,t)=P;
    Pn=P;
end

%% Main loop
for t=2:length(T)-1
    %% LQR control with desired state offset
    Kc = inv(B'*P_S(:,:,t+1)*B + Rc)*B'*P_S(:,:,t+1)*A;
    u(:,t)= -Kc*(mu-xd);
    Kc_S(:,:,t) = Kc;
    
    %% Simulation of motion and measurements
    % Select a motion disturbance
    e = ReV*sqrt(Rev)*randn(n,1);
    % Update state
    x(:,t) = A*x(:,t-1)+ B*u(:,t) + e;

    % Take measurement
    % Select a motion disturbance
    d = QeV*sqrt(Qev)*randn(n,1);
    % Determine measurement
    y_raw(:,t) = C*x(:,t) + y_off  + d;
    % Modify measurements to use in KF
    y(:,t) = y_raw(:,t) - y_off;

    %% Kalman Filter Estimation
    % Prediction update
    mup = A*mu + B*u(:,t);
    Sp = A*S*A' + Re;

    % Measurement update
    Ke = Sp*C'*inv(C*Sp*C'+Qe);
    mu = mup + Ke*(y(:,t)-C*mup);
    S = (eye(n)-Ke*C)*Sp;
    
    % Store results
    mup_S(:,t) = mup;
    mu_S(:,t) = mu;
    Ke_S(:,:,t) = Ke;
    
end

%% Plot results
figure(1); hold on;
plot(x(1,2:t),x(3,2:t), 'ro--')
plot(mu_S(1,2:t),mu_S(3,2:t), 'bx--')
mu_pos = [mu(1) mu(3)];
S_pos = [S(1,1) S(1,3); S(3,1) S(3,3)];
error_ellipse(S_pos,mu_pos,0.75);
error_ellipse(S_pos,mu_pos,0.95);
title('True state and beliefs')
legend('State', 'Estimate')

figure(2); clf;
Ke_S2 = reshape(Ke_S, q*n,1,length(T));
plot(T,squeeze(Ke_S2)');
title('Kalman Gain')
figure(3); clf; hold on;
plot(T(1:end-1), u/100);
plot(T(1:end-1), xd*ones(1,length(T)-1)-x(:,1:end-1), '--')
title('Control Inputs and Errors')
