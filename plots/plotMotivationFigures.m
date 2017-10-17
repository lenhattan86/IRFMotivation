addpath('func');
common_settings;
figIdx = 0;

yScale = 10;

fig_path = ['../../IRF/figs/'];

plots = [true true true true];

figureSize = [1 1 4/5 4/5].* figSizeOneCol;
legendSize = [1 1 4/5 1] .* legendSize;

% overheads:
% container & pod creating: 20 secs

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
  figure;
  yScale=100;
  % job ~ 27 secs
  % container&pod: 10 secs
  % Tensorflow initialization: 1.5 mins
%     gpus = [1 4 8 12 16]; avgCompTimes = [29661 12481 11304 11454 11551] - 90; % 90 is the overhead of creating pod & containers
    gpus = 1:16; 
    avgCompTimesVgg16 = [13470.2084558 4477.23197985 3121.00815487 2354.038589 1905.38305998 1649.93166399 1428.36598802 1256.65069079 1149.84947181 1016.70234394 945.18821907 891.494543076 841.729991913 789.562747955 787.856372118 725.062942028];
    avgCompTimesAlexnet= [779.599501848 256.972734928 190.229606152 153.816900015 118.416475058 98.0824620724 89.83385396 80.2840998173 75.8588907719 63.7092180252 62.4828259945 55.936978817 56.9669809341 53.1801769733 52.4265050888 52.695677042]*10;
%     avgCompTimesInception3 = [13470.2084558 4477.23197985 3121.00815487 2354.038589 1905.38305998 1649.93166399 1428.36598802 1256.65069079 1149.84947181 1016.70234394 945.18821907 891.494543076 841.729991913 789.562747955 787.856372118 725.062942028];
    avgCompTimesResnet50 = [57944.2923779 17944.2923779 13065.8001668 9470.906322 8367.33240294 6797.86065102 6476.68119597 5376.67561388 5336.14500403 4765.05725598 4234.50606394 3936.25947809 4063.55099392 4028.15193915 3784.55199099 3744.38619113];
    
%   title([method '- CPUs'],'fontsize',fontLegend);      

    hPlot = plot(gpus,avgCompTimesVgg16(1)./ avgCompTimesVgg16, lineWithCircles,'linewidth',LineWidth);      
    hold on; 
    plot(gpus, avgCompTimesAlexnet(1)./avgCompTimesAlexnet, lineWithCircles,'linewidth',LineWidth);     
%     hold on;
%     plot(gpus, avgCompTimesInception3, lineWithCircles,'linewidth',LineWidth);      
    hold on;
    plot(gpus, avgCompTimesResnet50(1)./avgCompTimesResnet50, lineWithCircles,'linewidth',LineWidth);      
    
    legend({'VGG16', 'Alexnet', 'Resnet50', 'Inception3'});
%     ylim([0 ceil(max(avgCompTimes)/yScale)*yScale]);
    xlim([0 max(gpus)]);
    
    xlabel(strCpuCores);
    ylabel(strCpuSpeedup);
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
    % Alexnet
    % - batch size = ? from Adhita
    %avgCompTimes = [5.51503396034 5.26602911949 2.25541186333];
    % gpus = [0.1 0.5 1.0]; % 0.1 : out of memory
    % - batch size = 8 => compl. time stays constant (1.5 seconds)
    % - batch size = 128
%     gpus = [0.2 0.4 1.0]; avgCompTimes = [5.51503396034 5.26602911949 6.01745986938];
    
        
    % VGG16
    avgCompTimesVgg16 = [689 481 348 151]; total = 100; gpus = [total/4 total/3 total/2 total];  % VGG16, batch size = 16
%     avgCompTimes = [9.9 9.77 9.98 10.036];  gpus = [0.3 0.5 0.8 1.0]; % 0.1 : out of memory
    
    avgCompTimesAlexnet = [101 98 52 20.090433836 ]; total = 100; gpus = [total/4 total/3 total/2 total]; % Alexnet, batch size = 16
    avgCompTimesresnet50 = [579.497409821 358.756479979 278.96560812 129.425158024 ]; total = 100; gpus = [total/4 total/3 total/2 total];  % Alexnet, batch size = 16
    avgCompTimesInception3 = [800 639.001741886 437.349575043 200.931766987 ]; total = 100; gpus = [total/4 total/3 total/2 total];
    figure;
    yScale = 1;
    plot(gpus, avgCompTimesVgg16(length(avgCompTimesVgg16))./avgCompTimesVgg16, lineWithCircles,'linewidth',LineWidth);       
    hold on; 
    plot(gpus, avgCompTimesAlexnet(length(avgCompTimesAlexnet))./avgCompTimesAlexnet, lineWithCircles,'linewidth',LineWidth);    
    hold on; 
    plot(gpus, avgCompTimesresnet50(length(avgCompTimesresnet50))./avgCompTimesresnet50, lineWithCircles,'linewidth',LineWidth); 
    hold on; 
    plot(gpus, avgCompTimesInception3(length(avgCompTimesInception3))./avgCompTimesInception3, lineWithCircles,'linewidth',LineWidth); 
    
    legend({'VGG16', 'Alexnet', 'Resnet50', 'Inception3'});
    %ylim([0 ceil(max(avgCompTimes)/yScale)*yScale]);
    xlim([0 max(gpus)]);       
    
    xlabel(strGpuShare);
    ylabel(strGpuSpeedup);
    set (gcf, 'Units', 'Inches', 'Position', figSizeOneCol, 'PaperUnits', 'inches', 'PaperPosition', figSizeOneCol);      
    if is_printed   
      figIdx=figIdx +1;
      fileNames{figIdx} = ['gpuMemoryFraction'];        
      epsFile = [ LOCAL_FIG fileNames{figIdx} '.eps'];
      print ('-depsc', epsFile);
    end
end


if plots(4)
    % VGG16: batch size = 16
    avgCompTimes = [15.05 33.04 48.06 59.45]; numJobs = [1 2 3 4]; % 0.1 : out of memory
    
    figure;
%   title([method '- CPUs'],'fontsize',fontLegend);      
    yScale = 1;
    hPlot = plot(numJobs, avgCompTimes, lineWithCircles,'linewidth',LineWidth);       
    ylim([0 ceil(max(avgCompTimes)/yScale)*yScale]);
    xlim([0 max(numJobs)]);       
%     title('Sharing GPU memory 20%');
    xlabel('Number of jobs/GPU');
    ylabel(strComplTime);
    set (gcf, 'Units', 'Inches', 'Position', figSizeOneCol, 'PaperUnits', 'inches', 'PaperPosition', figSizeOneCol);      
    if is_printed   
      figIdx=figIdx +1;
      fileNames{figIdx} = ['jobsPerGPU'];        
      epsFile = [ LOCAL_FIG fileNames{figIdx} '.eps'];
      print ('-depsc', epsFile);
    end
end

%%

fileNames

return
%%
for i=1:length(fileNames)
    fileName = fileNames{i};
    epsFile = [ LOCAL_FIG fileName '.eps'];
    pdfFile = [ fig_path fileName  '.pdf']    
    cmd = sprintf(PS_CMD_FORMAT, epsFile, pdfFile);
    status = system(cmd);
end