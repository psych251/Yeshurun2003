function pixel = deg2pixel(deg,varargin)
% convert visual angle into monitor's pixel

%% argument check
opt = struct('monitorSize',   [40.6,30.4],                  ...    % horizontal 40.6cm, vertical 30.4cm
             'eyeDistance',   60);                                 % eye distance 60cm
opt = checkOptions(opt,varargin{:});

%%
env = get(0, 'screensize');
ratio = sqrt(sum(env(3:4).^2))/sqrt(sum(opt.monitorSize.^2));
pixel = opt.eyeDistance*tand(deg).*ratio;

end