clear all
dbstop if error % optional instruction to stop at a breakpoint if there is an error - useful for debugging

%% 1. ADD TOOLBOXES TO MATLAB PATH
%eeglab_path = 'C:\EEGLABtraining2018\eeglab14_1_1b'; % path to eeglab toolbox
%fieldtrip_path = 'C:\EEGLABtraining2018\fieldtrip-20180212'; % path to fieldtrip toolbox
batchfun_path = 'C:\EEGLABtraining2018\EEGLABworkshops2018';
support_path = 'P:\GitHub\NewAnalysisFiles\Functions'

%addpath(genpath(eeglab_path));
%addpath(fieldtrip_path); ft_defaults;
addpath(genpath(batchfun_path));
addpath(genpath(support_path));

%% 2. FOLDER AND FILENAME DEFINITIONS

% FILE NAMING
% Name the input files as <study name>_<participant ID>_<sessions name>_<block name>_<condition name>
% For example: EEGstudy_P1_S1_B1_C1.set
% Any of the elements can be left out. But all must be separated by underscores.

clear S 
S.rawpath = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Pilot 2\Raw'; % unprocessed data in original format
S.setpath = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Pilot 2\Sets and preprocessed'; % folder to save processed .set data
S.freqpath = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Pilot 2\Frequency'; % folder to save processed .set data
S.erppath = 'Y:\Marie Shorrock\NTIP\Auditory Entrainment Pilot 2\ERP'; % folder to save processed .set data
S.fnameparts = {'study','subject','block', 'cond'}; % parts of the input filename separated by underscores, e.g.: {'study','subject','session','block','cond'};
S.subjects = {'P4'}; % either a single subject, or leave blank to process all subjects in folder
S.sessions = {};
S.blocks = {}; % blocks to load (each a separate file) - empty m+eans all of them, or not defined
S.conds = {'1HC.', '1HO.', '1LC.', '1LO.', '10HC.', '10HO.', '10LC.', '10LO.'}; % eventitions to load (each a separate file) - empty means all of them, or not defined
S.datfile = '\\nask.man.ac.uk\home$\GitHub\EEGLABworkshops2018-master\Participant_data.xlsx'; % .xlsx file to group participants; contains columns named 'Subject', 'Group', 'Include' and any covariates of interest
save(fullfile(S.setpath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 1. DATA IMPORT
% This identifies files for conversion to EEGLAB format for a
% specific study and sets some parameters for the conversion. It calls the generic function
% "import_eeglab" to do the actual conversion.

% SETTINGS
load(fullfile(S.setpath,'S'))
S.loadext = 'vhdr'; % file extension of input data: supports 'vhdr' (Brainvision), 'cnt' (Neuroscan), 'mff' (EGI - requires mffimport2.0 toolbox)
S.saveprefix = ''; % prefix to add to output file, if needed
S.savesuffix = ''; % suffix to add to output file, if needed
S.chan.excl = [22 32]; % exclude channels, or leave empty as []
S.chan.addloc = 'C:\Work\eeglab14_1_1b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp'; % add channel locations from this path; or leave as ''
% RUN
S=eeglab_import(S);
save(fullfile(S.setpath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 2. PREPROCESSING
% SET PREPROCESSING OPTIONS
load(fullfile(S.setpath,'S'))
S.loadext = 'set';
S.cont.timewin = {[],[],[],[]}; % timewindow (s) of data to analyse; one per S.conds. Blank = analyse all.
S.downsample = 125;
S.chan.addloc = 'C:\Work\eeglab14_1_1b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp'; % add channel locations from this path; or leave as ''
S.chan.interp = [];
S.chan.reref = 2;
S.filter.incl = [0.1 100]; % FILTER - INCLUSIVE
S.filter.notch = {[45 55],[95 105]};
S.epoch.markers = {'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11'};
S.epoch.addmarker = 1; % set to 1 to add markers if the above are not present: will use the first marker value
S.epoch.timewin = [-0.2 0.3]; % peri-marker time window
S.epoch.detrend = 0;
S.epoch.rmbase = 0;
S.combinefiles = 1;
S.FTrej = {[0 5]}; % high freq to identify noise, low freq to identify eye movement
S.ICA = 1;

% RUN
S=eeglab_preprocess_pilots(S)
save(fullfile(S.setpath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 3. PREPROCESSING AFTER ICA
% Only run this part if you have already manually selected ICA components for removal
% path to ICA processed data
dbstop if error
load(fullfile(S.setpath,'S'))
S.loadext = 'combined_ICA.set'; %once ICA is completed the file is saved as 'ICA.set'- is that the file we reject components in (and therefore the one that should be loaded here)
S.subjects= {'P4'}; S.sessions={};S.blocks={};S.conds={};
S.ICAremove = 1; % remove ICA components (0 if already removed from data, 1 if selected but not removed)
S.detrend = 0;
S.rmbase = 0;
S.basewin = [-0.2 0]; % baseline window
S.FTrej = {[]};
S.reref = 1;
S.epoch.markers = {'S  1' 'S  2' 'S  3' 'S  4' 'S  5' 'S  6' 'S  7' 'S  8' 'S  9' 'S 10' 'S 11'};
S.separatefiles = 1; % separates out into original file prior to combining
S.separate = {[]}; % index of markers to separate into files
S.separate_suffix = {}; % index of markers to separate into files
% RUN
S=eeglab_preprocess_afterICA_pilots(S)
save(fullfile(S.setpath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 4. FREQUENCY ANALYSIS
% MODS: NEEDS OPTION TO SAVE INDIVIDUAL SUBJECTS DATAFILES

load(fullfile(S.setpath,'S'))
% data
S.loadext = 'cleaned.set';% generic file suffix
S.sessions = {};
S.blocks = {}; % blocks to load (each a separate file) - empty means all of them, or not defined
S.conds = {'1HC', '1HO', '1LC', '1LO', '10HC', '10HO', '10LC', '10LO'}; % eventitions to load (each a separate file) - empty means all of them, or not defined
% general settings
S.basewin = [-0.2 0]; % baseline window
S.rmbase = 1; % remove baseline prior to frequency/ERP
S.markers = {'S  1','S  2','S  3','S  4','S  5','S  6', 'S  7', 'S  8', 'S  9', 'S 10', 'S 11'}; % marker types to analyse
S.combinemarkers = 0; %include all events in a single eventition.
% analysis type
S.analysistype = 'Freq'; %'Freq','TF','Coh','ERP'
% freq analysis settings
S.freqtype = 'both'; % induced or both
S.baselinetype = 'relative'; % for TF analysis only: 'absolute', 'relative', 'relchange', 'normchange'
S.freqsrange = [6:1:14]; % select frequency range and resolution (if freq analysis). 1D array produces all freqs enteredl 2D array uses ranges, e.g. [0 4; 4 8; 8 13; 13 30; 30 40];
S.mov_avg_trials = 100; % N trials: average EEG power over trials using a moving average window
S.mov_avg_trials_step = 100;
S.bootrep = 50;% Bootstraps repetitions (for coherence analysis only)
S.ncycles=3; % number of cycles for wavelet analysis (may crash if too big)
% ERP settings
S.CSD.apply=1; % Apply CSD (leave as 0 unless you know what you are doing!)
S.CSD.montage = 'C:\Data\NTIP\CSDmontage_64.mat';
S=erp_freq_analysis_pilots(S)
save(fullfile(S.setpath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable

%% 4. PLOT FREQUENCY
close all
load(fullfile(S.setpath,'S'))
S.sessions = {};
S.blocks = {}; % blocks to load (each a separate file) - empty means all of them, or not defined
%S.conds = {'_1HC_', '_1HO_', '_1LC_', '_1LO_', '_10HC_', '_10HO_', '_10LC_', '_10LO_'}; % eventitions to load (each a separate file) - empty means all of them, or not defined
S.conds = {'1HC', '1HO', '1LC', '1LO', '10HC', '10HO', '10LC', '10LO'};
S.freqselect = 10;
S.blockselect = 1;
S.eventselect = 1:11;%[1:9];
S.exclchan = [];
%block_reorder = 1:8; % no reordering
%participant_eventorder = [1 1]; % normal or reversed ordering. One value per subject.
% data operation 1
S.op(1).type = 'event';
S.op(1).operation = 'normchange' %'subtract', 'relative', 'relchange', 'normchange' or 'db'
S.op(1).grouping = [5 1; 6 2; 7 3; 8 4]; % e.g. for subtraction or dividing
% data operation 2
S.op(2).type = 'event';
S.op(2).operation = 'subtract' %'subtract', 'relative', 'relchange', 'normchange' or 'db'
S.op(2).grouping = [1 2; 3 4; 1 3; 2 4]; % e.g. for subtraction or dividing
% data operation 3
%S.op(3).type = 'freq';
%S.op(3).operation = 'subtract'
%S.op(3).grouping = S.freqsrange; % index of frequencies to use for comparison (will exclude the selected freq)
% RUN
S=erp_freq_analysis_plot_pilots(S)
save(fullfile(S.setpath,'S'),'S'); % saves 'S' - will be overwritten each time the script is run, so is just a temporary variable