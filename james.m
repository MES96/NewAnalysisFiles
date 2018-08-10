%% delete me
tempStruct = fdata;
cfg = [];

col = 5; % column
A = grand_av(:,col);
tempStruct.powspctrm = A;

ft_topoplotER(cfg, tempStruct)
