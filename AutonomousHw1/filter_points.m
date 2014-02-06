function [ filtered_points ] = filter_points( map, points )
    filtered_points_count = 1;

    for i=1:length(points)
        point = points(i,:);
        x = point(1);
        y = point(2);
        if map(x, y) == 1
            filtered_points(filtered_points_count, 1) = x;
            filtered_points(filtered_points_count, 2) = y;
            filtered_points_count = filtered_points_count + 1;
        end
    end
end

