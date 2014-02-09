%
% Plot_Ellipse(x,y,theta,a,b)
%
% This routine plots an ellipse with centre (x,y), axis lengths a,b
% with major axis at an angle of theta radians from the horizontal.
%
% *** Note: many students had a LOT of trouble with this.
%           I suggest you take a little time to look at this routine
%           to see how it works.  It's only four lines of code, but
%           some people spent hours trying to write something like
%           this themselves last year.
%

%
% Author: P. Fieguth
%         Jan. 98
%

function plot_ellipse(x,y,theta,a,b)

if nargin<5, error('Too few arguments to Plot_Ellipse.'); end;

np = 100;
ang = [0:np]*2*pi/np;
pts = [x;y]*ones(size(ang)) + [cos(theta) -sin(theta); sin(theta) cos(theta)]*[cos(ang)*a; sin(ang)*b];
plot( pts(1,:), pts(2,:) );