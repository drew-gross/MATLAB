function [ Garray ] = CreateSeqClassifier( a, b, numberOfClassifiers )

    Garray = {};
    
    %While there are still points that need classification:
    while(~isempty([a;b]) && length(Garray) ~= numberOfClassifiers)
        lena = size(a,1);
        lenb = size(b,1);

        %Get two test points
        testa = a(randi(lena),:);
        testb = b(randi(lenb),:);

        %Using MED to create a discriminant:

        slope = -(testb(1)-testa(1))/(testb(2)-testa(2));
        if (testb(2) == testa(2))
            continue
        end
        midpoint = (testa + testb)/2;
        intercept = midpoint(2) - midpoint(1) * slope;

        %If G is >0, then x,y belongs to whichever point is higher, so we'll
        %negate it in the case that the higher point is the B sample. That way
        % G(point)>0 => A
        if (testa(2) < testb(2))
            G = @(x, y) slope*x + intercept - y;
        else
            G = @(x, y) -(slope*x + intercept - y);
        end

        naB = 0;
        for i=1:size(a,1)
            point = a(i,:);
            if (G(point(1),point(2)) < 0)
                naB = naB + 1;
            end
        end

        nbA = 0;
        for i=1:size(b,1)
            point = b(i,:);
            if (G(point(1),point(2)) > 0)
                nbA = nbA + 1;
            end
        end

        %In this condition, we have a good discriminant:
        if (naB == 0 || nbA == 0)

            %Save the discriminant
            Garray(length(Garray) + 1) = {{G, naB, nbA}};

            %In this case, we need to remove all of the points in B
            % that G successfully classifies:
            %Another way of putting that, is that we need to *keep*
            %all of the points in B that G *misclassifies*
            if (naB == 0)
                bnew = [];
                for i=1:size(b,1)
                    point = b(i,:);
                    if (G(point(1),point(2)) >= 0)
                        bnew(size(bnew,1)+1,:) = point;
                    end
                end
                b = bnew;
            end

            if (nbA == 0)
                anew = [];
                for i=1:size(a,1)
                    point = a(i,:);
                    if (G(point(1),point(2)) <= 0)
                        anew(size(anew,1)+1,:) = point;
                    end
                end
                a = anew;
            end
        end
    end
end

