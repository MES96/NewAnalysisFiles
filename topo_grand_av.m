freqs=[8:12];
for i = 3:7
    subplot(2,3,i)
    %topoplot(grand_av(:,i),chanlocs2,'maplimits','minmax');colorbar
    topoplot(grand_av(:,i),chanlocspilot,'maplimits',[0, 2]);colorbar
    title(num2str(freqs(i)))
end
%%
%single frequency plots- not 3x3 grids
%topoplot(grand_av(:,2),chanlocs2,'maplimits',[0, 3]);colorbar %7Hz power
%topoplot(grand_av(:,5),chanlocspilot,'maplimits',[0, 2]);colorbar %10Hz power
%topoplot(grand_av(:,5),chanlocspilot,'maplimits',[0, 10]);colorbar %10Hz power
topoplot(grand_av(:,4),chanlocs2,'maplimits',[1, 1.5]);colorbar %23Hz power