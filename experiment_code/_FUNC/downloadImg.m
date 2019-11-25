function status = downloadImg(url,varargin)
% download image to directory
% format mooney image
% example url:: url = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00015388';

% check options
opt = struct(...
    'category',  'noname',   ...
    'directory',  pwd,       ...
    'size',       [500,500], ...
    'sig',        2,         ...
    'verbose',    1);
opt = checkOptions(opt,varargin{:});
opt.fileName = fullfile(opt.directory,sprintf('%s_%d.mat',opt.category,opt.sig));

% main
status = exist(opt.fileName);
if ~status
    % read from url
    [rdtxt,urlstatus] = urlread(url);
    if ~urlstatus, error('unable to read url!'); end
    
    bgnIdx = [strfind(rdtxt,'http'),length(rdtxt)+1];
    n = length(bgnIdx)-1;
    
    imgUrls = cell(n,1);
    for k = 1:n, imgUrls{k,1} = rdtxt(bgnIdx(k):(bgnIdx(k+1)-1)); end
    
    % image process
    oriImgs = zeros([opt.size,n]);
    mnyImgs = zeros([opt.size,n]);
    parfor k = 1:n
        try
            rdImg = imread(imgUrls{k,1}); % colorful original
            gryImg = rgb2gray(rdImg);     % gray       
            sz = size(gryImg);            
            
            [~,maxIdx] = max(sz);
            maxCnt = round(sz(maxIdx))/2+1;
            minHalf = round(sz(setdiff(1:2,maxIdx))/2);
            if maxIdx==1,
                rszImg = imresize(gryImg((maxCnt-minHalf):(maxCnt+minHalf),:),opt.size);
            else
                rszImg = imresize(gryImg((maxCnt-minHalf):(maxCnt+minHalf),:),opt.size);
            end % resizing
            gasImg = imgaussfilt(rszImg,opt.sig); % guassian filter 
            binlevel = graythresh(gasImg)*255; % otsu thresholding
            mnyImg = zeros(opt.size);
            mnyImg(gasImg>binlevel)=1;
            
            oriImgs(:,:,k) = rszImg;
            mnyImgs(:,:,k) = mnyImg;
            
            if opt.verbose, fprintf('reading N processing image...\n'); end
        end
    end
    
    rdImgIdx = squeeze(sum(sum(oriImgs,1),2)~=0);
    oriImgs = oriImgs(:,:,rdImgIdx);
    mnyImgs = mnyImgs(:,:,rdImgIdx);
    
    save(opt.fileName,'oriImgs','mnyImgs','-v7.3');
    
    %figure;imshow(oriImgs(:,:,1)./255)
    %figure;imshow(mnyImgs(:,:,1))
    status = 1;
end

end