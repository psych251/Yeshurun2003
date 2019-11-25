function out = mkMotionDisk(radius,ratio,phshift,bdgCol,ph)
% out = mkMotionDisk(radius,ratio,move,bdgCol,ph)
% radius  :: outter radius
% ratio   :: ratio random pixels superimposed
% phshift :: phase shift (in degree)
% bdgCol  :: background color
% ph      :: how many phase to be in the circle?
if nargin< 5, ph = 4; end

% make sine-wave grating
[x,y] = meshgrid(1:radius);
briBox = (sin(x./radius.*2*pi.*ph-(phshift/180)*pi)+1)./2;
%pcolor(briBox);shading flat

% superimpose
randBox = rand(radius);
out = (randBox*ratio+briBox*(1-ratio))*255;

% make it circle
%dis = sqrt(sum((cat(3,x,y)-round(radius/2)).^2,3));
%out(dis>radius/2) = bdgCol;

end