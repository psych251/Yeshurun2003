function [out] = getKeyboardNo
% check keyboard number automatically
dev = PsychHID('devices');
ndev = length(dev);
keyboard_dev = [];
for i = 1:ndev
    if strcmpi(dev(i).usageName(max(1,end-8+1):end),'keyboard'), keyboard_dev = [keyboard_dev,i]; end
end

outGiven = 0;
while ~outGiven,
    for i = keyboard_dev
        fprintf('hold spacebar...');
        WaitSecs(1);
        fprintf('checking for device no.%d...',i)
        WaitSecs(0.2);
        [~,key,~] = KbWait(i,[],GetSecs+1);
        if sum(key)==0,
            fprintf('no input given!\n')
        else
            fprintf('<<<<<<<<<<<<<<<<<<<<<<<\n')
            out = i;
            outGiven = 1;
            break
        end
    end
end
end
