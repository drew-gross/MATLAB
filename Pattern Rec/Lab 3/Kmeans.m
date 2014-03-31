load('feat.mat');

K = 10;

samples = f32(1:2,:);
samples = [samples; zeros(1,length(samples))];

%find first prototypes
prototypes = zeros(2,10);
for i=1:K
    index = randi([1,size(f32,2)]);
    prototypes(:,i) = f32(1:2,index);
end

new_prototypes = zeros(2,10);
while ~isequaln(prototypes, new_prototypes)
    if new_prototypes(1) ~= 0
        prototypes = new_prototypes;
    end
    %classify
    for i=1:length(samples)
        min_dist = +Inf;
        for j=1:K
            cur_dist = norm(samples(1:2,i) - prototypes(:,j));
            if cur_dist < min_dist
                min_dist = cur_dist;
                samples(i,3) = j;
            end
        end
    end
    %find new prototypes
    for i=1:K
        count = 0;
        new_prototype = 0;
        for j=1:length(samples)
            if samples(j,3) == i
                count = count + 1;
                new_prototype = new_prototype + samples(1:2,j);
            end
        end
        new_prototype = new_prototype./count;
        new_prototypes(:,i) = new_prototype;
    end
end
clf;hold on
aplot(f32)
scatter(prototypes(1,:),prototypes(2,:),'r.')
title('Result of K-means for f32');
