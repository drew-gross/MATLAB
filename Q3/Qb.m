% Fast SLAM example
clear;clc;

figure(1);clf;hold on;

% Time
Tf = 20;
dt = 0.5;
T = 0:dt:Tf;

% Initial Robot State
x0 = [0 0 0]';

% Control inputs
u = ones(2, length(T));
u(2,:)=0.3*u(2,:);

% Motion Disturbance model
R = [0.001 0 0; 
     0 0.001 0; 
     0 0 0.0001];
[RE, Re] = eig(R);

%% Features.m map for Question 3 - FastSLAM with bad correspondences

% Annulus Feature Map
M1 = 30;
samples1 = rand(2,M1);
r1 = 4*samples1(1,:)+ 10;
ang1 = 2*pi*samples1(2,:);
M2 = 8;
samples2 = rand(2,M2);
r2 = 4*samples2(1,:);
ang2 = 2*pi*samples2(2,:);
map = [r1.*cos(ang1), (r2).*cos(ang2);r1.*sin(ang1), (r2).*sin(ang2)];
map(1,:) = map(1,:); 
map(2,:) = map(2,:)+5; 
plot(map(1,:),map(2,:),'bo')
M = M1+M2;

figure(1);clf; hold on;
cmap = colormap('jet');
cmap = cmap(1:3:end,:);
cn = length(cmap(:,1));
for j = 1:M
    plot(map(1,j),map(2,j),'o','Color', cmap(mod(j,cn)+1,:), 'MarkerSize',10,'LineWidth',2);
end
% Measurement model
rmax = 15;
thmax = pi/3;

% Feature initialization
newfeature = ones(M,1);

% Measurement noise
Qi = [0.001 0; 
     0 0.001];

[QiE, Qie] = eig(Qi);

% Simulation Initializations
n = length(R(:,1)); % Number of vehicle states
xr = zeros(n,length(T)); % Vehicle states 
xr(:,1) = x0;
m = length(Qi(:,1)); % Number of measurements per feature 
N = n+m*M;
y = zeros(m,M,length(T)); % Measurements

% Particles
D = 200;% Number of particles
X = zeros(n,D); % Vehicle states
X0 = X; % Prior - known exactly
Xp = X; % Interim Vehicle states
mu = zeros(2,M,D); % Feature means
mup = mu; % Interim Feature means
S = zeros(2,2,M,D); % Feature covariances
Sp = S;  % Interim Feature covariances
% Initialization of Particle weights
w0 = 1/D; 
w = w0*ones(1,D);

particle_means = [];

feature_ids = 1:M;
feature_decriptors = zeros(1,M);
    
