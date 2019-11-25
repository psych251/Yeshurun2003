function out = mkMotionCapture(outRadius,innRadius,ratio,bdgCol,ph)
% outRadius :: outter radius
% innRadius :: inner radius of the circular stimulus 
% ratio     :: ratio random pixels superimposed
% bdgCol    :: background color
% ph        :: how many phase to be in the circle?
if nargin< 5, ph = 4; end

% make sine-wave grating
[x,y] = meshgrid(1:outRadius);
ang = round(atan2d(y-round(outRadius/2),x-round(outRadius/2)));
briBox = zeros(outRadius);
for a = -180:180,
    briBox(ang==a) = (sind(a*ph)+1)/2;
end

% superimpose
randBox = rand(outRadius);
out = (randBox*ratio+briBox*(1-ratio));
out = out-min(out(:));
out = out./max(out(:));
out = out.*255;

% make it circle
dis = sqrt(sum((cat(3,x,y)-round(outRadius/2)).^2,3));
out(dis>outRadius/2) = bdgCol;
out(dis<innRadius/2) = bdgCol;

end