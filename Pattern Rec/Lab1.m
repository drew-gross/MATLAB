NUM_POINTS = 200;
NUM_POINTS_NN = 90;

% part 1
muA = [5 10];
nA = 200;
sigmaA = [8 0;0 4];
A = repmat(muA, nA, 1) + randn(nA, 2)*sigmaA;
ASample = repmat(muA, nA, 1) + randn(nA, 2)*sigmaA;

muB = [10 15];
nB = 200;
sigmaB = [8 0;0 4];
B = repmat(muB, nB, 1) + randn(nB, 2)*sigmaB;
BSample = repmat(muB, nB, 1) + randn(nB, 2)*sigmaB;
% part 2
muC = [5 10];
nC = 100;
sigmaC = [8 4;4 40];
C = repmat(muC, nC, 1) + randn(nC, 2)*sigmaC;
CSample = repmat(muC, nC, 1) + randn(nC, 2)*sigmaC;

muD = [15 10];
nD = 200;
sigmaD = [8 0;0 8];
D = repmat(muD, nD, 1) + randn(nD, 2)*sigmaD;
DSample = repmat(muD, nD, 1) + randn(nD, 2)*sigmaD;

muE = [10 5];
nE = 150;
sigmaE = [10 -5; -5 20];
E = repmat(muE, nE, 1) + randn(nE, 2)*sigmaE;
ESample = repmat(muE, nE, 1) + randn(nE, 2)*sigmaE;

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
x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z_med_AB = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        A_dist = sqrt((X(i,j)-muA(1))^2 + (Y(i,j)-muA(2))^2);
        B_dist = sqrt((X(i,j)-muB(1))^2 + (Y(i,j)-muB(2))^2);
        if A_dist < B_dist
            Z_med_AB(i,j)=0;
        else
            Z_med_AB(i,j)=1;
        end
    end
end

% GED for A and B
[eig_vec_A, eig_val_A] = eig(sigmaA);
[eig_vec_B, eig_val_B] = eig(sigmaB);

WA = (eig_val_A^(-1/2))*(eig_vec_A');
WB = (eig_val_B^(-1/2))*(eig_vec_B');

muA_ged = WA * muA';
muB_ged = WB * muB';

x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z_ged_AB = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j);Y(i,j)];
        PAwhite = WA * P;
        PBwhite = WB * P;
        
        A_dist = sqrt((PAwhite(1)-muA_ged(1))^2 + (PAwhite(2)-muA_ged(2))^2);
        B_dist = sqrt((PBwhite(1)-muB_ged(1))^2 + (PBwhite(2)-muB_ged(2))^2);
        
        if A_dist < B_dist
            Z_ged_AB(i,j)=0;
        else
            Z_ged_AB(i,j)=1;
        end
    end
end

% MAP for A and B

