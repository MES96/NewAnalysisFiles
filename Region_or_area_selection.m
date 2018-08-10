%% Region/area selection 
%Selection based on chanlocs2 file. Chanlocs2 has two additional
%columns added called region (9 groups: anterior -> posterior AND left -> right) 
%or area (3 groups: anterior, central, posterior)

load chanlocs2

dname = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Study\Frequency';
entrainfiles = dir(fullfile(dname, '*entrain_*'));

cd(dname);

av_area = [];
grand_av=[];
grand_av_e = [];
grand_av_b = [];

for f= 1:length(entrainfiles)
    
    entrainname{f,1} = entrainfiles(f).name; % makes entrainname a cell array of file names, which can be saved at the end.
    basename = strrep(entrainname{f},'entrain','base');
 
    entrain = load(entrainname{f}); %entrain.f.data
    base = load(basename); % base.fdata
    
    av_e = squeeze(mean(entrain.fdata.powspctrm,1)); %avg powspctrm entrain before correction
    av_b = squeeze(mean(base.fdata.powspctrm,1)); %avg powspctrm base 
    av = av_e./av_b; %divides entrainment powerspectrum by baseline as a correction
    grand_av_e = cat(3,grand_av_e,av_e); 
    grand_av_b = cat(3,grand_av_b,av_b); 
    grand_av = cat(3,grand_av,av); % avg of all participants: can be used to plot avg topoplot 

    area = [chanlocs2.area]; %separates by area
    %area = [chanlocs2.reg]; %separates by region
    
    uArea = unique(area); %sorts the areas and gets rid of repeats.
    nArea = length(uArea); %find the number of areas

    for r = 1:nArea
           av_area(f,r,1:size(av,2)) = squeeze(mean(av(area==uArea(r),:),1))'; 
    end

end

% SAVE (this part needs to be outside of the loop to save all as one file)
%av_area = permute(av_area,[1 3 2]); % Produces output which is region 1, freq 1; region 1, freq2 etc. Comment out if you want freq1, region 1; freq1, region 2 etc.
av_area = reshape(av_area,[],size(av_area,2)*size(av_area,3)); % columns: freq, regions
av_cell = horzcat(entrainname,num2cell(av_area));
grand_av_e = mean(grand_av_e,3); 
grand_av_b = mean(grand_av_b,3); 
grand_av = mean(grand_av,3); 
save('averages.mat','av_area','entrainname','av_cell','grand_av_e','grand_av_b','grand_av'); % save filenames and numbers all in one cell array

%% Additional bit- not integrated
% Note to Chris: the above will save all conditions and subjects in one grand average file. 
% This is the additional loop bit you started that saves the conditions separately.

for i = 1:8
    grand_av_e = mean(grand_av_e(entrainname(:,2)== i),3); 
    grand_av_b = mean(grand_av_b,3); 
    grand_av = mean(grand_av,3); 
    save(['averages' num2str(i) '.mat'],'grand_av_e','grand_av_b','grand_av'); % save filenames and numbers all in one cell array

end