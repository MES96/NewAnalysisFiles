%Region/area selection based on chanlocs2 file. Saves everything at the end
%under the final participant, UNC, SeqD.
load chanlocs2

dname = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Pilot 2\Frequency';
auditoryfiles = dir(fullfile(dname, '*epoched*'));
cd(dname);

av_area_e = [];
grand_av_e = [];


for f= 1:length(auditoryfiles)
    
    auditoryname{f,1} = auditoryfiles(f).name; % CAB: made entrainname a cell array of file names, which can be saved at the end.
     
    entrain = load(auditoryname{f}); %entrain.f.data
        
    av_e = squeeze(mean(entrain.fdata.powspctrm,1)); %avg powspctrm entrain before correction
    grand_av_e = cat(3,grand_av_e,av_e); % CAB: added grand average
    
    area = [chanlocs2.area];

    uArea = unique(area); %sorts the areas and gets rid of repeats.
    nArea = length(uArea); %find the number of areas

    for r = 1:nArea
           av_area_e(f,r,1:size(av_e,2)) = squeeze(mean(av_e(area==uArea(r),:),1))'; % CAB: updated
    end

end

% CAB: This part needs to be outside of the loop to save all as one file:
av_area_e = permute(av_area_e,[1 3 2]); %this swaps the second and third one-change if wrong
av_area_e = reshape(av_area_e,[],size(av_area_e,2)*size(av_area_e,3)); % columns: freq, regions
av_cell = horzcat(auditoryname,num2cell(av_area_e));
grand_av_e = mean(grand_av_e,3); % CAB: added grand average
save('averages.mat','av_area_e','auditoryname','av_cell','grand_av_e'); % CAB: added av_cell - filenames and numbers all in one cell array
