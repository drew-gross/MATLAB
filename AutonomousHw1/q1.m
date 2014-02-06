hold on
axis equal
t=zeros(10,1);
x=zeros(10,1);
y=zeros(10,1);
theta=zeros(10,1);
dt=0.05;

while t <= 20
    for i=1:length(x)
        [t(i), x(i), y(i), theta(i)] = robot(t(i),x(i),y(i),theta(i), dt);
        plot(x(i),y(i));
    end
end