x = linspace(-20,30,NUM_POINTS);
y = linspace(-5,30,NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z_map_AB = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j);Y(i,j)];
        ProbAgivenP = mvnpdf(P,muA', sigmaA);
        ProbA = nA;
        WeightedProbA = ProbA * ProbAgivenP;
        
        ProbBgivenP = mvnpdf(P,muB', sigmaB);
        ProbB = nB;
        WeightedProbB = ProbB * ProbBgivenP;
        
        if WeightedProbA > WeightedProbB
            Z_map_AB(i,j)=0;
        else
            Z_map_AB(i,j)=1;
        end
    end
end

newfig;
xlabel('X');
ylabel('Y');
title('MED, GED, and MAP for Class A and B');
scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
contour(X,Y,Z_med_AB,1,'r');
contour(X,Y,Z_ged_AB,1,'g');
contour(X,Y,Z_map_AB,1,'b');

%Calculating the confusion matrix:
ABMEDConfusion = zeros(2,2);

for i=1:length(ASample)
    A_dist = sqrt((ASample(i,1)-muA(1))^2 + (ASample(i,2)-muA(2))^2);
    B_dist = sqrt((ASample(i,1)-muB(1))^2 + (ASample(i,2)-muB(2))^2);
    if A_dist < B_dist
        ABMEDConfusion(1,1) = ABMEDConfusion(1,1) + 1;
    else
        ABMEDConfusion(1,2) = ABMEDConfusion(1,2) + 1;
    end
end

for i=1:length(BSample)
    A_dist = sqrt((BSample(i,1)-muA(1))^2 + (BSample(i,2)-muA(2))^2);
    B_dist = sqrt((BSample(i,1)-muB(1))^2 + (BSample(i,2)-muB(2))^2);
    if A_dist < B_dist
        ABMEDConfusion(2,1) = ABMEDConfusion(2,1) + 1;
    else
        ABMEDConfusion(2,2) = ABMEDConfusion(2,2) + 1;
    end
end

% MED for C, D, and E
x = linspace(-25,45, NUM_POINTS);
y = linspace(-80,80, NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z_med_CDE = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        C_dist = sqrt((X(i,j) - muC(1))^2 + (Y(i,j)-muC(2))^2);
        D_dist = sqrt((X(i,j) - muD(1))^2 + (Y(i,j)-muD(2))^2);
        E_dist = sqrt((X(i,j) - muE(1))^2 + (Y(i,j)-muE(2))^2);
        if C_dist < D_dist && C_dist < E_dist
            Z_med_CDE(i,j) = 0;
        elseif D_dist < E_dist
            Z_med_CDE(i,j) = 1;
        else
            Z_med_CDE(i,j) = 2;
        end
    end
end

%GED for C, D, and E

[eig_vec_C, eig_val_C] = eig(sigmaC);
[eig_vec_D, eig_val_D] = eig(sigmaD);
[eig_vec_E, eig_val_E] = eig(sigmaE);

WC = (eig_val_C^(-1/2))*(eig_vec_C');
WD = (eig_val_D^(-1/2))*(eig_vec_D');
WE = (eig_val_E^(-1/2))*(eig_vec_E');

muC_ged = WC * muC';
muD_ged = WD * muD';
muE_ged = WE * muE';

x = linspace(-25,45, NUM_POINTS);
y = linspace(-80,80, NUM_POINTS);

[X,Y] = meshgrid(x,y);
Z_ged_CDE = zeros(length(x));
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
            Z_ged_CDE(i,j) = 0;
        elseif D_dist < E_dist
            Z_ged_CDE(i,j) = 1;
        else
            Z_ged_CDE(i,j) = 2;
        end
    end
end

%MAP for C, D, and E
x = linspace(-25,45, NUM_POINTS);
y = linspace(-80,80, NUM_POINTS);
[X,Y] = meshgrid(x,y);
Z_map_CDE = zeros(length(x));
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
            Z_map_CDE(i,j) = 0;
        elseif WeightedProbD > WeightedProbE
            Z_map_CDE(i,j) = 1;
        else
            Z_map_CDE(i,j) = 2;
        end
    end
end

newfig;
xlabel('X');
ylabel('Y');
title('MED, GED, and MAP for class C, D, and E');
scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);
contour(X,Y,Z_med_CDE,1,'r');
contour(X,Y,Z_med_CDE.*-1,1,'r');
contour(X,Y,Z_ged_CDE,1,'g');
contour(X,Y,Z_ged_CDE.*-1,1,'g');
contour(X,Y,Z_map_CDE,1,'b');
contour(X,Y,Z_map_CDE.*-1,1,'b');

%Calculating the confusion matrix:
CDEMEDConfusion = zeros(3,3);

for i=1:length(CSample)
    C_dist = sqrt((CSample(i,1) - muC(1))^2 + (CSample(i,2)-muC(2))^2);
    D_dist = sqrt((CSample(i,1) - muD(1))^2 + (CSample(i,2)-muD(2))^2);
    E_dist = sqrt((CSample(i,1) - muE(1))^2 + (CSample(i,2)-muE(2))^2);
    if C_dist < D_dist && C_dist < E_dist
        CDEMEDConfusion(1,1) = CDEMEDConfusion(1,1) + 1;
    elseif D_dist < E_dist
        CDEMEDConfusion(1,2) = CDEMEDConfusion(1,2) + 1;
    else
        CDEMEDConfusion(1,3) = CDEMEDConfusion(1,3) + 1;
    end
end

for i=1:length(DSample)
    C_dist = sqrt((DSample(i,1) - muC(1))^2 + (DSample(i,2)-muC(2))^2);
    D_dist = sqrt((DSample(i,1) - muD(1))^2 + (DSample(i,2)-muD(2))^2);
    E_dist = sqrt((DSample(i,1) - muE(1))^2 + (DSample(i,2)-muE(2))^2);
    if C_dist < D_dist && C_dist < E_dist
        CDEMEDConfusion(2,1) = CDEMEDConfusion(2,1) + 1;
    elseif D_dist < E_dist
        CDEMEDConfusion(2,2) = CDEMEDConfusion(2,2) + 1;
    else
        CDEMEDConfusion(2,3) = CDEMEDConfusion(2,3) + 1;
    end
end

for i=1:length(ESample)
    C_dist = sqrt((ESample(i,1) - muC(1))^2 + (ESample(i,2)-muC(2))^2);
    D_dist = sqrt((ESample(i,1) - muD(1))^2 + (ESample(i,2)-muD(2))^2);
    E_dist = sqrt((ESample(i,1) - muE(1))^2 + (ESample(i,2)-muE(2))^2);
    if C_dist < D_dist && C_dist < E_dist
        CDEMEDConfusion(3,1) = CDEMEDConfusion(3,1) + 1;
    elseif D_dist < E_dist
        CDEMEDConfusion(3,2) = CDEMEDConfusion(3,2) + 1;
    else
        CDEMEDConfusion(3,3) = CDEMEDConfusion(3,3) + 1;
    end
end

%Calculating the confusion matrix:
ABGEDConfusion = zeros(2,2);
for i=1:length(ASample)
    P = [ASample(i,1);ASample(i,2)];
    PAwhite = WA * P;
    PBwhite = WB * P;

    A_dist = sqrt((PAwhite(1)-muA_ged(1))^2 + (PAwhite(2)-muA_ged(2))^2);
    B_dist = sqrt((PBwhite(1)-muB_ged(1))^2 + (PBwhite(2)-muB_ged(2))^2);

    if A_dist < B_dist
        ABGEDConfusion(1,1) = ABGEDConfusion(1,1) + 1;
    else
        ABGEDConfusion(1,2) = ABGEDConfusion(1,2) + 1;
    end
end

for i=1:length(BSample)
    P = [BSample(i,1);BSample(i,2)];
    PAwhite = WA * P;
    PBwhite = WB * P;

    A_dist = sqrt((PAwhite(1)-muA_ged(1))^2 + (PAwhite(2)-muA_ged(2))^2);
    B_dist = sqrt((PBwhite(1)-muB_ged(1))^2 + (PBwhite(2)-muB_ged(2))^2);

    if A_dist < B_dist
        ABGEDConfusion(2,1) = ABGEDConfusion(2,1) + 1;
    else
        ABGEDConfusion(2,2) = ABGEDConfusion(2,2) + 1;
    end
end



%Confusion Matrix Calculation

CDEGEDConfusion = zeros(3,3);

for i=1:length(CSample)
    P = [CSample(i,1);CSample(i,2)];
    PCwhite = WC * P;
    PDwhite = WD * P;
    PEwhite = WE * P;

    C_dist = sqrt((PCwhite(1)-muC_ged(1))^2 + (PCwhite(2)-muC_ged(2))^2);
    D_dist = sqrt((PDwhite(1)-muD_ged(1))^2 + (PDwhite(2)-muD_ged(2))^2);
    E_dist = sqrt((PEwhite(1)-muE_ged(1))^2 + (PEwhite(2)-muE_ged(2))^2);

    if C_dist < D_dist && C_dist < E_dist
        CDEGEDConfusion(1,1) = CDEGEDConfusion(1,1) + 1;
    elseif D_dist < E_dist
        CDEGEDConfusion(1,2) = CDEGEDConfusion(1,2) + 1;
    else
        CDEGEDConfusion(1,3) = CDEGEDConfusion(1,3) + 1;
    end
end

for i=1:length(DSample)
    P = [DSample(i,1);DSample(i,2)];
    PCwhite = WC * P;
    PDwhite = WD * P;
    PEwhite = WE * P;

    C_dist = sqrt((PCwhite(1)-muC_ged(1))^2 + (PCwhite(2)-muC_ged(2))^2);
    D_dist = sqrt((PDwhite(1)-muD_ged(1))^2 + (PDwhite(2)-muD_ged(2))^2);
    E_dist = sqrt((PEwhite(1)-muE_ged(1))^2 + (PEwhite(2)-muE_ged(2))^2);

    if C_dist < D_dist && C_dist < E_dist
        CDEGEDConfusion(2,1) = CDEGEDConfusion(2,1) + 1;
    elseif D_dist < E_dist
        CDEGEDConfusion(2,2) = CDEGEDConfusion(2,2) + 1;
    else
        CDEGEDConfusion(2,3) = CDEGEDConfusion(2,3) + 1;
    end
end

for i=1:length(ESample)
    P = [ESample(i,1);ESample(i,2)];
    PCwhite = WC * P;
    PDwhite = WD * P;
    PEwhite = WE * P;

    C_dist = sqrt((PCwhite(1)-muC_ged(1))^2 + (PCwhite(2)-muC_ged(2))^2);
    D_dist = sqrt((PDwhite(1)-muD_ged(1))^2 + (PDwhite(2)-muD_ged(2))^2);
    E_dist = sqrt((PEwhite(1)-muE_ged(1))^2 + (PEwhite(2)-muE_ged(2))^2);

    if C_dist < D_dist && C_dist < E_dist
        CDEGEDConfusion(3,1) = CDEGEDConfusion(3,1) + 1;
    elseif D_dist < E_dist
        CDEGEDConfusion(3,2) = CDEGEDConfusion(3,2) + 1;
    else
        CDEGEDConfusion(3,3) = CDEGEDConfusion(3,3) + 1;
    end
end

%Confusion matrix calculation:

ABMAPConfusion = zeros(2,2);

for i=1:length(ASample)
    P = [ASample(i,1);ASample(i,2)];
    ProbAgivenP = mvnpdf(P,muA', sigmaA);
    ProbA = nA;
    WeightedProbA = ProbA * ProbAgivenP;

    ProbBgivenP = mvnpdf(P,muB', sigmaB);
    ProbB = nB;
    WeightedProbB = ProbB * ProbBgivenP;

    if WeightedProbA > WeightedProbB
        ABMAPConfusion(1,1) = ABMAPConfusion(1,1) + 1;
    else
        ABMAPConfusion(1,2) = ABMAPConfusion(1,2) + 1;
    end
end

for i=1:length(BSample)
    P = [BSample(i,1);BSample(i,2)];
    ProbAgivenP = mvnpdf(P,muA', sigmaA);
    ProbA = nA;
    WeightedProbA = ProbA * ProbAgivenP;

    ProbBgivenP = mvnpdf(P,muB', sigmaB);
    ProbB = nB;
    WeightedProbB = ProbB * ProbBgivenP;

    if WeightedProbA > WeightedProbB
        ABMAPConfusion(2,1) = ABMAPConfusion(2,1) + 1;
    else
        ABMAPConfusion(2,2) = ABMAPConfusion(2,2) + 1;
    end
end

%Confusion Matrix Calculation:
CDEMAPConfusion = zeros(3,3);

for i=1:length(CSample)
    P = [CSample(i,1);CSample(i,2)];
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
        CDEMAPConfusion(1,1) = CDEMAPConfusion(1,1) + 1;
    elseif WeightedProbD > WeightedProbE
        CDEMAPConfusion(1,2) = CDEMAPConfusion(1,2) + 1;
    else
        CDEMAPConfusion(1,3) = CDEMAPConfusion(1,3) + 1;
    end
end

for i=1:length(DSample)
    P = [DSample(i,1);DSample(i,2)];
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
        CDEMAPConfusion(2,1) = CDEMAPConfusion(2,1) + 1;
    elseif WeightedProbD > WeightedProbE
        CDEMAPConfusion(2,2) = CDEMAPConfusion(2,2) + 1;
    else
        CDEMAPConfusion(2,3) = CDEMAPConfusion(2,3) + 1;
    end
end

for i=1:length(ESample)
    P = [ESample(i,1);ESample(i,2)];
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
        CDEMAPConfusion(3,1) = CDEMAPConfusion(3,1) + 1;
    elseif WeightedProbD > WeightedProbE
        CDEMAPConfusion(3,2) = CDEMAPConfusion(3,2) + 1;
    else
        CDEMAPConfusion(3,3) = CDEMAPConfusion(3,3) + 1;
    end
end

%NN for A and B
x = linspace(-20,30,NUM_POINTS_NN);
y = linspace(-5,30,NUM_POINTS_NN);
[X,Y] = meshgrid(x,y);
Z_nn_AB = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)

        P = [X(i,j) Y(i,j)];
        A_dist = Inf;
        for k=1:length(A)
            A_dist = min(A_dist, norm(A(k,:) - P));
        end
        B_dist = Inf;
        for k=1:length(B)
            B_dist = min(B_dist, norm(B(k,:) - P));
        end
        if A_dist < B_dist
            Z_nn_AB(i,j) = 0;
        else
            Z_nn_AB(i,j) = 1;
        end
    end
end

%5NN for A and B

x = linspace(-20,30,NUM_POINTS_NN);
y = linspace(-5,30,NUM_POINTS_NN);
[X,Y] = meshgrid(x,y);
Z_5nn_AB = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j) Y(i,j)];
        kNearestA = knearest(A, P, 5);
        kNearestB = knearest(B, P, 5);
        A_proto = mean(kNearestA);
        B_proto = mean(kNearestB);
        if norm(P - A_proto) < norm(P - B_proto)
            Z_5nn_AB(i,j) = 0;
        else
            Z_5nn_AB(i,j) = 1;
        end
    end
end

newfig;
xlabel('X');
ylabel('Y');
title('NN and 5NN for A and B');
scatter(A(:,1),A(:,2),'x');scatter(B(:,1),B(:,2), '+');
plot_ellipse(5, 10, 0, 8, 4);plot_ellipse(10, 15, 0, 8, 4);
contour(X,Y,Z_nn_AB,1,'r');
contour(X,Y,Z_5nn_AB,1,'b');

%Confusion Matrix Calculation

ABNNConfusion = zeros(2,2);

for i=1:length(ASample)
    P = [ASample(i,1) ASample(i,2)];
    A_dist = Inf;
    for k=1:length(A)
        A_dist = min(A_dist, norm(A(k,:) - P));
    end
    B_dist = Inf;
    for k=1:length(B)
        B_dist = min(B_dist, norm(B(k,:) - P));
    end
    if A_dist < B_dist
        ABNNConfusion(1,1) = ABNNConfusion(1,1) + 1;
    else
        ABNNConfusion(1,2) = ABNNConfusion(1,2) + 1;
    end
end

for i=1:length(BSample)
    P = [BSample(i,1) BSample(i,2)];
    A_dist = Inf;
    for k=1:length(A)
        A_dist = min(A_dist, norm(A(k,:) - P));
    end
    B_dist = Inf;
    for k=1:length(B)
        B_dist = min(B_dist, norm(B(k,:) - P));
    end
    if A_dist < B_dist
        ABNNConfusion(2,1) = ABNNConfusion(2,1) + 1;
    else
        ABNNConfusion(2,2) = ABNNConfusion(2,2) + 1;
    end
end

% NN for Class C, D, and E
x = linspace(-25,45, NUM_POINTS_NN);
y = linspace(-80,80, NUM_POINTS_NN);
[X,Y] = meshgrid(x,y);
Z_nn_CDE = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j) Y(i,j)];
        C_dist = Inf;
        for k=1:length(C)
            C_dist = min(C_dist, norm(C(k,:) - P));
        end
        D_dist = Inf;
        for k=1:length(D)
            D_dist = min(D_dist, norm(D(k,:) - P));
        end
        E_dist = Inf;
        for k=1:length(E)
            E_dist = min(E_dist, norm(E(k,:) - P));
        end
        if C_dist < D_dist && C_dist < E_dist
            Z_nn_CDE(i,j) = 0;
        elseif D_dist < E_dist
            Z_nn_CDE(i,j) = 1;
        else
            Z_nn_CDE(i,j) = 2;
        end
    end
end
%5NN for C, D, and E
x = linspace(-25,45, NUM_POINTS_NN);
y = linspace(-80,80, NUM_POINTS_NN);
[X,Y] = meshgrid(x,y);
Z_5nn_CDE = zeros(length(x));
for i=1:length(x)
    for j=1:length(y)
        P = [X(i,j) Y(i,j)];
        kNearestC = knearest(C, P, 5);
        kNearestD = knearest(D, P, 5);
        kNearestE = knearest(E, P, 5);
        C_proto = mean(kNearestC);
        D_proto = mean(kNearestD);
        E_proto = mean(kNearestE);
        C_dist = norm(P - C_proto);
        D_dist = norm(P - D_proto);
        E_dist = norm(P - E_proto);
        if C_dist < D_dist && C_dist < E_dist
            Z_5nn_CDE(i,j) = 0;
        elseif D_dist < E_dist
            Z_5nn_CDE(i,j) = 1;
        else
            Z_5nn_CDE(i,j) = 2;
        end
    end
end

newfig;
xlabel('x');
ylabel('y');
title('NN and 5NN for C, D, and E');
scatter(C(:,1),C(:,2),'x');scatter(D(:,1),D(:,2), '+');scatter(E(:,1),E(:,2), '.');
plot_ellipse(10, 5, atan2(-0.3827, -0.9239), 10, 20);plot_ellipse(15, 10, 0, 8, 8);plot_ellipse(5, 10, atan2(0.1222,-0.9925), 8, 40);
contour(X,Y,Z_nn_CDE,1,'r');
contour(X,Y,Z_nn_CDE.*-1,1,'r');
contour(X,Y,Z_5nn_CDE,1,'b');
contour(X,Y,Z_5nn_CDE.*-1,1,'b');

%Calculating Confusion Matrix

CDENNConfusion = zeros(3,3);

for i=1:length(CSample)
    P = [CSample(i,1) CSample(i,2)];
    C_dist = Inf;
    for k=1:length(C)
        C_dist = min(C_dist, norm(C(k,:) - P));
    end
    D_dist = Inf;
    for k=1:length(D)
        D_dist = min(D_dist, norm(D(k,:) - P));
    end
    E_dist = Inf;
    for k=1:length(E)
        E_dist = min(E_dist, norm(E(k,:) - P));
    end
    if C_dist < D_dist && C_dist < E_dist
        CDENNConfusion(1,1) = CDENNConfusion(1,1) + 1;
    elseif D_dist < E_dist
        CDENNConfusion(1,2) = CDENNConfusion(1,2) + 1;
    else
        CDENNConfusion(1,3) = CDENNConfusion(1,3) + 1;
    end
end

for i=1:length(DSample)
    P = [DSample(i,1) DSample(i,2)];
    C_dist = Inf;
    for k=1:length(C)
        C_dist = min(C_dist, norm(C(k,:) - P));
    end
    D_dist = Inf;
    for k=1:length(D)
        D_dist = min(D_dist, norm(D(k,:) - P));
    end
    E_dist = Inf;
    for k=1:length(E)
        E_dist = min(E_dist, norm(E(k,:) - P));
    end
    if C_dist < D_dist && C_dist < E_dist
        CDENNConfusion(2,1) = CDENNConfusion(2,1) + 1;
    elseif D_dist < E_dist
        CDENNConfusion(2,2) = CDENNConfusion(2,2) + 1;
    else
        CDENNConfusion(2,3) = CDENNConfusion(2,3) + 1;
    end
end

for i=1:length(ESample)
    P = [ESample(i,1) ESample(i,2)];
    C_dist = Inf;
    for k=1:length(C)
        C_dist = min(C_dist, norm(C(k,:) - P));
    end
    D_dist = Inf;
    for k=1:length(D)
        D_dist = min(D_dist, norm(D(k,:) - P));
    end
    E_dist = Inf;
    for k=1:length(E)
        E_dist = min(E_dist, norm(E(k,:) - P));
    end
    if C_dist < D_dist && C_dist < E_dist
        CDENNConfusion(3,1) = CDENNConfusion(3,1) + 1;
    elseif D_dist < E_dist
        CDENNConfusion(3,2) = CDENNConfusion(3,2) + 1;
    else
        CDENNConfusion(3,3) = CDENNConfusion(3,3) + 1;
    end
end

%Calculating the confusion matrix

ABKNNConfusion = zeros(2,2);

for i=1:length(ASample)
    P = [ASample(i,1) ASample(i,2)];
    kNearestA = knearest(A, P, 5);
    kNearestB = knearest(B, P, 5);
    A_proto = mean(kNearestA);
    B_proto = mean(kNearestB);
    if norm(P - A_proto) < norm(P - B_proto)
        ABKNNConfusion(1,1) = ABKNNConfusion(1,1) + 1;
    else
        ABKNNConfusion(1,2) = ABKNNConfusion(1,2) + 1;
    end
end

for i=1:length(BSample)
    P = [BSample(i,1) BSample(i,2)];
    kNearestA = knearest(A, P, 5);
    kNearestB = knearest(B, P, 5);
    A_proto = mean(kNearestA);
    B_proto = mean(kNearestB);
    if norm(P - A_proto) < norm(P - B_proto)
        ABKNNConfusion(2,1) = ABKNNConfusion(2,1) + 1;
    else
        ABKNNConfusion(2,2) = ABKNNConfusion(2,2) + 1;
    end
end

%Calculating Confusion Matrix

CDEKNNConfusion = zeros(3,3);
for i=1:length(CSample)
    P = [CSample(i,1) CSample(i,2)];
    kNearestC = knearest(C, P, 5);
    kNearestD = knearest(D, P, 5);
    kNearestE = knearest(E, P, 5);
    C_proto = mean(kNearestC);
    D_proto = mean(kNearestD);
    E_proto = mean(kNearestE);
    C_dist = norm(P - C_proto);
    D_dist = norm(P - D_proto);
    E_dist = norm(P - E_proto);
    if C_dist < D_dist && C_dist < E_dist
        CDEKNNConfusion(1,1) = CDEKNNConfusion(1,1) + 1;
    elseif D_dist < E_dist
        CDEKNNConfusion(1,2) = CDEKNNConfusion(1,2) + 1;
    else
        CDEKNNConfusion(1,3) = CDEKNNConfusion(1,3) + 1;
    end
end

for i=1:length(DSample)
    P = [DSample(i,1) DSample(i,2)];
    kNearestC = knearest(C, P, 5);
    kNearestD = knearest(D, P, 5);
    kNearestE = knearest(E, P, 5);
    C_proto = mean(kNearestC);
    D_proto = mean(kNearestD);
    E_proto = mean(kNearestE);
    C_dist = norm(P - C_proto);
    D_dist = norm(P - D_proto);
    E_dist = norm(P - E_proto);
    if C_dist < D_dist && C_dist < E_dist
        CDEKNNConfusion(2,1) = CDEKNNConfusion(2,1) + 1;
    elseif D_dist < E_dist
        CDEKNNConfusion(2,2) = CDEKNNConfusion(2,2) + 1;
    else
        CDEKNNConfusion(2,3) = CDEKNNConfusion(2,3) + 1;
    end
end

for i=1:length(ESample)
    P = [ESample(i,1) ESample(i,2)];
    kNearestC = knearest(C, P, 5);
    kNearestD = knearest(D, P, 5);
    kNearestE = knearest(E, P, 5);
    C_proto = mean(kNearestC);
    D_proto = mean(kNearestD);
    E_proto = mean(kNearestE);
    C_dist = norm(P - C_proto);
    D_dist = norm(P - D_proto);
    E_dist = norm(P - E_proto);
    if C_dist < D_dist && C_dist < E_dist
        CDEKNNConfusion(3,1) = CDEKNNConfusion(3,1) + 1;
    elseif D_dist < E_dist
        CDEKNNConfusion(3,2) = CDEKNNConfusion(3,2) + 1;
    else
        CDEKNNConfusion(3,3) = CDEKNNConfusion(3,3) + 1;
    end
end
