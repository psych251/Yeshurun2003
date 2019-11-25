clear

genDir=pwd;
addpath(genpath(fullfile(genDir,'_FUNC')));
dataDir = fullfile(genDir,'_DATA','behavior');
alldata = getAllFiles(dataDir,'*.mat',1);

subID = strsplit(fileparts(alldata{1}),'/');
subID = subID{end};
catData=[];catSub=[];
for i = 1:length(alldata)
    
   e = load(alldata{i},'emat','response');
   e = flattenStruct2Cell(e);
   e = cell2mat(e);
   
   
   subID = strsplit(fileparts(alldata{i}),'/');
   subID = subID{end};
%    sub{1}=subID;
   sub_a=cellstr(repmat(subID,size(e,1),1));

%     e =[sub_a e];
   catSub  = [catSub; sub_a];
   catData = [catData; e];
   
end
%%
catData(:,end+1)=(catData(:,2)==catData(:,5));
targetLoc=catData(:,3);
ISI=catData(:,4);
locs=[0 100 6 9 13 16];

for c = 1: length(unique(targetLoc))
    targetLoc(find(targetLoc==c)) = locs(c);
end
targetLoc(find(targetLoc==100)) = 3;

ISIs=[11 23 35];
for c = 1: length(ISIs)
    ISI(find(ISI==c)) = ISIs(c);
end

catData(:,3)=targetLoc;
catData(:,4)=ISI;

%
%%
variables={'cue','numFlash','targetLoc','ISI','response','RT','accuracy'};
sptioTemporal = dataset({catData,variables{:}});
sptioTemporal.sub=catSub;


export(sptioTemporal,'File','../data/sptioTemporal.csv','Delimiter',',');


% fileparts(alldata{1})
% 
% [filepath,name,ext] = fileparts(alldata{1})
% 
% fileparts(alldata{1})
% s = regexp(fileparts(alldata{1}), '/', 'split')
