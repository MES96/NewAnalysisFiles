%Practice for one file

%load chanlocs2



dname = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Study\Frequency';
entrainfiles = dir(fullfile(dname, '*entrain*'));

cd(dname);

av_area = [];

%entrain = load('NTIP_0003_UNC_seqA_epoched_entrain_cleaned_Freq.mat'); %entrain.f.data
%base = load('NTIP_0003_UNC_seqA_epoched_base_cleaned_Freq.mat'); % base.fdata
ProcessPath='Y:\Marie Shorrock\PROCESSED\'
mkdir Y:\Marie Shorrock\PROCESSED

for f= 1:length(entrainfiles)
%for f = 1:length(entrain)
    
    entrainname = entrainfiles(f).name;
    basename = strrep(entrainname,'entrain','base');
 
    entrain = load(entrainname); %entrain.f.data
    base = load(basename); % base.fdata
    
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

    
    save ([ProcessPath, entrainname], 'NTIP_0001_average')
end
%save NTIP_0003_UNC_seqA_entrainment_regions


% file locations is 'dname', the files will be NTIP followed by the
% participant number (0001, 0003, 0007, 0012, 0024-0032), followed by COM
% or UNC, then seqA-seqC, then epoched_base or epoched_entrain, then cleaned_Freq. The base
% one is so I can correct the entrainment data. The files end up looking
% something like NTIP_0001_COM_seqA_epoched_base_cleaned_Freq.mat

%At the moment it is saving the file for each participant (which is what I
%would want) and then tries to do 0003 and gets stuck. So if you can figure
%out how to get it to continue doing that, and how to get it to loop through and save the
%file as something different for each participant that would be great. 
%But I can't figure out how to get it to extract the file parts and then save it each time as a slightly different name.