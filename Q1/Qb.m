robot_x = 2;
robot_y = 3.5;
robot_vx = 0;
robot_vy = 0;

wand_x = 0;
wand_y = 0;
wand_vx = 0;
wand_vy = 0;

update_hz = 100;
sim_length = 10;

t = linspace(0, sim_length, sim_length * update_hz); 
Ix = arrayfun(@(x) sin(2*x), t);
Iy = arrayfun(@(x) -2*cos(2*x), t);
dt = 1/update_hz;

clf;
hold on;

K = 2.4;
Mr = 5;

robot_x_measured = 2;
robot_y_measured = 3.5;

Sigma = [1 0 0 0;
         0 1 0 0;
         0 0 1 0;
         0 0 0 0];

for i = 1:length(t)
    
    mut_1 = [robot_x; 
             robot_vx; 
             robot_y;
             robot_vy];
         
    [robot_x, robot_vx, robot_y, robot_vy] = Robot(robot_x, robot_vx, robot_y, robot_vy, Ix(i), Iy(i));
    [wand_x, wand_vx, wand_y, wand_vy] = Robot(wand_x, wand_vx, wand_y, wand_vy, 0, 0);
    
    robot_x_measured_1 = robot_x_measured;
    robot_y_measured_1 = robot_y_measured;
    
    robot_x_measured = robot_x + normrnd(0, 0.0001);
    robot_y_measured = robot_y + normrnd(0, 0.0001);
    robot_vx_measured = (robot_x_measured - robot_x_measured_1)*dt;
    robot_vy_measured = (robot_y_measured - robot_y_measured_1)*dt;
    
    
    wand_x_measured = wand_x + normrnd(0, 0.0001);
    wand_y_measured = wand_y + normrnd(0, 0.0001);
    
    % Do the Kalman
    
    A = [0 1 0 0;
        0 0 0 0;
        0 0 0 1;
        0 0 0 0];
    B = [0 0;
        K/Mr -0.2*K/Mr;
        0 0;
        -0.2*K/Mr K/Mr];
    C = [0.000002 0 0 0;
         0 0.000004 0 0;
         0 0 0.000002 0;
         0 0 0 0.000004];
    R = [0.0001 0 0 0;
         0 0 0 0;
         0 0 0.0001 0;
         0 0 0 0];
     
    Q = R;
    
    ut = [Ix(i);
          Iy(i)];
      
    y = [robot_x_measured;
         robot_vx_measured;
         robot_y_measured;
         robot_vy_measured];
    
    mu_bar = A*mut_1 + B*ut;
    
    Sigma_bar = A * Sigma * A' + R; % no disturbance, no R
    
    Kt = Sigma_bar*C'/(C*Sigma_bar*C' + Q);
    
    mu = mu_bar + Kt*(y - C*mu_bar);
    
    Sigma = (eye(4) - K*C)*Sigma_bar;
end

xlabel('X (m)')
ylabel('Y (m)')

hold off;