function [ result ] = graph_points( map, count )

[map_width, map_height] = size(map);

xs = rand(1, count)*map_width;
ys = rand(1, count)*map_height;

result = ceil([xs;ys]');

end

