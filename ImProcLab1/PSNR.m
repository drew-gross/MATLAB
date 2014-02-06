function [ PSNR_out ] = PSNR( f,g )
%Find the PSNR of image g WRT image f

dim = size(f);
MSE = sum(sum((f-g).^2)) / (dim(1) * dim(2));
MAXf = max(max(f));
PSNR_out = 10*log10(double(MAXf^2)/double(MSE));

end

