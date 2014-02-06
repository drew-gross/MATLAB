I = imread('IGVCmap.jpg');
map = flipud(im2bw(I, 0.7)); % Convert to 0-1 image

% Robot start position
dxy = 0.1;
robot_pos = [400;50];
robot_theta = pi;

% Target location
target_pos = [500;100];

% Plotting
figure(1); 
clf; 
hold on;
colormap('gray');
imagesc(map);
plot(robot_pos(1), robot_pos(2), 'ro', 'MarkerSize',10, 'LineWidth', 3);
plot(target_pos(1), target_pos(2), 'gx', 'MarkerSize',10, 'LineWidth', 3 );
axis equal

traj=[robot_pos, [0;0] [50;0] [50;200] [0;200] [0;0]];

nodes = graph_points(map, 2000);
nodes = filter_points(map, nodes);
nodes = [nodes(:,2), nodes(:,1)];

for i=1:size(nodes(:,1))
    plot(nodes(i,1), nodes(i,2), 'y', 'MarkerSize', 10, 'LineWidth', 3);
end

drawrate = 30;
draw = drawrate;
while true
    
    [robot_pos, robot_theta] = follow(traj, robot_pos, robot_theta);
    
    plot(robot_pos(1), robot_pos(2), 'b', 'MarkerSize', 10, 'LineWidth', 3);
    
    draw = draw - 1;
    if draw == 0 
        draw = drawrate;
        drawnow
    end
end