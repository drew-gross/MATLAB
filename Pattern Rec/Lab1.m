NUM_POINTS = 500;

% part 1
muA = [5 10];
nA = 200;
sigmaA = [8 0;0 4];
A = repmat(muA, nA, 1) + randn(nA, 2)*sigmaA;

muB = [10 15];
nB = 200;
sigmaB = [8 0;0 4];
B = repmat(muB, nB, 1) + randn(nB, 2)*sigmaB;
% part 2
muC = [5 10];
nC = 100;
sigmaC = [8 4;4 40];
C = repmat(muC, nC, 1) + randn(nC, 2)*sigmaC;

muD = [15 10];
nD = 200;
sigmaD = [8 0;0 8];
D = repmat(muD, nD, 1) + randn(nD, 2)*sigmaD;

muE = [10 5];
nE = 150;
sigmaE = [10 -5; -5 20];
E = repmat(muE, nE, 1) + randn(nE, 2)*sigmaE;

fig = 0;
% newfig;
% scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
% plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
% xlabel('X');
% ylabel('Y');
% title('Class A and B');
% 
% newfig;
% scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
% plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);
% xlabel('X');
% ylabel('Y');
% title('Class C, D, and E');
% 
% newfig;
% scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
% x = linspace(-20,30,NUM_POINTS);
% y = linspace(-5,30,NUM_POINTS);
% [X,Y] = meshgrid(x,y);
% Z = zeros(length(x));
% for i=1:length(x)
%     for j=1:length(y)
%         A_dist = sqrt((X(i,j)-muA(1))^2 + (Y(i,j)-muA(2))^2);
%         B_dist = sqrt((X(i,j)-muB(1))^2 + (Y(i,j)-muB(2))^2);
%         if A_dist < B_dist
%             Z(i,j)=0;
%         else
%             Z(i,j)=1;
%         end
%     end
% end
% contour(X,Y,Z,1,'r');
% 
% newfig;
% scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
% plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);
% x = linspace(-25,45, NUM_POINTS);
% y = linspace(-80,80, NUM_POINTS);
% [X,Y] = meshgrid(x,y);
% Z = zeros(length(x));
% for i=1:length(x)
%     for j=1:length(y)
%         C_dist = sqrt((X(i,j) - muC(1))^2 + (Y(i,j)-muC(2))^2);
%         D_dist = sqrt((X(i,j) - muD(1))^2 + (Y(i,j)-muD(2))^2);
%         E_dist = sqrt((X(i,j) - muE(1))^2 + (Y(i,j)-muE(2))^2);
%         if C_dist < D_dist && C_dist < E_dist
%             Z(i,j) = 0;
%         elseif D_dist < E_dist
%             Z(i,j) = 1;
%         else
%             Z(i,j) = 2;
%         end
%     end
% end
% contour(X,Y,Z,2,'r');

newfig;

[eig_vec_A, eig_val_A] = eig(sigmaA);
[eig_vec_B, eig_val_B] = eig(sigmaA);

muA_ged = sqrtm(eig_val_A) \ eig_vec_A * muA';
muB_ged = sqrtm(eig_val_B) \ eig_vec_B * muB';

scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        A_dist = sqrt((X(i,j)-muA_ged(1))^2 + (Y(i,j)-muA_ged(2))^2);
        B_dist = sqrt((X(i,j)-muB_ged(1))^2 + (Y(i,j)-muB_ged(2))^2);
        if A_dist < B_dist
            Z(i,j)=0;
        else
            Z(i,j)=1;
        end
    end
end
contour(X,Y,Z,1,'r');