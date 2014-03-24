NUM_POINTS = 500;
fig = 0;

load('lab2_1.mat')
%from notes
mean_a = sum(a)/numel(a)
variance_a = sum((a - mean_a).^2)/numel(a)

newfig;
x = 0:0.01:10;
y_ml = exp(-((x-mean_a).^2)./variance_a)./(sqrt(variance_a*2*pi));
plot(x,y_ml,'b')

y_true_a = exp(-((x-5).^2)./1)./(sqrt(1*2*pi));
plot(x,y_true_a,'g')

legend('p_m_l', 'p_t_r_u_e')
title('Gaussian ML for a')

newfig;
x = 0:0.01:5;
mean_b = sum(b)/numel(b)
variance_b = sum((b - mean_b).^2)/numel(b)

y_ml = exp(-((x-mean_b).^2)./(2*variance_b))./(sqrt(variance_b*2*pi));
plot(x,y_ml,'b')

y_true_b = exp(-x);
plot(x,y_true_b,'g')

legend('p_m_l', 'p_t_r_u_e')
title('Gaussian ML for b')

newfig;

x = 0:0.01:10;
lambda_a = numel(a)/sum(a)

y_ml = lambda_a * exp(-lambda_a * x);
plot(x,y_ml, 'b')

y_true_a = exp(-((x-5).^2)./2)./(sqrt(1*2*pi));
plot(x,y_true_a,'g')

legend('p_m_l', 'p_t_r_u_e')
title('Exponential ML for a')

newfig;

lambda_b = numel(b)/sum(b)

y_ml = lambda_b * exp(-lambda_b * x);
plot(x,y_ml, 'b')

y_true_b = exp(-x);
plot(x,y_true_b,'g')

legend('p_m_l', 'p_t_r_u_e')
title('Exponential ML for b')

newfig

a_a = min(a)
b_a = max(a)

x = 0:0.01:10;
y = zeros(size(x));
for i=1:length(x)
    if x(i) > a_a && x(i) < b_a
        y(i) = 1/(b_a - a_a);
    end
end

plot(x,y,'b')
plot(x,y_true_a,'g')

legend('p_m_l', 'p_t_r_u_e')
title('Uniform ML for a')

newfig

a_b = min(b)
b_b = max(b)

x = 0:0.01:10;
y = zeros(size(x));
for i=1:length(x)
    if x(i) > a_b && x(i) < b_b
        y(i) = 1/(b_b - a_b);
    end
end

plot(x,y,'b')
plot(x,y_true_b,'g')

legend('p_m_l', 'p_t_r_u_e')
title('Uniform ML for b')

% part 4: parzen window estimation

% using Gaussian distribution with st.dev = 0.1

newfig;

x = 0:0.01:10;
y = zeros(size(x));

for i = 1:length(x)
    x_cur = x(i);
    p_x_cur = sum(exp((x_cur - a).^2./(-2*0.1^2))./(0.1*sqrt(2*pi)))/length(a)
    y(i) = p_x_cur;
end

plot(x,y,'b');
plot(x,y_true_a,'g');

legend('p-parzen', 'p-true')
title('Parzen Window Estimation for a (st.ddev = 0.1)')
% using Gaussian distribution with st.dev = 0.4

newfig;

x = 0:0.01:10;
y = zeros(size(x));

for i = 1:length(x)
    x_cur = x(i);
    p_x_cur = sum(exp((x_cur - a).^2./(-2*0.4^2))./(0.4*sqrt(2*pi)))/length(a)
    y(i) = p_x_cur;
end

plot(x,y,'b');
plot(x,y_true_a,'g');

legend('p-parzen', 'p-true')
title('Parzen Window Estimation for a (st.ddev = 0.4)')


% using Gaussian distribution with st.dev = 0.1

newfig;

x = 0:0.01:10;
y = zeros(size(x));

for i = 1:length(x)
    x_cur = x(i);
    p_x_cur = sum(exp((x_cur - b).^2./(-2*0.1^2))./(0.1*sqrt(2*pi)))/length(b)
    y(i) = p_x_cur;
