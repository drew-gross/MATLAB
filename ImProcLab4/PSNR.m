function [ PSNR_out ] = PSNR( source,restored )
%Find the PSNR of image g WRT image f

dim = size(source);
MSE = sum(sum((source-restored).^2)) / (dim(1) * dim(2));
MAXf = max(max(source));
PSNR_out = 10*log10(double(MAXf^2)/double(MSE));

end

