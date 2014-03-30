%
% APLOT - plots sets of two dimensional features, using an
%         alphanumeric character to represent each set.
%
% Usage: aplot( x )
%         where x is a (3 by n) matrix:
%               x(1,:) - the horizontal (x-axis) value of each feature point
%               x(2,:) - the vertical (y-axis) value of each feature point
%               x(3,:) - an integer labeling the set that the feature belongs to
%              

function aplot(x,y)

if (size(x,1)<3),
  error( 'x must have at least 3 rows.' );
end;

% Can supply optional second argument to indicate starting symbol
if (nargin > 1), 
  c = setstr(y(1));
else,
  c = 'A';
end;

f = min(x(3,:));
while (length(f)>0),
  a = find(x(3,:)==f);
  text(x(1,a),x(2,a),c,'HorizontalAlignment','center');
  a = find(x(3,:)>f);
  f = min(x(3,a));
  c = setstr(c + 1);
end;

axis([0 max(x(1,:)) 0 max(x(2,:))])
