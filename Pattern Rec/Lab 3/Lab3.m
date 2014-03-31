

%Part 3:

load('feat.mat');

[muf2, sigf2] = DevelopClassifier(f2);

confMatrixf2 = zeros(10,10);

for i=1:length(f2t)
    vec = [f2t(1,i);f2t(2,i)];
    realClass = f2t(3,i);
    class = MICDClassify(vec,muf2,sigf2);
    confMatrixf2(realClass,class) = confMatrixf2(realClass,class) + 1;
end

confMatrixf2



[muf8, sigf8] = DevelopClassifier(f8);

confMatrixf8 = zeros(10,10);

for i=1:length(f8t)
    vec = [f8t(1,i);f8t(2,i)];
    realClass = f8t(3,i);
    class = MICDClassify(vec,muf8,sigf8);
    confMatrixf8(realClass,class) = confMatrixf8(realClass,class) + 1;
end

confMatrixf8



[muf32, sigf32] = DevelopClassifier(f32);

confMatrixf32 = zeros(10,10);

for i=1:length(f32t)
    vec = [f32t(1,i);f32t(2,i)];
    realClass = f32t(3,i);
    class = MICDClassify(vec,muf32,sigf32);
    confMatrixf32(realClass,class) = confMatrixf32(realClass,class) + 1;
end

confMatrixf32


%Part 4:

matSize = size(multf8);
cimage = zeros(256,256);

for i=1:matSize(1)
    for j=1:matSize(2)
        vec = [multf8(i,j,1);multf8(i,j,2)];
        cimage(i,j) = MICDClassify(vec,muf8,sigf8);
    end
end

imagesc(cimage)
