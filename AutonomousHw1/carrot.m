function [ carrot ] = carrot( traj, robot, r )
%CARROT Summary of this function goes here
%   Detailed explanation goes here

closest_point = [100;100];

for i = 1:length(traj) - 1
    a = robot - traj(:,i);
    b = traj(:,i+1) - traj(:,i);
    b_hat = b./norm(b);

    new_closest_point = dot(a, b_hat)*b_hat + traj(:,i);
    
    if norm(robot - closest_point) > norm(robot - new_closest_point)
        closest_point = new_closest_point;

        remaining_dist_on_closest = norm(traj(:,i+1) - closest_point);
        
        if (remaining_dist_on_closest > r)
            carrot = closest_point + r * unit(traj(:,i+1) - traj(:,i));
        else
            dist_on_next = r - remaining_dist_on_closest;
            if (i + 1) < length(traj)
                carrot = traj(:,i+1) + dist_on_next * unit(traj(:,i+2) - traj(:,i+1));
            else
                carrot = traj(:,end);
            end
        end
    end
end
end

