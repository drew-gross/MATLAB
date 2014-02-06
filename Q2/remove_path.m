function [ adj ] = remove_path( adj, path )
%REMOVE_PATH Summary of this function goes here
%   Detailed explanation goes here
    for j = 1:(numel(path(:,1))-1) 
        adj(path(j,1), path(j,2)) = 0;
        adj(path(j,2), path(j,1)) = 0;
    end

end

