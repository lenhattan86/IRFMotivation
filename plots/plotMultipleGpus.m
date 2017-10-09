addpath('func');
common_settings;
figIdx = 0;

yScale = 10;

fig_path = ['../../IRF/figs/'];

plots = [true true true];

figureSize = [1 1 4/5 4/5].* figSizeOneCol;
legendSize = [1 1 4/5 1] .* legendSize;

% overheads:
% container & pod creating: 20 secs
% c

%%
if plots(1)       
  % job ~ 27 secs
  % container&pod: 10 secs
  % Tensorflow initialization: 1.5 mins
    avgCompTimes = [7825 3912 2608 1956]/60;
    gpus = [2 4 6 8];
    figure;
%   title([method '- CPUs'],'fontsize',fontLegend);      

    hPlot = plot(gpus, avgCompTimes, lineWithCircles,'linewidth',LineWidth);       
    ylim([0 ceil(max(avgCompTimes)/yScale)*yScale]);
    xlim([0 max(gpus)]);       
    
    xlabel(strGpus);
    ylabel(strMakepan);
    set (gcf, 'Units', 'Inches', 'Position', figSizeOneCol, 'PaperUnits', 'inches', 'PaperPosition', figSizeOneCol);      
    if is_printed   
      figIdx=figIdx +1;
      fileNames{figIdx} = ['multiGpus'];        
      epsFile = [ LOCAL_FIG fileNames{figIdx} '.eps'];
      print ('-depsc', epsFile);
    end
end

if plots(2)       
  yScale=100;
  % job ~ 27 secs
  % container&pod: 10 secs
  % Tensorflow initialization: 1.5 mins
    avgCompTimes = [29661 12481 11304 11454 11551] - 90; % 90 is the overhead of creating pod & containers
    gpus = [1 4 8 12 16];
    figure;
%   title([method '- CPUs'],'fontsize',fontLegend);      

    hPlot = plot(gpus, avgCompTimes, lineWithCircles,'linewidth',LineWidth);       
    ylim([0 ceil(max(avgCompTimes)/yScale)*yScale]);
    xlim([0 max(gpus)]);       
    
    xlabel(strCpuCores);
    ylabel(strComplTime);
    set (gcf, 'Units', 'Inches', 'Position', figSizeOneCol, 'PaperUnits', 'inches', 'PaperPosition', figSizeOneCol);      
    if is_printed   
      figIdx=figIdx +1;
      fileNames{figIdx} = ['cpuCores'];        
      epsFile = [ LOCAL_FIG fileNames{figIdx} '.eps'];
      print ('-depsc', epsFile);
    end
end

if plots(3)       
  % job ~ 27 secs
  % container&pod: 10 secs
  % Tensorflow initialization: 1.5 mins
    %avgCompTimes = [5.51503396034 5.26602911949 2.25541186333];
    % gpus = [0.1 0.5 1.0]; % 0.1 : out of memory
    avgCompTimes = [27.0777139664 27.3565981388 27.3496148586 27.34]; 
    gpus = [0.3 0.5 0.8 1.0]; % 0.1 : out of memory
    figure;
%   title([method '- CPUs'],'fontsize',fontLegend);      
    yScale = 1;
    hPlot = plot(gpus, avgCompTimes, lineWithCircles,'linewidth',LineWidth);       
    ylim([0 ceil(max(avgCompTimes)/yScale)*yScale]);
    xlim([0 max(gpus)]);       
    
    xlabel(strGpuMem);
    ylabel(strComplTime);
    set (gcf, 'Units', 'Inches', 'Position', figSizeOneCol, 'PaperUnits', 'inches', 'PaperPosition', figSizeOneCol);      
    if is_printed   
      figIdx=figIdx +1;
      fileNames{figIdx} = ['gpuMemoryFraction'];        
      epsFile = [ LOCAL_FIG fileNames{figIdx} '.eps'];
      print ('-depsc', epsFile);
    end
end

%%

fileNames
%%
return;
%%

for i=1:length(fileNames)
    fileName = fileNames{i};
    epsFile = [ LOCAL_FIG fileName '.eps'];
    pdfFile = [ fig_path fileName  '.pdf']    
    cmd = sprintf(PS_CMD_FORMAT, epsFile, pdfFile);
    status = system(cmd);
end