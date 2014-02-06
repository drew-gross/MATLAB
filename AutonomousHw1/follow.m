function [ new_robot_pos, new_robot_theta ] = follow( traj, robot_pos, robot_theta)

t = 0;
dt = 0.05;
carrot_dist = 2;
v = 3;
kp = 50;

carrot_point = carrot(traj, robot_pos, carrot_dist);
heading_vec = carrot_point - robot_pos;
[heading_angle] = cart2pol(heading_vec(1), heading_vec(2));
theta_error = heading_angle - robot_theta;

while theta_error > pi
    theta_error = theta_error - pi*2;
end
while theta_error < -pi
    theta_error = theta_error + pi*2;
end

delta = kp * theta_error;

[t, new_robot_pos, new_robot_theta] = robot(t, robot_pos, robot_theta, dt, v, delta);

end

