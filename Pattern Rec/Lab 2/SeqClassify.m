function [ result ] = SeqClassify( Garray, point )
    %This function takes in a sequential classifcation
    %cell array, and a point.
    
    %It will return true if the point should be classified as class1,
    %and false if the point should be classified as class2.
    
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
    end
    
    result = 2;
end

