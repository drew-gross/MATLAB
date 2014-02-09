NUM_POINTS = 200;

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
newfig;
scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
xlabel('X');
ylabel('Y');
title('Class A and B');

newfig;
scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);
xlabel('X');
ylabel('Y');
title('Class C, D, and E');


%Classifiers Section (i.e. section 3)

% MED for A and B
newfig;
scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        A_dist = sqrt((X(i,j)-muA(1))^2 + (Y(i,j)-muA(2))^2);
        B_dist = sqrt((X(i,j)-muB(1))^2 + (Y(i,j)-muB(2))^2);
        if A_dist < B_dist
            Z(i,j)=0;
        else
            Z(i,j)=1;
        end
    end
end
contour(X,Y,Z,1,'r');


% MED for C, D, and E
newfig;
scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);
x = linspace(-25,45, NUM_POINTS);
y = linspace(-80,80, NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        C_dist = sqrt((X(i,j) - muC(1))^2 + (Y(i,j)-muC(2))^2);
        D_dist = sqrt((X(i,j) - muD(1))^2 + (Y(i,j)-muD(2))^2);
        E_dist = sqrt((X(i,j) - muE(1))^2 + (Y(i,j)-muE(2))^2);
        if C_dist < D_dist && C_dist < E_dist
            Z(i,j) = 0;
        elseif D_dist < E_dist
            Z(i,j) = 1;
        else
            Z(i,j) = 2;
        end
    end
end
contour(X,Y,Z,2,'r');

%GED for A and B
newfig;

[eig_vec_A, eig_val_A] = eig(sigmaA);
[eig_vec_B, eig_val_B] = eig(sigmaB);

WA = (eig_val_A^(-1/2))*(eig_vec_A');
WB = (eig_val_B^(-1/2))*(eig_vec_B');

muA_ged = WA * muA';
muB_ged = WB * muB';

scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j);Y(i,j)];
        PAwhite = WA * P;
        PBwhite = WB * P;
        
        A_dist = sqrt((PAwhite(1)-muA_ged(1))^2 + (PAwhite(2)-muA_ged(2))^2);
        B_dist = sqrt((PBwhite(1)-muB_ged(1))^2 + (PBwhite(2)-muB_ged(2))^2);
        
        if A_dist < B_dist
            Z(i,j)=0;
        else
            Z(i,j)=1;
        end
    end
end
contour(X,Y,Z,1,'r');


%GED for C, D, and E
newfig;

[eig_vec_C, eig_val_C] = eig(sigmaC);
[eig_vec_D, eig_val_D] = eig(sigmaD);
[eig_vec_E, eig_val_E] = eig(sigmaE);

WC = (eig_val_C^(-1/2))*(eig_vec_C');
WD = (eig_val_D^(-1/2))*(eig_vec_D');
WE = (eig_val_E^(-1/2))*(eig_vec_E');

muC_ged = WC * muC';
muD_ged = WD * muD';
muE_ged = WE * muE';

scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);

x = linspace(-25,45, NUM_POINTS);
y = linspace(-80,80, NUM_POINTS);

[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j);Y(i,j)];
        PCwhite = WC * P;
        PDwhite = WD * P;
        PEwhite = WE * P;
        
        C_dist = sqrt((PCwhite(1)-muC_ged(1))^2 + (PCwhite(2)-muC_ged(2))^2);
        D_dist = sqrt((PDwhite(1)-muD_ged(1))^2 + (PDwhite(2)-muD_ged(2))^2);
        E_dist = sqrt((PEwhite(1)-muE_ged(1))^2 + (PEwhite(2)-muE_ged(2))^2);
        
        if C_dist < D_dist && C_dist < E_dist
            Z(i,j) = 0;
        elseif D_dist < E_dist
            Z(i,j) = 1;
        else
            Z(i,j) = 2;
        end
    end
end
contour(X,Y,Z,2,'r');

%MAP for A and B

newfig;
title('MAP A and B');

scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j);Y(i,j)];
        ProbAgivenP = mvnpdf(P,muA', sigmaA);
        ProbA = nA;
        WeightedProbA = ProbA * ProbAgivenP;
        
        ProbBgivenP = mvnpdf(P,muB', sigmaB);
        ProbB = nB;
        WeightedProbB = ProbB * ProbBgivenP;
        
        if WeightedProbA < WeightedProbB
            Z(i,j)=0;
        else
            Z(i,j)=1;
        end
    end
end
contour(X,Y,Z,1,'r');


%MAP for C, D, and E
newfig;
title('MAP C, D, and E');

scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);

x = linspace(-25,45, NUM_POINTS);
y = linspace(-80,80, NUM_POINTS);

[X,Y] = meshgrid(x,y);
Z = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j);Y(i,j)];
        ProbCgivenP = mvnpdf(P,muC', sigmaC);
        ProbC = nC;
        WeightedProbC = ProbC * ProbCgivenP;
        
        ProbDgivenP = mvnpdf(P,muD', sigmaD);
        ProbD = nD;
        WeightedProbD = ProbD * ProbDgivenP;
        
        ProbEgivenP = mvnpdf(P,muE', sigmaE);
        ProbE = nE;
        WeightedProbE = ProbE * ProbEgivenP;
    
        if WeightedProbC > WeightedProbD && WeightedProbC > WeightedProbE
            Z(i,j) = 0;
        elseif WeightedProbD > WeightedProbE
            Z(i,j) = 1;
        else
            Z(i,j) = 2;
        end
    end
end
contour(X,Y,Z,2,'r');