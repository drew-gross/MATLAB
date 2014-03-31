function [ class ] = MICDClassify( vec, mu, sig )
    %MICDCLASSIFY takes a feature vector (column vector), and
    % a matrix representing the mean and covarience of each MICD class (as
    % cells of mu and cells of sig), and returns the number of the class that 
    % the vector coresponds to.

    minDist = 0;
    class = 0;

    for i=1:length(sig)
        [eig_vec, eig_val] = eig(sig{i});
        W = (eig_val^(-1/2))*(eig_vec');
        mu_ged = W * mu{i}';
        vecWhite = W * vec;
        dist = sqrt((vecWhite(1)-mu_ged(1))^2 + (vecWhite(2)-mu_ged(2))^2);

        if (i == 1)
            minDist = dist;
            class = 1;
        else
            if (dist < minDist)
                minDist = dist;
                class = i;
            end
        end
    end
end

