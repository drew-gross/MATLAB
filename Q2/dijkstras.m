function [path] = dijkstras(graph,start,finish)

% node, prrevious node, cost to here
open_set = [start 0 0];
closed_set = [];
done = 0;

while ~done
    if numel(open_set) == 0
        path = [0 0 Inf];
        return
    end
    cur_node = open_set(1,:);
    open_set = open_set(2:end,:);
    closed_set = [closed_set; cur_node];
    
    if cur_node(1) == finish
        break;
    end
    
    neighbours = find(graph(cur_node(1),:)==1);
    
    for i = 1:length(neighbours)
        if ~isempty(find(closed_set(:,1)==neighbours(i), 1))
            %don't look at things already in the closed set
            continue;
        end
        open_set_location = find(open_set(:,1)==neighbours(i), 1);
        if isempty(open_set_location)
            %add neighbour to open set if it isn't there
            open_set = [open_set; neighbours(i), cur_node(1), cur_node(3)+1]; 
        else
            %if its in the open set, check if the new route is better
            if cur_node(3)+1 < open_set(open_set_location, 3)
                open_set(open_set_location,1) = neighbours(i);
                open_set(open_set_location,2) = cur_node(2);
                open_set(open_set_location,3) = cur_node(3) + 1;
            end
        end
    end
end

%make da path

path = [cur_node];
while cur_node(2) ~= 0
    next_node_index = find(closed_set(:,1)==cur_node(2));
    cur_node = closed_set(next_node_index,:);
    path = [path; cur_node];
end

end
