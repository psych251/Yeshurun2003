
%% SpatioTemporal Replication proejct 
clear all; close all; clc;
rand('seed', GetSecs);
KbName('UnifyKeyNames'); % keyboard

Experimenter = -3;
Participant = -3;
Scanner = -3;

%% Subject information
subName = input('Subject Initials:  ', 's');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% directory setting
genDir = '/Users/kalanit/Experiments/replicate';
%genDir = '/Users/sangkyu/Box Sync/mooney';
addpath(genpath(fullfile(genDir,'_FUNC')));
dataDir = fullfile(genDir,'_DATA','behavior',subName);
if ~exist(dataDir) &&  ~strcmp(subName,'tes'), mkdir(dataDir); end
datas = getAllFiles(dataDir,'*.mat',1);
runN=length(datas)+1;
dataName = fullfile(dataDir,sprintf('exp1_%s_%d',subName,length(datas)+1));

%% screen setting
bdgcol = 128;
Screen('Preference', 'SkipSyncTests', 1);
ScreenNum = max(Screen('Screens'));
[wptr,rect]=Screen('OpenWindow',ScreenNum,[0 0 0]);
Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Screen('HideCursorHelper', wptr);
[cx, cy] = RectCenter(rect);
ifi = 1/85;

Screen('TextSize',wptr, 40);



%% experiment matrix design

fixaSz = 5;
totalTrial=864;
cond=[0,1]; % 1: cued 0: uncued
loc=[1:6];
type=[1,2]; % 1: single disk, 2: two disks
ISI_base=[1,2,3];
iteration=3; % this should be 12

[cueing,tarType,tarLoc,ISI]= ...
    BalanceFactors(iteration,1,cond,type,loc,ISI_base);

trialNum=1:length(cueing);
emat=[cueing,tarType,tarLoc,ISI];

if ~strcmp(subName,'tes'),save(dataName,'emat');end

%% experiment loop
Screen('DrawText',wptr,'start',cx/2,cy/2,[255 255 255]);
Screen('Flip',wptr);

scanPulse = 0;
while scanPulse ~= 1
    [keyIsDown, ~, keyCode] = KbCheck(Participant);
%     [keyIsDown, ~, keyCode] = PsychHID('KbCheck');
    if keyIsDown
        if  keyCode(KbName('s'))
            scanPulse = 1;
            break;
        end
    end
    WaitSecs(0.005);
end


TargetSize=deg2pixel(3);

% penWidth=round(deg2pixel(0.3));
penWidth=6;

% 0 3 6 9 13 16
ecc_vars=[0,deg2pixel(3), deg2pixel(6),deg2pixel(9),deg2pixel(13),deg2pixel(16)];
signSelect=[-1,1];

response=[];

%Time in frames
SOA=round(0.094/ifi); 
fixLen=round(1/ifi);
allList=[];
for tr=1:length(emat)
    %cueing,tarType,tarLoc,ISI
    emat(tr,:)
    
    tList=[9 10 11]; tLength1=tList(randperm(3,1));
    tISI_list=[1,2,3]; tISI=tISI_list(emat(tr,4));
    tLength2=4;

    
    TargetLocGrid=[cx+(ecc_vars(emat(tr,3))*signSelect(round(rand)+1)), cy];
    TargetLocGrid=round(TargetLocGrid);
    %fixation
    for iter = 1:fixLen
        Screen('FillOval',wptr,255*[0,0,1],[cx-fixaSz,cy-fixaSz,cx+fixaSz,cy+fixaSz]);
        Screen('Flip',wptr);
    end
    
    % cue
    if   emat(tr,1) ==1
        for iter = 1:fixLen
        Screen('DrawLine', wptr,255*[0,1,0], round(TargetLocGrid(1)-deg2pixel(1)),...
            round(cy-deg2pixel(0.5)-TargetSize/2), round(TargetLocGrid(1)+deg2pixel(1)), round(cy-deg2pixel(0.5)-TargetSize/2), penWidth);
 
        Screen('Flip',wptr);
        end
    else
        for iter = 1:fixLen
            Screen('DrawLine', wptr,255*[0,1,0], ...
                cx-(rect(3)/2),...
                round(cy-deg2pixel(0.5)-TargetSize/2), ...
                cx+(rect(3)/2),...
                round(cy-deg2pixel(0.5)-TargetSize/2),...
                penWidth);
            Screen('DrawLine', wptr,255*[0,1,0], ...
                cx-(rect(3)/2),...
                round(cy+deg2pixel(0.5)+TargetSize/2),...
                cx+(rect(3)/2), ...
                round(cy+deg2pixel(0.5)+TargetSize/2),...
                penWidth);
            Screen('Flip',wptr);
        end
        
    end

        % SOA
    for iter = 1:SOA % 94 ms
