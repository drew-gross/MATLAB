function [ mu, sig ] = DevelopClassifier( dataArray )
    %DevelopClassifier takes in an array of data where each datapoint is
    %represented by the columns of dataArray. The columns of dataArray
    %should be formatted as follows: [featVecA; featVecB; image; block].
    %It returns two cell arrays, mu, and sig, corresponding to the mu and
    %sigma for each image.
    
    helpArray = dataArray';
    
    for n=1:max(dataArray(3,:))
        intermediate = helpArray(find(helpArray(:,3)==n),:);
        M{n} = intermediate';
    end
    
    for i=1:length(M)
        %We want to figure out the mean and covarience of M:
        currentData = M{i}(1:2,:);
        
        sig{i} = cov(currentData(1,:),currentData(2,:));
        mu{i} = mean(currentData');
    end
end

