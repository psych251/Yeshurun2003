function shadedplot(data,NoS,varargin)
% shadedplot(data,NoS,varargin)
%   NoS      :: number of subject
%   varargin ::'alpha'     = 0.1 (default)
%              'Color'     = black
%              'LineWidth' = 2
%              'LineStyle' = '-',                ...
%              'xAxis'     = 1:end
if nargin < 2, NoS = max(size(data)); end
[mu,ci] = sem(data,'no',NoS);
options = struct('alpha',          0.1,                  ...   
                 'Color',          [0,0,0],            ...
                 'LineWidth',      2,                  ...
                 'LineStyle',      '-',                ...
                 'xAxis',          1:length(mu));
options = checkOptions(options,varargin{:});

%% area plotting
y = [mu-ci; ci*2]'; 
ha = area(options.xAxis, y,...
    'LineStyle','none');
alpha(options.alpha)
set(ha(1), 'FaceColor', 'none') % this makes the bottom area invisible
set(ha(2), 'FaceColor', options.Color) 
hold on;
plot(options.xAxis,mu,...
    'Color',options.Color,...
    'LineStyle',options.LineStyle,...
    'LineWidth',options.LineWidth)


% put the grid on top of the colored area
set(gca, 'Layer', 'top')
hold off;
grid off