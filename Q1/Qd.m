robot_x = 3;
robot_y = 3.5;
robot_vx = 0;
robot_vy = 0;


update_hz = 100;
sim_length = 12;

t = linspace(0, sim_length, sim_length * update_hz);
dt = 1/update_hz;

wand_x = arrayfun(@(n) 3+WandX(n), t);
wand_y = arrayfun(@(n) 1+WandY(n), t);


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
         
    
    robot_x_measured_1 = robot_x_measured;
    robot_y_measured_1 = robot_y_measured;
    
    robot_x_measured = robot_x + normrnd(0, 0.0001);
    robot_y_measured = robot_y + normrnd(0, 0.0001);
    robot_vx_measured = (robot_x_measured - robot_x_measured_1)*dt;
    robot_vy_measured = (robot_y_measured - robot_y_measured_1)*dt;
    
    robot_x_desired = (wand_x(i) - 2) * 3;
    robot_y_desired = ((wand_y(i) - 0.5) * 3) + 2;
    
    A = [0 1 0 0;
        0 0 0 0;
        0 0 0 1;
        0 0 0 0];
    b1 = K/Mr;
    b2 = -0.2*K/Mr;
    B = [0, 0;
        b1, b2;
        0, 0;
        b2, b1];
    Q = eye(4)*0.01;
    R = eye(2)*0.01;
    
    [Ks, a, b] = lqr(A,B,Q,R);
    
    x = [robot_x_desired - robot_x_measured;
         robot_vx_measured;
         robot_y_desired - robot_y_measured;
         robot_vy_measured];
    
    
    u = -Ks*0.00001*x;
    
    Ix = x(1)*0.001;
    Iy = x(3)*0.001;
    
    [robot_x, robot_vx, robot_y, robot_vy] = Robot(robot_x, robot_vx, robot_y, robot_vy, u(1), u(2));
    
    plot(wand_x(i), wand_y(i), 'r+');
    plot(robot_x_desired, robot_y_desired, 'g+');
    plot(robot_x_measured, robot_y_measured, 'bo'); 
    
end

xlabel('X (m)')
ylabel('Y (m)')

hold off;