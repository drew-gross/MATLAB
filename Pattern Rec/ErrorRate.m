function [ ER ] = ErrorRate( ConfusionMatrix )
    correctCount = sum(sum(eye(length(ConfusionMatrix)) .* ConfusionMatrix));
    totalCount = sum(sum(ConfusionMatrix));
    ER = 1 - correctCount/totalCount;
end

