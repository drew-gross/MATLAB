function [ result ] = SeqClassify( Garray, point )
    %This function takes in a sequential classifcation
    %cell array, and a point.
    
    %It will return true if the point should be classified as class1,
    %and false if the point should be classified as class2.
    
    %In the case that the number of classifiers was insufficient, we will
    %take the first classifier in the Garray to be canon.
    
    for gIndex=1:length(Garray)
        currentElement = Garray{gIndex};
        if (currentElement{2} == 0)
            if(currentElement{1}(point(1),point(2)) <= 0)
                result = 0;
                return
            end
        end
        
        if (currentElement{3} == 0)
            if(currentElement{1}(point(1),point(2)) >= 0)
                result = 1;
                return
            end
        end
        
        %If we're out of options, and can't come to a decision,
        %assume that the first classifier is correct
        if (gIndex == length(Garray))
            firstElement = Garray{1};
            if(firstElement{1}(point(1),point(2)) >= 0)
                result = 1;
            else
                result = 0;
            end
            return
        end
    end
end

