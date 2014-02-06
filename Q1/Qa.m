x = 2;
y = 3.5;
v_x = 0;
v_y = 0;

update_hz = 100;
sim_length = 10;

t = linspace(0, sim_length, sim_length * update_hz); 
Ix = arrayfun(@(x) sin(2*x), t);
Iy = arrayfun(@(x) -2*cos(2*x), t);

clf;
hold on;

for i = 1:length(t)
    [x, v_x, y, v_y] = Robot(x, v_x, y, v_y, Ix(i), Iy(i));
    plot(x,y);
end

xlabel('X (m)')
ylabel('Y (m)')

hold off;