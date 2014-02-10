function [ nearest ] = knearest( samples, input, k )
%KNEAREST Summary of this function goes here
%   Detailed explanation goes here

nearest = inf(k,2);
for i=1:k
    for j=1:length(samples)
        cur_sample = samples(j,:);
        prev_nearest = nearest(i,:);
        seen = 0;
        for n=1:k
            if isequal(nearest(n,:),cur_sample)
                seen = 1;
            end
        end
        if seen == 0
            cur_dist = norm(cur_sample - input);
            prev_dist = norm(prev_nearest - input);
            if cur_dist < prev_dist
                nearest(i,:) = cur_sample;
            end
        end
    end
end

end

