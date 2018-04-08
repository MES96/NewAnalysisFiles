function S=baseline_extraction(S)
%% Separation of the recording into baseline, entrainment, and ERP prior to frequency analysis
% Once data has been made into separate files again for each condition,
% this will separate the recordings further into the three recordings to
% allow the data to be normalised to the first minute of the recording
% Specific to the auditory entrainment study (March 2018)
% GET FILE LIST

S.filepath = S.setpath;
S = getfilelist(S);

for f = 1:length(S.filelist)
    file = S.filelist{f};
    
    %Extract baseline
    EEG = pop_loadset('filename',file,'filepath',S.setpath);
    EEG = eeg_checkset( EEG );
    EEG = pop_selectevent( EEG, 'type',{'S  1'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    
    %Save new set
    sname = [C{1} '_' C{2} '_' C{3} '_SODD.set'];
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG,'filename',sname,'filepath',anapath);
    
    %Extract entrainment recording
    EEG = pop_loadset('filename',file,'filepath',S.setpath);
    EEG = eeg_checkset( EEG );
    EEG = pop_selectevent( EEG, 'type',{'S  3' 'S  4' 'S  5' 'S  6'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    
    %Save new set
    sname = [C{1} '_' C{2} '_' C{3} '_SODD.set'];
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG,'filename',sname,'filepath',anapath);
    
    %Extract ERP recording
    EEG = pop_loadset('filename',file,'filepath',S.setpath);
    EEG = eeg_checkset( EEG );
    EEG = pop_selectevent( EEG, 'type',{'S  3' 'S  4' 'S  5' 'S  6'},'deleteevents','on','deleteepochs','on','invertepochs','off');
    
    %Save new set
    sname = [C{1} '_' C{2} '_' C{3} '_SODD.set'];
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset(EEG,'filename',sname,'filepath',anapath);