%% Main loop
for t=2:length(T)
    %% Simulation
    % Select a motion disturbance
    e = RE*sqrt(Re)*randn(n,1);
    % Update robot state
    xr(:,t) = [xr(1,t-1)+u(1,t)*cos(xr(3,t-1))*dt;
              xr(2,t-1)+u(1,t)*sin(xr(3,t-1))*dt;
              xr(3,t-1)+u(2,t)*dt] + e;

    % Define features that can be measured
    meas_ind = [];
    for i=1:M
        if(inview(map(:,i),xr(:,t),rmax,thmax))
            meas_ind=[meas_ind,i];
        end
    end
    
    % Take measurements
    for i = meas_ind
        % correspond the feature, with error
        measured_id = round(normrnd(i,0.2));
        if measured_id == 0
            measured_id = 1;
        end
        if measured_id == 39
            measured_id = 38;
        end
            
        if measured_id ~= i
            measured_feature = min(M, max(1,map(:,measured_id)));
            actual_feature = map(:,i);
            plot([actual_feature(1) measured_feature(1)],[actual_feature(2), measured_feature(2)],'r-');
            plot([xr(1,t), measured_feature(1)],[xr(2,t),measured_feature(2)], 'b-');
        end
        
        
        % Select a measurement disturbance
        delta = QiE*sqrt(Qie)*randn(m,1);
        % Determine measurement, add to measurement vector
        y(:,i,t) = [sqrt((map(1,measured_id)-xr(1,t))^2 + (map(2,measured_id)-xr(2,t))^2);
            atan2(map(2,measured_id)-xr(2,t),map(1,measured_id)-xr(1,t))-xr(3,t)] + delta;
    end
    
    %% Fast SLAM Filter Estimation

    % For each particle
    for d=1:D
        % Select a motion disturbance
        em = 3*RE*sqrt(Re)*randn(n,1);
        % Update full state
        Xp(:,d) = [X(1,d)+u(1,t)*cos(X(3,d))*dt;
                  X(2,d)+u(1,t)*sin(X(3,d))*dt;
                  X(3,d)+u(2,t)*dt] + em;

        % For each feature measured
        clear yw hmuw Qw;
        j=1; 
        for i=meas_ind      
            if (newfeature(i) == 1)
                % Feature initialization
                mup(1,i,d) = Xp(1,d)+y(1,i,t)*cos(y(2,i,t)+Xp(3,d));
                mup(2,i,d) = Xp(2,d)+y(1,i,t)*sin(y(2,i,t)+Xp(3,d));
                % Predicted range
                dx = mup(1,i,d)-Xp(1,d);
                dy = mup(2,i,d)-Xp(2,d);
                rp = sqrt((dx)^2+(dy)^2);
                % Calculate Jacobian
                Ht = [ dx/rp dy/rp; -dy/rp^2 dx/rp^2];
                Sp(:,:,i,d) = Ht\Qi*inv(Ht)';
              else
                % Measurement processing
                % Predicted range
                dx = mu(1,i,d)-Xp(1,d);
                dy = mu(2,i,d)-Xp(2,d);
                rp = sqrt((dx)^2+(dy)^2);
                % Calculate Jacobian
                Ht = [ dx/rp dy/rp; -dy/rp^2 dx/rp^2];
                % Calculate Innovation
                I = y(:,i,t)-[rp; (atan2(dy,dx) - Xp(3,d))];
                
                % Measurement update
                Q = Ht*S(:,:,i,d)*Ht' + Qi;
                K = S(:,:,i,d)*Ht'/Q;
                mup(:,i,d) = mu(:,i,d) + K*I;
                Sp(:,:,i,d) = (eye(2)-K*Ht)*S(:,:,i,d);

            end
            % Calculate predicted measurements and covariance for
            % weighting
            yw(2*(j-1)+1:2*j) = y(:,i,t);
            hmuw(2*(j-1)+1:2*j) = [rp;(atan2(dy,dx) - Xp(3,d))];
            Qw(2*(j-1)+1:2*j,2*(j-1)+1:2*j) = Sp(:,:,i,d);
            j=j+1;
        end
        
        %Calculate weight
        %w(d) = w0;
        if (exist('Qw'))
            w(d) = mvnpdf(yw,hmuw,Qw);
        end
    end
    
    % Eliminate initialization of previously measured features
    newfeature(meas_ind) = 0;
        
    % Resampling
    W = cumsum(w);
    % Resample and copy all data to new particle set
    for d=1:D
        seed = W(end)*rand(1);
        cur = find(W>seed,1);
        Xpc = Xp(:,cur);
        mu(:,:,d) = mup(:,:,cur);
        S(:,:,:,d) = Sp(:,:,:,cur);
    end
    
    muParticle = mean(X');
    particle_means = [particle_means;muParticle];

    mu_S(:,t) = muParticle;

    %% Plot results
    figure(1); clf;hold on;
    plot(xr(1,1:t),xr(2,1:t), 'ro--')
    plot([xr(1,t) xr(1,t)+1*cos(xr(3,t))],[xr(2,t) xr(2,t)+1*sin(xr(3,t))], 'r-')
    %plot(mu_S(1,1:t),mu_S(2,1:t), 'bx--')
    %plot([mu_S(1,t) mu_S(1,t)+1*cos(mu_S(3,t))],[mu_S(2,t) mu_S(2,t)+1*sin(mu_S(3,t))], 'b-')
    color = {'r','g','k','m','c','y','b'};
    colord = {'r.','g.','k.','m.','c.','y.','b.'};
    coloro = {'ro','go','ko','mo','co','yo','bo'};
    for i=meas_ind
        plot([xr(1,t) xr(1,t)+y(1,i,t)*cos(y(2,i,t)+xr(3,t))], [xr(2,t) xr(2,t)+y(1,i,t)*sin(y(2,i,t)+xr(3,t))], color{mod(i,7)+1} );
    end
    for j = 1:M
        plot(map(1,j),map(2,j),coloro{mod(j,7)+1}, 'MarkerSize',10,'LineWidth',2);
    end
    for d=1:D
        plot(X(1,d),X(2,d),'b.');
        for j = 1:M
            if (~newfeature(j))
                plot(mu(1,j,d),mu(2,j,d),colord{mod(j,7)+1});
                %error_ellipse(S_pos,mu_pos,0.95);
            end
        end
    end
    axis equal
    title('FastSLAM with Range & Bearing Measurements')
    F(t-1) = getframe(gcf);
end

for i = 1:numel(particle_means(:,1));
    plot(particle_means(i,1), particle_means(i,2), 'o','MarkerSize',15);
end