%         Screen('FillOval',wptr,255*[0,0,1],[cx-fixaSz,cy-fixaSz,cx+fixaSz,cy+fixaSz]);
        Screen('Flip',wptr);
    end
    
    Screen('Flip',wptr);

    % Target
%     
%     tLength1=100;
%     tLength2=100;
    if emat(tr,2) ==1
        for iter = 1:tLength1
            Screen('DrawDots', wptr, TargetLocGrid, TargetSize, [255 255 255], [], 2);
            %         Screen('DrawDots', wptr, [dotXpos dotYpos], dotSizePix, dotColor, [], 2);
            Screen('Flip',wptr);
        end
        
    elseif emat(tr,2)==2
        for on=1:tLength2
            Screen('DrawDots', wptr, TargetLocGrid, TargetSize, [255 255 255], [], 2);
            Screen('Flip',wptr);
        end
        
        for gap=1:tISI
            Screen('FillRect', wptr, [0 0 0]);
            Screen('Flip',wptr);
        end
        
        for off=1:tLength2
            Screen('DrawDots', wptr, TargetLocGrid, TargetSize, [255 255 255], [], 2);
            Screen('Flip',wptr);
        end
        
        
    end
    
    Screen('Flip',wptr);
%     RT_S=GetSecs;
    scanPulse = 0;
    while scanPulse ~= 1
        response(tr,1)=9; t1=GetSecs;
        [keyIsDown, ~, keyCode] = KbCheck(Participant);
%         [keyIsDown, ~, keyCode] = PsychHID('KbCheck');

        if keyIsDown
            if keyCode(KbName('1!'))
                response(tr,1) = 1;
                response(tr,2)=GetSecs-t1 ;
                break;
                
            end
            
            if keyCode(KbName('2@'))
                response(tr,1) = 2;
                response(tr,2)=GetSecs-t1 ;
                break;
            end
        end
    end
    RT_E=GetSecs;
%     RTs=RT_E-RT_S;
    allList=[allList; tr emat(tr,:) response(tr,:)];
    save(dataName,'emat','response','allList');

end


%put accuracy
 allList(:,end+1)= allList(:,3) == allList(:,6)

%%
%  keyPressed = 0; eKey = 0;
%         for a = 1: OnDurFrames % on duration
%             response(ss,nFlip) = 0;
%             Screen('DrawTexture',wptr,curImage,[],imgPos);
%             Screen('FillOval',wptr,255*[0,0,1],[cx-fixaSz,cy-fixaSz,cx+fixaSz,cy+fixaSz]);
%             Screen('Flip',wptr);
%             if sum(response(ss,nFlip-15:nFlip)) ~= 1
%                 [keyIsDown, ~, keyCode] = KbCheck(Scanner);
%                 if keyIsDown
%                     if keyCode(KbName('1!'))
%                         response(ss,nFlip) = 1;
%                     end
%                 end
%             end
%             nFlip = nFlip +1;
%         end
%
%             disp(['trial' num2str(ss) ': ' '[' curImgDis '] ' 'on:' num2str(ontime(ss)) ' ' 'off:' num2str(offtime(ss)) ' ' 'acc:' num2str(accc) '%']);
%
%
%
%             if ~strcmp(subName,'tes'),save(dataName,'emat','response','ontime','offtime');end
%
% totalAcc=num2str(round((sum(cell2mat(NumCorrect))/(NTarget*ss))*100));
% Dp=['Accuracy:' ' ' totalAcc '%'];
% DrawFormattedText(wptr,Dp,'center','center');
% Screen('Flip',wptr);
WaitSecs(1);
sca;
