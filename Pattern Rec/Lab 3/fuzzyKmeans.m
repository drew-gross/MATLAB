load('feat.mat');

J = 10;
b=2;

samples = f32(1:2,:);
samples = [samples; zeros(1,length(samples))];

%find first prototypes
prototypes = zeros(2,10);
for i=1:J
    index = randi([1,size(f32,2)]);
    prototypes(:,i) = f32(1:2,index);
end

new_prototypes = zeros(2,10);

u = zeros(length(samples),K);
while ~isequaln(prototypes, new_prototypes)
    if new_prototypes(1) ~= 0
        prototypes = new_prototypes;
    end
    % calculate U matrix
    for jj = 1:K
        for ii = 1:length(samples)
            for kk = 1:K
                if jj~=kk
                    u(ii,jj) = u(ii,jj) + norm(samples(1:2,ii)-prototypes(:,jj))/norm(samples(1:2,ii)-prototypes(:,kk));
                else
                    u(ii,jj) = u(ii,jj) + 1;
                end
            end
            u(ii,jj) = u(ii,jj)^(-2/(b-1));
        end
    end
    % find new prototypes
    for jj = 1:K
        temp = [(u(:,jj).^b)';(u(:,jj).^b)'];
        
        new_prototypes(:,jj)=sum(temp.*samples(1:2,:), 2)/sum(u(:,jj));
    end
end
clf;hold on
aplot(f32)
scatter(prototypes(1,:),prototypes(2,:),'r.')
title('Result of K-means for f32');
