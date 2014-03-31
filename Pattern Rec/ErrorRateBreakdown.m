function [ errorVec ] = ErrorRateBreakdown( confMatrix )

    for i=1:length(confMatrix)
        correct = confMatrix(i,i);
        incorrect = sum(confMatrix(i,:)) - correct;
        errorVec(i) = incorrect/(correct + incorrect);
    end
end

