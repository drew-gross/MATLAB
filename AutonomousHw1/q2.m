clf
hold on
axis equal
robot_pos = [0;0];
theta = 0;
traj=[[0;0] [5;0] [5;20] [0;20] [0;0]];

i = 0;
rate = 5;
while true
    
    [robot_pos, theta] = follow(traj, robot_pos, theta);
    
    plot(robot_pos(1), robot_pos(2), 'b', 'MarkerSize', 4, 'LineWidth', 4);
    
    drawnow
end