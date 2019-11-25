function [gryImg,mnyImg] = mkMooney(fileDir,varargin)
% %% make mooney image %%
% [oriImg,mnyImg] = mkMooney(fileDir,varargin)
% opt = struct(              ...
%     'sig',    3,           ...
%     'size',  [500,500],    ...
%     'weight', 0.5);

% check option
opt = struct(              ...
    'sig',    1,           ...
    'size',  [500,500],    ...
    'weight', 0.5);
opt = checkOptions(opt,varargin{:});

% load original image
%oriImg = imresize(rgb2gray(imread(fileDir)),opt.size);
if ~strcmp(class(fileDir),'uint8')
    loadImg = imread(fileDir);
else
    loadImg = fileDir;
end
oriImg = im2double(imresize(loadImg,opt.size));

% phase shuffled images
% phsShfImg = zeros(size(oriImg));
% for c = 1:3    
%     fftImg = fft2(oriImg(:,:,c));
%     phsShf = opt.weight.*angle(fftImg) + (1-opt.weight).*angle(fft2(rand(opt.size)));
%     %ph = angle(fftImg);
%     %phsShf = opt.weight.*angle(fftImg) + (1-opt.weight).*reshape(ph(randperm(500*500)),500,500);
%     phsShfImg(:,:,c) = real(ifft2(abs(fftImg).*exp(1j*phsShf)));
% end
% 
% 
% phsShfImg = (phsShfImg+oriImg)./2;
% phsShfImg = im2double(phsShfImg);

% gaussian filtering 
if size(oriImg,3) ~= 1,
    gryImg = rgb2gray(oriImg);
else
    gryImg = oriImg;
end
gauImg = imgaussfilt(gryImg,opt.sig);

% split thresholding
binLv = median(gauImg(:));
%binLv = graythresh(gauImg).*255;
mnyImg = zeros(opt.size);
mnyImg(gauImg>binLv)=1;

mnyImg = mnyImg.*255;
gryImg = gryImg.*255;
%figure;imshow(mnyImg)

end