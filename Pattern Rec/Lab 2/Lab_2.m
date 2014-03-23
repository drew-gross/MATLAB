fig = 0;

load('lab2_1.mat')
% from notes
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

y_ml = exp(-((x-mean_b).^2)./variance_b)./(sqrt(variance_b*2*pi));
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

y_true_a = exp(-((x-5).^2)./1)./(sqrt(1*2*pi));
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