
imgSz = [500,500];
genDir = 'C:\Users\user\Desktop\mooney';
addpath(genpath(fullfile(genDir,'_FUNC')));
imgDir = fullfile(genDir,'imgnet');
catOriDir = fullfile(imgDir,'original');
catSavDir = fullfile(imgDir,'twotone');
imgNames = union(getAllFiles(catOriDir,'*.png',0),getAllFiles(catOriDir,'*.jpeg',0));

for i = 1:length(imgNames)
    cImg = imread(fullfile(catOriDir,imgNames{i}));
    if size(cImg,3)~=1, cImg = rgb2gray(cImg); end
    [img.ori,img.mny] = mkMooney(cImg,'sig',1,'size',imgSz);
    save(fullfile(catSavDir,[imgNames{i}(1:end-3),'mat']),'img');
end

pics=getAllFiles(catSavDir,'*.mat',0);

for t = 40:50 %length(pics)
a=load([catSavDir '/' pics{t}]);
this=a.img.mny;
%     save(fullfile(catSavDir2,[pics{t}(1:end-3),'jpg']),'this');

figure()
imagesc(a.img.ori);
colormap(gray);

figure()
imagesc(a.img.mny);
colormap(gray);

end