end

plot(x,y,'b');
plot(x,y_true_b,'g');

legend('p-parzen', 'p-true')
title('Parzen Window Estimation for b (st.ddev = 0.1)')

% using Gaussian distribution with st.dev = 0.4

newfig;

x = 0:0.01:10;
y = zeros(size(x));

for i = 1:length(x)
    x_cur = x(i);
    p_x_cur = sum(exp((x_cur - b).^2./(-2*0.4^2))./(0.4*sqrt(2*pi)))/length(b)
    y(i) = p_x_cur;
end

plot(x,y,'b');
plot(x,y_true_b,'g');

legend('p-parzen', 'p-true')
title('Parzen Window Estimation for b (st.ddev = 0.4)')

% %Part four of the lab
% load('lab2_3.mat');
% j = 1;
% Garray = {};
% 
% newfig;
% xlabel('X');
% ylabel('Y');
% 
% scatter(a(:,1),a(:,2),'x');scatter(b(:,1),b(:,2), '+');
% 
% %While there are still points that need classification:
% while(~isempty([a;b]))
%     lena = size(a,1);
%     lenb = size(b,1);
%     
%     %Get two test points
%     testa = a(randi(lena),:);
%     testb = b(randi(lenb),:);
%     
%     %Using MED to create a discriminant:
%     
%     slope = -(testb(1)-testa(1))/(testb(2)-testa(2));
%     if (testb(2) == testa(2))
%         continue
%     end
%     midpoint = (testa + testb)/2;
%     intercept = midpoint(2) - midpoint(1) * slope;
%     
%     %If G is >0, then x,y belongs to whichever point is higher, so we'll
%     %negate it in the case that the higher point is the B sample. That way
%     % G(point)>0 => A
%     if (testa(2) < testb(2))
%         G = @(x, y) slope*x + intercept - y;
%     else
%         G = @(x, y) -(slope*x + intercept - y);
%     end
%         
%     
%     naB = 0;
%     for i=1:size(a,1)
%         point = a(i,:);
%         if (G(point(1),point(2)) < 0)
%             naB = naB + 1;
%         end
%     end
%     
%     nbA = 0;
%     for i=1:size(b,1)
%         point = b(i,:);
%         if (G(point(1),point(2)) > 0)
%             nbA = nbA + 1;
%         end
%     end
%     
%     %In this condition, we have a good discriminant:
%     if (naB == 0 || nbA == 0)
%         
%         x = linspace(0,500,NUM_POINTS);
%         y = x * slope + intercept;
%         
%         %Save the discriminant
%         Garray(length(Garray) + 1) = {{G, naB, nbA}};
%         j = j + 1;
%         
%         %In this case, we need to remove all of the points in B
%         % that G successfully classifies:
%         %Another way of putting that, is that we need to *keep*
%         %all of the points in B that G *misclassifies*
%         if (naB == 0)
%             bnew = [];
%             for i=1:size(b,1)
%                 point = b(i,:);
%                 if (point == [0, 0])
%                     point = [0,0];
%                 end
%                 if (G(point(1),point(2)) >= 0)
%                     bnew(size(bnew,1)+1,:) = point;
%                 end
%             end
%             b = bnew;
%         end
%          
%         if (nbA == 0)
%             anew = [];
%             for i=1:size(a,1)
%                 point = a(i,:);
%                 if (G(point(1),point(2)) <= 0)
%                     anew(size(anew,1)+1,:) = point;
%                 end
%             end
%             a = anew;
%         end
%     end
% end
% 
% %Now it's time to draw a contour map:
% 
% load('lab2_3.mat');
% x = linspace(0,500,NUM_POINTS);
% y = linspace(0,500,NUM_POINTS);
% [X,Y] = meshgrid(x,y);
% Z = zeros(size(x,2));
% for i=1:size(x,2)
%     for j=1:size(y,2)
%         P = [X(i,j);Y(i,j)];
%         
%         Z(i,j) = SeqClassify(Garray, P);
%     end
% end
% 
% contour(X,Y,Z,1,'r');


