%
% Parzen - compute 2-D density estimates
%
% [p,x,y] = parzen( data, res, win )    
%
%  data - two-column matrix of (x,y) points
%         (third row/col optional point frequency)
%  res  - resolution (step size)
%         optionally [res lowx lowy highx highy]
%  win  - optional, gives form of window 
%          if a scalar - radius of square window
%          if a vector - radially symmetric window
%          if a matrix - actual 2D window shape
%
%  x    - locations along x-axis
%  y    - locations along y-axis
%  p    - estimated 2D PDF
%

%
% P. Fieguth
% Nov. 1997
%

function [p,x,y] = parzen( data, res, win )

if (size(data,2)>size(data,1)), data = data'; end;
if (size(data,2)==2), data = [data ones(size(data))]; end;
numpts = sum(data(:,3));

dl = min(data(:,1:2));
dh = max(data(:,1:2));
if length(res)>1, dl = [res(2) res(3)]; dh = [res(4) res(5)]; res = res(1); end;

if (nargin == 2), win = 10; end;
if (max(dh-dl)/res>1000), 
  error('Excessive data range relative to resolution.');
end;

if length(win)==1, win = ones(1,win); end;
if min(size(win))==1, win = win(:) * win(:)'; end;
win = win / (res*res*sum(sum(win)));

p = zeros(2+(dh(2)-dl(2))/res,2+(dh(1)-dl(1))/res);
fdl1 = find(data(:,1)>dl(1));
fdh1 = find(data(fdl1,1)<dh(1));
fdl2 = find(data(fdl1(fdh1),2)>dl(2));
fdh2 = find(data(fdl1(fdh1(fdl2)),2)<dh(2));

for i=fdl1(fdh1(fdl2(fdh2)))',
  j1 = round(1+(data(i,1)-dl(1))/res);
  j2 = round(1+(data(i,2)-dl(2))/res);
  p(j2,j1) = p(j2,j1) + data(i,3);
end;

p = conv2(p,win,'same')/numpts;
x = [dl(1):res:(dh(1)+res)]; x = x(1:size(p,2));
y = [dl(2):res:(dh(2)+res)]; y = y(1:size(p,1));