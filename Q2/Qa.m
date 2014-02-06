%% maps.m for Question 2 - Amazon Prime Air 25 m and 50 m maps
clear; clc;
% Area
X = 10; % 10 km
Y = 5;  % 5 km

% Depot locations
depots = [ 0.5 0.5; 9.5 0.5];

% Delivery locations
drops = [ 2 4; 2.5 3; 3.5 4.5; 3.5 1.5; 5 2; 5.5 4; 6 5; 6.5 1; 7.0 3; 8 4.5];


% Airway Intersections
spacing = 0.5; % 0.1 km spacing
[xgrid,ygrid] = meshgrid(0:spacing:X,0:spacing:Y);
[n,m] = size(xgrid);
nodes = [reshape(xgrid,n*m,1) reshape(ygrid,n*m,1)];

% Building nodes map
buildings25 = [.5 2; .5 3; 1 3; 1 2; NaN NaN;
             .5 4; .5 5; 1 5; 1 4; NaN NaN;
             2.5 .5; 2.5 2.5; 3 2.5; 3 .5; NaN NaN;
             2.5 4; 2.5 5; 3 5; 3 4; NaN NaN;
             4.5 .5; 4.5 1; 5.5 1; 5.5 .5; NaN NaN;
             4 2; 4 4; 4.5 4; 4.5 2; NaN NaN;
             6 2; 6 2.5; 6.5 2.5; 6.5 2; NaN NaN;
             6 3.5; 6 4; 7 4; 7 3.5; NaN NaN;
             7.5 1; 7.5 1.5; 9 1.5; 9 1; NaN NaN;
             8 3; 8 4; 9.5 4; 9.5 3; NaN NaN];

buildings50 = [.5 2; .5 3; 1 3; 1 2; NaN NaN;
             %.5 4; .5 5; 1 5; 1 4; NaN NaN;
             2.5 .5; 2.5 2.5; 3 2.5; 3 .5; NaN NaN;
             %2.5 4; 2.5 5; 3 5; 3 4; NaN NaN;
             4.5 .5; 4.5 1; 5.5 1; 5.5 .5; NaN NaN;
             %4 2; 4 4; 4.5 4; 4.5 2; NaN NaN;
             6 2; 6 2.5; 6.5 2.5; 6.5 2; NaN NaN;
             %6 3.5; 6 4; 7 4; 7 3.5; NaN NaN;
             7.5 1; 7.5 1.5; 9 1.5; 9 1; NaN NaN;
             8 3; 8 4; 9.5 4; 9.5 3; NaN NaN
             ];
         
% Nearest neighbors connections of non-building nodes
% Note: If rangesearch fails (its in the statistics toolbox), just load
% maps.mat and continue from there
in = inpolygon(nodes(:,1), nodes(:,2), buildings25(:,1), buildings25(:,2));
IDXout25 = find(1-in); % Index to original nodes 
IDX25 = rangesearch(nodes(IDXout25,:),nodes(IDXout25,:),0.5); % Available node connections

in = inpolygon(nodes(:,1), nodes(:,2), buildings50(:,1), buildings50(:,2));
IDXout50 = find(1-in); % Index to original nodes 
IDX50 = rangesearch(nodes(IDXout50,:),nodes(IDXout50,:),0.5); % Available node connections
            
% Adjacency matrix
A25 = zeros(n*m*2);
for i=1:length(IDX25)
    A25(IDXout25(i),IDXout25(IDX25{i})) = 1;
end

% top layer
for i=1:length(IDX50)
    A25(n*m+IDXout50(i),n*m+IDXout50(IDX50{i})) = 1;
end


% connect vertical edges

for i = 1:n*m
    edges = A25(i,:);
    if sum(edges) > 0
        A25(i, i + n*m) = 1;
        A25(i + n*m, i) = 1;
    end
end

% add depots
for i = 1:numel(depots(:,1))
    A25 = [A25; zeros(1, numel(A25(1,:)))];
    A25 = [A25 zeros(numel(A25(:,1)), 1)];
    depot_index = numel(A25(1,:));
    node_index = depots(i,1)*22 + depots(i,2)*4;
    A25(depot_index, node_index) = 1;
    A25(node_index, depot_index) = 1;
end

% add drops

for i = 1:numel(drops(:,1))
    A25 = [A25; zeros(1, numel(A25(1,:)))];
    A25 = [A25 zeros(numel(A25(:,1)), 1)];
    drop_index = numel(A25(1,:));
    node_index = drops(i,1)*22 + drops(i, 2)*4;
    A25(drop_index, node_index) = 1;
    A25(node_index, drop_index) = 1;
end



figure(1); clf; hold on; spy(A25);


figure(2); clf; hold on;
plot([0 X X 0 0], [0 0 Y Y 0], 'b'); % boundary
plot(depots(:,1),depots(:,2), 'ro', 'MarkerSize',6,'LineWidth',2)
plot(drops(:,1),drops(:,2), 'go', 'MarkerSize',6,'LineWidth',2)
plot(nodes(:,1),nodes(:,2), 'm.', 'MarkerSize',2)

for i=1:length(IDX25)
    cur = IDXout25(i);
    for j = 1:length(IDX25{i})
        next = IDXout25(IDX25{i}(j)); 
        plot([nodes(cur,1) nodes(next,1)], [nodes(cur,2) nodes(next,2)], 'm--')
    end
end
axis equal
title('Graph for 25m flight level')

figure(3); clf; hold on;
plot([0 X X 0 0], [0 0 Y Y 0], 'b'); % boundary
plot(depots(:,1),depots(:,2), 'ro', 'MarkerSize',6,'LineWidth',2)
plot(drops(:,1),drops(:,2), 'go', 'MarkerSize',6,'LineWidth',2)
plot(nodes(:,1),nodes(:,2), 'm.', 'MarkerSize',2)

for i=1:length(IDX50)
    cur = IDXout50(i);
    for j = 1:length(IDX50{i})
        next = IDXout50(IDX50{i}(j)); 
        plot([nodes(cur,1) nodes(next,1)], [nodes(cur,2) nodes(next,2)], 'm--')
    end
end
axis equal
title('Graph for 50m flight level')
