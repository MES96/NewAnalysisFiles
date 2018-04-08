%Practice for one file

load chanlocs2

dname = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Study\Frequency';
%entrainfiles = dir(fullfile(dname, '*entrain*'));
%basefiles = dir(fullfile(dname, '*base*'));
cd(dname);

av_area = [];
av_area_ent = [];

entrain = load('NTIP_0003_UNC_seqA_epoched_entrain_cleaned_Freq.mat'); %entrain.f.data
base = load('NTIP_0003_UNC_seqA_epoched_base_cleaned_Freq.mat'); % base.fdata

for f = 1:length(entrain)

    av_e = squeeze(mean(entrain.fdata.powspctrm,1)); %avg powspctrm entrain before correction
    av_b = squeeze(mean(base.fdata.powspctrm,1)); %avg powspctrm base 
    av = av_e./av_b; %divides entrainment powerspectrum by baseline as a correction


    area = [chanlocs2.area];

    uArea = unique(area); %sorts the areas and gets rid of repeats.
    nArea = length(uArea); %find the number of areas

    for r = 1:nArea
           av_area(f,r,:) = mean(av(area,uArea(r),:)); %creates a 3D array but we can't copy this into SPSS for stats, therefore it needs to be reduced to be 2D array ==
    end

    av_area = permute(av_area,[1 3 2]); %this swaps the second and third one
    av_area = reshape(av_area,[],size(av_area,2)*size(av_area,3)); % columns: freq, regions

    
    %save NTIP_0003_UNC_seqA_entrainment_regions
end
save NTIP_0003_UNC_seqA_entrainment_regions