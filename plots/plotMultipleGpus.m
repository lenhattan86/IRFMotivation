addpath('func');
common_settings;
figIdx = 0;

yScale = 10;

%fig_path = ['../../IRF/fig/'];

plots = [true true];

figureSize = [1 1 4/5 4/5].* figSizeOneCol;
legendSize = [1 1 4/5 1] .* legendSize;

%%
if plots(1)       
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