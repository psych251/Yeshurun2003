
Url = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n01316949';
animalUrl = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00015388';
humanUrl = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00007846';
artifactUrl = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00021939';


category = {'all','animal','human','artifact'};
urls{1} = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n01316949'; %all
urls{2} = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00015388'; %animal
urls{3} = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00007846'; %human
urls{4} = 'http://www.image-net.org/api/text/imagenet.synset.geturls?wnid=n00021939'; %artifact

for u = 1:length(category)
    downloadImgs(urls{u},'category',category{u},'directory','../_DATA/imgs','sig',2);
end
