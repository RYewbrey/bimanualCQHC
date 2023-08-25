function bimanualCQHC_ana(which, varargin) %wrapper code
% bimanualCQHC_ana(which, varargin)
% Imports raw data, saves relevant data in a structure, plots individual and
% group data, and does basic stats
% Inputs:
%   which - string indicating which switch analysis case to run
%
% ---------------------------------------------------
% Foundation written by K. Kornysheva, September 2021
% Adjusted and expanded by R. Yewbrey, 2022-2023

% Paths to toolboxes and experimental code
%
%%%% CHBH RY PC
% addpath(genpath('Z:/toolboxes/userfun'));%Joern Diedrichsen's util toolbox
% addpath(genpath('Z:/toolboxes/RainCloudPlots-master')); %raincloud plot toolbox
% addpath(genpath('C:/Users/yewbreyr/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC/CQHC/matlab'));%experimental code
% addpath(genpath('Z:/toolboxes/Violinplot')); %violin plot toolbox
% 
%%%% Home RY PC
% addpath(genpath('E:/toolboxes/userfun'));%Joern Diedrichsen's util toolbox
% addpath(genpath('E:/toolboxes/RainCloudPlots-master')); %raincloud plot toolbox
% addpath(genpath('C:/Users/bugsy/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC/CQHC/matlab'));%experimental code
% addpath(genpath('E:/toolboxes/Violinplot')); %violin plot toolbox

% Base Directory
%
%%%% CHBH RY PC
% baseDir= 'C:/Users/yewbreyr/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC';
%
%%%% Home RY PC
baseDir= 'C:/Users/bugsy/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC';

%Directory where psychoPy saves to
rawDir= [baseDir '/bimanualCQ_HC2/data'];
rawDirUoB = [baseDir '/bimanualCQ_HC2brum/data'];

%Directory where processed data should be saved
saveDir= [baseDir '/CQHC/data'];

%General variables that change analyses
errorThreshold = 20; %error threshold for participant inclusion, default 20

%File name of demographics questionnaire (last day)
demographicsFilenameBangor = 'CQ_HC Day 3 Questionnaire_14 June 2023_14.42.xlsx'; %update filename accordingly
demographicsFilenameBrum   = 'CQ_HC Day 3 Questionnaire – brum_14 June 2023_14.38.xlsx';

%Analysis Cases - switch as function input
switch which
    case 'loadData'         %import task data files from .csv to .mat
        cd(rawDir);
        A=[]; %structure across subj
        S=[]; %structure across days
        
        rawFileName = bimanualCQHC_prepFileNames(rawDir, rawDirUoB); %function to define filenames (edit accordingly)
        
        for subj=1:size(rawFileName,1) %subj loop
            for day=1:size(rawFileName,2) %day loop
                disp([rawFileName{subj, day} ' in progress..']);
                
                D = bimanualCQHC_importFile(rawFileName{subj,day}); % imports data from raw, puts it into a structure array
                
                D.subjN = ones(length(D.RT),1) * subj; %subjN changes if you change the number of participants loaded
                disp([rawFileName{subj, day} 'done.']);
                S=addstruct(S,D); %within subj
                clear D;
            end%for day
            A=addstruct(A,S); %within subj
            S=[];
        end%for subj
        
        %save
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
        
        bimanualCQHC_ana('outliers') %run outliers case to view participants to exclude and add A.outlierError variable
    case 'outliers'         %identify outlier performance and add exclusion variable
        [A, ~] = CQHC_initCase(saveDir);
        
        %%%Plot number of erroneous presses (not trials) for each participant
        M=tapply(A,{'subjN'},{A.errorTrial,'sum','name','pressError'},'subset',A.day==3&A.trialType==3&A.TN>21&A.taskBug==0);
        
        figure;
        scatterplot(M.subjN,M.pressError,...
            'leg','auto');
        xlabel('Participant')
        ylabel('Number of erroneous presses')
        % ---------------------------------------------------------------- %
        
        
        %%%Percentage of press errors for entire sequence trials
        nPressesTotal = length(A.RT(A.subjN == 1 & A.day == 3 & A.trialType==3&A.TN>21&A.taskBug==0)) * 4; %total presses per subj
        M.percentage = (M.pressError / nPressesTotal) * 100; %convert n errors into percent
        
        figure;
        scatterplot(M.subjN,M.percentage,...
            'leg','fill');
        ylabel('Erroneous presses (%)');
        xlabel('Participant')
        drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        % ---------------------------------------------------------------- %
        
        
        %%%Percentage of whole-trial errors
        T=tapply(A,{'subjN'},{A.errorTrial(:,1),'sum','name','errorTrialSum'},  'subset',A.day==3&A.trialType==3&A.TN>21&A.taskBug==0);
        Z=tapply(A,{'subjN'},{A.errorTrial(:,1),'length','name','nTrialsTotal'},'subset',A.day==3&A.trialType==3&A.TN>21&A.taskBug==0);
        
        T.percentage = (T.errorTrialSum ./ Z.nTrialsTotal) * 100;
        
        figure;
        scatterplot(T.subjN,T.percentage,...
            'leg','auto');
        xlabel('Participant')
        ylabel('Percentage of erroneous trials')
        ylim([-2, 102])
        drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        % ---------------------------------------------------------------- %
        
        
        %%%Identify participants with >20% error rate and mark for exclusion
        %%%in later cases
        A.outlierError = zeros(length(A.RT),1);
        highError      = T.subjN(T.percentage > errorThreshold);
        lowError       = T.subjN(T.percentage < errorThreshold);
        A.outlierError(ismember(A.subjN, highError)) = 1;
        
        totSubj       = length(highError) + length(lowError);
        percHighError = (length(highError) / totSubj) * 100;
        
        title(['Good participants: ' num2str(length(lowError)) ', bad participants: ' num2str(length(highError)) ', exclusion percentage: ' num2str(percHighError) '%'])
        
        
        %%%Identify participants who actually tried! Even if some have a
        %%%high error rate, we want to take them into account when we look
        %%%at demographics. Produces the A.tried variable, 1 when they 
        %%%should be included
        A.include       = ~A.outlierError; %auto include those who performed well
        solidCutoff     = 50;  %final cut off for % error threshold. All between errorThreshold & solidCutoff must be assessed by hand
        minValidTrials  = 100; %some trials bugged and had ~4 target presses. Here we select the minimum number of valid trials (max 120)
        
        %Identify by hand which participants had high error rates but you
        %think still tried (didn't just press random keys)
        Y=tapply(A,{'subjID'},{A.errorTrial(:,1),'sum','name','errorTrialSum'},'subset',A.day==3&A.trialType==3&A.TN>21&A.taskBug==0);
        Y.percentage = (Y.errorTrialSum ./ Z.nTrialsTotal) * 100;
        YhighError   = Y.subjID(Y.percentage > errorThreshold);
        highErrorIDs = [YhighError, Y.percentage(ismember(Y.subjID, YhighError))]; %left column IDs, right column error percentages
        highErrorIDs = sortrows(highErrorIDs, 2); %sort by error rate
        
        %Visualisation variables (use breakpoints to investigate
        %performance)
        highErrorIDVector = highErrorIDs(highErrorIDs(:,2) < solidCutoff, :); %Only IDs that are below solidCutoff
        lowErrorIDVector  = Y.subjID(Y.percentage < errorThreshold);
        
        %Extract presses of high error participants that are below 
        %solidCutoff for visual analysis
        for i=1:length(highErrorIDVector)
            responseVisual{i} = A.bimanResponse(A.subjID == highErrorIDVector(i,1) & A.day==3&A.trialType==3&A.TN>21&A.taskBug==0, :);
            pressVisual   {i} = A.bimanPress   (A.subjID == highErrorIDVector(i,1) & A.day==3&A.trialType==3&A.TN>21&A.taskBug==0, :);
        end
        
        buggyTrialIDs = Y.subjID(Z.nTrialsTotal < minValidTrials); %participants with lots of buggy trials
        
        %Check the presses here, and assign participants you want to keep
        %to below vector. Opening responseVisual and pressVisual side by
        %side in variable viewer is a good way to assess.
        keepParticipants = [... %INCLUDE
            
            ];
        
        excludeParticipants = [... %EXCLUDE (e.g. when too many buggy trials) 
            93826 ... %co-presses in left hand trials (pinky) and some fractal confusion
            93640, ... %some confusion over presses and fractals, but tried %%%USED TO BE INCLUDED%%%
            93685, ... %some fractal confusion %%%USED TO BE INCLUDED%%%
            100789 ... %too many buggy trials
            27517 ...  %lots of fractal confusion and got right sequence wrong a lot
            93121 ...  %too much fractal confusion - didn't understand task?
            27495 ...  %lots of fractal confusion
            93175 ...  %fractal confusion
            97312 ...  %fractal confusion, some incorrect trials
            97015 ...  %low error rate, but lots of buggy trials
            96985 ...  %as above
            93997 ...  %too many buggy trials
            ];
        
        A.include(ismember(A.subjID, keepParticipants))    = 1; %include participant IDs that match those in the vector
        A.include(ismember(A.subjID, excludeParticipants)) = 0; %exclude participant IDs that match those in the vector
        %use this variable ^ to filter subsequent analyses
        
        
        %%%Error in probe trials, split by probe position - BEFORE
        %%%production trial outlier removal
        P                = tapply(A,{'subjN','probeTargetPos'},{A.errorTrial(:,1),'sum','name','errorTrialSum'},'subset',A.day==3&A.trialType==2&A.TN>21);%n probe errors
        PLengths         = tapply(A,{'subjN','probeTargetPos'},{A.errorTrial(:,1),'length','name','nProbeTrials'},'subset',A.day==3&A.trialType==2&A.TN>21);%n probe trials
        P.nProbeTrials   = PLengths.nProbeTrials;
        P.errorTrialPerc = (P.errorTrialSum ./ P.nProbeTrials) * 100;
        
        figure;
        myboxplot(P.probeTargetPos,P.errorTrialPerc,...
            'leg','auto');
        xlabel('Probe position')
        ylabel('Percentage of erroneous trials')
        ylim([0 105])
        %drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        title('Before production trial outlier removal')
        % ---------------------------------------------------------------- %
        
        
        %%%Error in probe trials, split by probe position - AFTER
        %%%production trial outlier removal
        R                = tapply(A,{'subjN','probeTargetPos'},{A.errorTrial(:,1),'sum','name','errorTrialSum'},'subset',A.day==3&A.trialType==2&A.TN>21&A.include==1);%n probe errors
        RLengths         = tapply(A,{'subjN','probeTargetPos'},{A.errorTrial(:,1),'length','name','nProbeTrials'},'subset',A.day==3&A.trialType==2&A.TN>21&A.include==1);%n probe trials
        R.nProbeTrials   = RLengths.nProbeTrials;
        R.errorTrialPerc = (R.errorTrialSum ./ R.nProbeTrials) * 100;
        
        figure;
        myboxplot(R.probeTargetPos,R.errorTrialPerc,...
            'leg','auto');
        xlabel('Probe position')
        ylabel('Percentage of erroneous trials')
        ylim([0 105])
        %drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        title('After production trial outlier removal')
        % ---------------------------------------------------------------- %
        
        
        %%%Percentage of whole-trial errors AFTER exclusion by error rate
        %%%and manual exclusion
        T=tapply(A,{'subjN'},{A.errorTrial(:,1),'sum','name','errorTrialSum'},  'subset',A.day==3&A.trialType==3&A.TN>21&A.include==1);
        Z=tapply(A,{'subjN'},{A.errorTrial(:,1),'length','name','nTrialsTotal'},'subset',A.day==3&A.trialType==3&A.TN>21&A.include==1);
        
        T.percentage = (T.errorTrialSum ./ Z.nTrialsTotal) * 100;
        
        figure;
        scatterplot(T.subjN,T.percentage,...
            'leg','auto');
        xlabel('Participant')
        ylabel('Percentage of erroneous trials after outlier exclusion (manual & auto)')
        ylim([-2, 102])
        %drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        title(['Good participants: ' num2str(length(T.subjN))])
        % ---------------------------------------------------------------- %
        
        %%%Save back to dataAll file
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
    case 'loadDemographics' %import questionnaire data files - must run outliers first
        cd(saveDir)
        
        %%% Delete the first and third rows of the excel sheet before you
        %%% import to matlab - they contain nuisance variables
        fileInBangor = demographicsFilenameBangor;
        fileInBrum   = demographicsFilenameBrum;
        
        tblBangor = readtable(fileInBangor);
        tblBrum   = readtable(fileInBrum);
        
        tblBrum.PleaseDescribeTheStrategyYouUsedToPerformTheSequencesAsAccura_1 = ...
            num2cell(tblBrum.PleaseDescribeTheStrategyYouUsedToPerformTheSequencesAsAccura_1); %some questions are stored in different formats
        tblBrum.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__plea  = ...         %across our two tables,
            num2cell(tblBrum.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__plea); %so here we fix that. Adjust as necessary
        tbl = [tblBangor; tblBrum];
        clear('tblBangor', 'tblBrum')
        
        subjID  = str2double(tbl.id);
        musical = tbl.DoYouHaveAnyMusicalTrainingOrExperience_;
        sporty  = tbl.DoYouHaveAnySportsTrainingOrExperience_;
        dancer  = tbl.DoYouHaveAnyDanceTrainingOrExperience_;
        gamer   = tbl.DoYouHaveAnyVideoGamingExperience_;
        
        %%%General answers
        Q.subjID         = subjID;
        Q.timeSleep      = tbl.AtWhatTimeDidYouFallAsleepTheNightBeforeDay3_;
        Q.timeWake       = tbl.AtWhatTimeDidYouWakeUpOnTheMorningOfDay3_;
        Q.sleepQuality   = str2double(tbl.HowWasTheQualityOfYourSleepOnTheNightBeforeDay3_1BeingVeryPoorT);
        Q.strategy       = tbl.PleaseDescribeTheStrategyYouUsedToPerformTheSequencesAsAccurate;
        Q.strategyCont   = tbl.PleaseDescribeTheStrategyYouUsedToPerformTheSequencesAsAccura_1;
        Q.seqNGuess      = tbl.HowManyDifferentSequencesWereYouTrainedToProduceFromMemory_;
        Q.seqPressGuess  = tbl.PleaseWriteDownAllFingerSequencesYouCanRememberUsingDigitsForFi;
        Q.memoryStrategy = tbl.WhenYouTriedToRememberTheSequenceAbove_HowDidYouDoIt_E_g_Finger;
        
        %%%Music
        Q.musical            = strcmp(musical, 'Yes');
        Q.musicType          = tbl.WhatTypeOfMusicalTraining_experienceDoYouHave_E_g_GuitarLessons;
        Q.musicAgeStart      = tbl.AtWhatAgeDidYouFirstStartPlayingThisInstrument_;
        Q.musicYearsTraining = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__Selected;
        Q.musicFiveYearsPlus = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__5Years__;
        Q.musicHoursPerWeek  = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__SelectedChoi;
        Q.musicFiveHoursPlus = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__plea;
        
        %%%Sports
        Q.sporty             = strcmp(sporty, 'Yes');
        Q.sportType          = tbl.WhatTypeOfSportsTraining_experienceDoYouHave_E_g_FootballCoachi;
        Q.sportAgeStart      = tbl.AtWhatAgeDidYouFirstStartPlayingThisSport_;
        Q.sportYearsTraining = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__Select_1;
        Q.sportFiveYearsPlus = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__5Years_1;
        Q.sportHoursPerWeek  = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__SelectedCh_1;
        Q.sportFiveHoursPlus = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__pl_1;
        
        %%%Dance
        Q.dancer             = strcmp(dancer, 'Yes');
        Q.danceType          = tbl.WhatTypeOfDanceTraining_experienceDoYouHave_E_g_StreetDanceLess;
        Q.danceAgeStart      = tbl.AtWhatAgeDidYouFirstStartDanceTraining_;
        Q.danceYearsTraining = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__Select_2;
        Q.danceFiveYearsPlus = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__5Years_2;
        Q.danceHoursPerWeek  = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__SelectedCh_2;
        Q.danceFiveHoursPlus = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__pl_2;
        
        %%%Gaming
        Q.gamer              = strcmp(gamer, 'Yes');
        Q.gamesType          = tbl.WhatTypeOfGamingDoYouDo_E_g_PC_Console___;
        Q.gamesAgeStart      = tbl.AtWhatAgeDidYouFirstStartGaming_;
        Q.gamerYearsTraining = tbl.HowMuchExperienceDoYouHave__SelectedChoice;
        Q.gamerFiveYearsPlus = tbl.HowMuchExperienceDoYouHave__5Years__pleaseSpecify__Text;
        Q.gamerHoursPerWeek  = tbl.HowManyHoursOfGamingDoYouDoPerWeek__SelectedChoice;
        Q.gamerFiveHoursPlus = tbl.HowManyHoursOfGamingDoYouDoPerWeek__5_Hours_pleaseSpecify__Text;
        
        save('cqHC_questionnaire.mat','Q')
    
    case 'dayProgression' %Progression through 3 days: RT, movTime, error. Both instructed & memory
        [A, ~] = CQHC_initCase(saveDir);
        
        %plot as subplots
        figure
        subplot(3,1,1)
        
        %%%Plot RT progression across days, includes both instructed and
        %%%memory trials
        %figure
        R = tapply(A,{'BN','day','subjN'},{A.RT(:,1),'nanmedian','name','RT'},...
            'subset', A.trialType~=2&~A.errorTrial&A.include==1);
        R.RT = R.RT * 1000;
        
        lineplot([R.day, R.BN], R.RT);
        ylabel('RT (ms)')
        xlabel('Block/Day')
        % ---------------------------------------------------------------- %
        
        %%%Plot movement time progression across days, as above
        subplot(3,1,2)
        %figure
        P = tapply(A,{'BN','day','subjN'},{A.RT(:,4),'nanmedian','name','PT'},...
            'subset', A.trialType~=2&~A.errorTrial&A.include==1);
        P.PT = P.PT * 1000; %convert from s to ms (last press time)
        
        %Subtract last press time from first press time (= prod length)
        P.PT = P.PT - R.RT;
        
        lineplot([P.day, P.BN], P.PT);
        ylabel('Production time (ms)')
        xlabel('Block/Day')
        % ---------------------------------------------------------------- %
        
        %%%Plot error rate progression across days, as above
        subplot(3,1,3)
        %figure
        E = tapply(A,{'BN','day','subjN'},{A.errorTrial,'sum','name','errorSum'},...
            'subset', A.trialType~=2&A.include==1);
        Elength = tapply(A,{'BN','day','subjN'},{A.errorTrial,'length','name','errorLength'},...
            'subset', A.trialType~=2&A.include==1);
        E.errorPerc = (E.errorSum ./ Elength.errorLength) * 100;
        
        lineplot([E.day, E.BN], E.errorPerc);
        ylabel('Error rate (%)')
        xlabel('Block/Day')
        % ---------------------------------------------------------------- %
    case 'performanceOverview' %Prod trials 3rd day: RT,movTime,error by sequence
        [A, ~] = CQHC_initCase(saveDir);%init
        %%%Plot RT and move time split by sequence(hand) and sequence set
        
        %Plot RT split by sequence
        R = tapply(A,{'fractal','seqSet','subjN'},{A.RT(:,1),'nanmedian','name','memoryRT'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.memoryRT = R.memoryRT * 1000; %ms conversion
        
        figure
        subplot(1,3,1)
        violinplot(R.memoryRT, R.fractal);
        ylabel('Initiation RT (ms)')
        xlabel('Sequence')
        ylim([0 1200])
        
        %test significance of RT between fractals
        for i = 1:length(unique(R.fractal)') - 1%for diff between seqs
            [t(i), p(i)] = ttest(R.memoryRT(R.fractal == i),R.memoryRT(R.fractal == i+1),2,'paired');
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = [1.5]; %x coordinates for the significance *s on plot
        astYLoc = [700];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        
        %Plot move time split by sequence
        P = tapply(A,{'fractal','seqSet','subjN'},{A.RT(:,4),'nanmedian','name','memoryProd'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        P.memoryProd = P.memoryProd * 1000; %ms conversion
        
        %Subtract last press time from first press time (= prod length)
        P.memoryProd = P.memoryProd - R.memoryRT;
        
        subplot(1,3,2)
        violinplot(P.memoryProd, P.fractal);
        ylabel('Total movement time (ms)')
        xlabel('Sequence')
        
        %test significance of RT between seqs
        for i = 1:length(unique(P.fractal)') - 1%for diff between seqs
            [t(i), p(i)] = ttest(P.memoryProd(P.fractal == i),P.memoryProd(P.fractal == i+1),2,'paired');
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = 1.5; %x coordinates for the significance *s on plot
        astYLoc = 1250;
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        
        %Plot error split by sequence
        E       = tapply(A,{'fractal','seqSet','subjN'},{A.errorTrial(:,1),'sum','name','errorSum'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.include==1);
        Elength = tapply(A,{'fractal','seqSet','subjN'},{A.errorTrial(:,1),'length','name','errorLength'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.include==1);
        E.errorPerc = (E.errorSum ./ Elength.errorLength) * 100;
        
        subplot(1,3,3)
        violinplot(E.errorSum, E.fractal);
        ylabel('Error rate (%)')
        xlabel('Sequence')
        %ylim([0 1200])
        
        %test significance of error between seqs
        for i = 1:length(unique(E.fractal)') - 1%for diff between seqs
            [t(i), p(i)] = ttest(E.errorPerc(E.fractal == i),E.errorPerc(E.fractal == i+1),2,'paired');
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = 1.5; %x coordinates for the significance *s on plot
        astYLoc = 15;
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        
        %Plot RT split by seqSet
        figure
        subplot(1,3,1)
        violinplot(R.memoryRT, R.seqSet);
        ylabel('Initiation RT (ms)')
        xlabel('Sequence set')
        ylim([0 1200])
        
        %test significance of RT between seq sets (rank sum due to
        %different vector lengths)
        for i = 1:length(unique(R.seqSet)') - 1%for diff between seq sets
            [p(i),h(i),stats(i)] = ranksum(R.memoryRT(R.seqSet == i),R.memoryRT(R.seqSet == i+1));
        end%for diff between seq sets
        
        astXLoc = 1.5; %x coordinates for the significance *s on plot
        astYLoc = 700;
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        %Plot move time split by seqSet
        subplot(1,3,2)
        violinplot(P.memoryProd, P.seqSet);
        ylabel('Total movement time (ms)')
        xlabel('Sequence set')
        
        %test significance of RT between seq sets
        for i = 1:length(unique(P.seqSet)') - 1%for diff between seqs
            [p(i),h(i),stats(i)] = ranksum(P.memoryProd(P.seqSet == i),P.memoryProd(P.seqSet == i+1));
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = 1.5; %x coordinates for the significance *s on plot
        astYLoc = 1250;
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        %Plot error split by seqSet
        subplot(1,3,3)
        violinplot(E.errorPerc, E.seqSet);
        ylabel('Error rate (%)')
        xlabel('Sequence set')
        %ylim([0 1200])
        
        %test significance of error between seq sets
        for i = 1:length(unique(E.seqSet)') - 1%for diff between seqs
            [p(i),h(i),stats(i)] = ranksum(E.errorPerc(E.seqSet == i),E.errorPerc(E.seqSet == i+1));
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = 1.5; %x coordinates for the significance *s on plot
        astYLoc = 15;
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        
    case 'gradientRT'                    %plot probe RTs, raw and normalised to first position
        [A, ~] = CQHC_initCase(saveDir);%init
        
        %Plot raw RT for each position in both used and unused probes
        R = tapply(A,{'probeTargetPos','subjN'},{A.RT(:,1),'nanmedian','name','probeRT'},...
            'subset', A.trialType==2&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.probeRT = R.probeRT * 1000; %convert to ms
        R.unusedProbeIdx = ones(length(R.probeRT),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT);
        ylabel('Probe RT (ms)')
        xlabel('Probe position')
        % ---------------------------------------------------------------- %
        
        %Plot normalised RT to the first probe for all probes
        firstProbeRT = R.probeRT(R.probeTargetPos == 1);%gives first probe RT, ordered by subj
        R.probeRTRel = nan(length(R.probeRT), 1);
        loopCount = 1;%to count through firstProbeRT
        for i=1:max(R.probeTargetPos)%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeRTRel(R.probeTargetPos == i & R.subjN == j) = ...
                    (R.probeRT(R.probeTargetPos == i & R.subjN == j) / firstProbeRT(loopCount)) * 100;
                loopCount = loopCount + 1;
            end%for subj
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        R.probeRTRel = R.probeRTRel - 100;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRTRel);
        ylabel('Relative probe RT (%)')
        xlabel('Probe position')
        title(['N = ' num2str(length(unique(R.subjN)))])
        
        %test significance of CQ gradient (normalised to first probe)
        probeRT = NaN(length(R.probeRTRel(R.probeTargetPos == 1)), length(unique(R.probeTargetPos)'));
        t = NaN(length(unique(R.probeTargetPos)') - 1,1); p = NaN(length(unique(R.probeTargetPos)') - 1,1);
        for i = unique(R.probeTargetPos)'%for probes
            probeRT(:,i) = R.probeRTRel(R.probeTargetPos == i);
        end%for probes
        for i = 1:length(unique(R.probeTargetPos)') - 1%for diff between probes
            [t(i), p(i)] = ttest(probeRT(:,i),probeRT(:,i+1),2,'paired');
        end%for diff between probes
        
        p = p / 2; %convert to ONE-TAILED test (was annoying to code into the function directly)
        astXLoc = [1.35, 2.05, 2.75, 3.6, 4.45, 5.15, 5.85]; %x coordinates for the significance *s on plot
        astYLoc = [15,   17,   18,   20,  30,   27,   24];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
        
        %%%calculate relative RT differences (average difference between
        %%%adjacent probe positions, Mantziara et al (2021)) and calculate
        %%%area under the CQ curve as a proxy for CQ. Used in the
        %%%'gradientRTPerformanceCorrelation' case.
        
        %Relative RT difference between adjacent probe positions, meaned
        relRTDiff = NaN(length(R.probeRT(R.probeTargetPos == 1)), 3);
        for i=1:3%for probe diffs
            relRTDiff(:,i) = R.probeRTRel(R.probeTargetPos == i+1) - R.probeRTRel(R.probeTargetPos == i);
        end%for probe diffs
        relRTDiff = mean(relRTDiff, 2);
        
        %Calculate each participant's area under CQ curve
        probeLine = [R.probeRTRel(R.probeTargetPos == 1), R.probeRTRel(R.probeTargetPos == 2), R.probeRTRel(R.probeTargetPos == 3), R.probeRTRel(R.probeTargetPos == 4)];
        for i=1:length(probeLine)
            relAreaUnderCurve(i,1) = trapz(probeLine(i,:));
        end
        
        
        %Add back to A struct
        A.relRTDiff         = NaN(length(A.subjID),1);
        A.relAreaUnderCurve = NaN(length(A.subjID),1);
        loopCounter = 1;
        for i=unique(A.subjN(A.include == 1))'
            A.relRTDiff(A.subjN == i, 1)         = relRTDiff(loopCounter);
            A.relAreaUnderCurve(A.subjN == i, 1) = relAreaUnderCurve(loopCounter);
            loopCounter = loopCounter + 1;
        end
        
        
        %%%Save our changes back into A
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
    case 'gradientRTSplitBySeq'          %as above, split by sequence (fractal - right left)
        [A, ~] = CQHC_initCase(saveDir);%init
        colour = {[0 0 0], [0.7 0.7 0.7]};
        %legend = ('Seq set 1', 'Seq set 2');
        
        %Plot raw RT for each position in both used and unused probes
        R = tapply(A,{'fractal','probeTargetPos','subjN'},{A.RT(:,1),'nanmedian','name','probeRT'},...
            'subset', A.trialType==2&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.probeRT = R.probeRT * 1000; %convert to ms
        R.unusedProbeIdx = ones(length(R.probeRT),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT, 'split', R.fractal,...
            'linecolor', colour);
        ylabel('Probe RT (ms)')
        xlabel('Probe position')
        legend('', 'Seq set 1', 'Seq set 2');
        % ---------------------------------------------------------------- %
        
        %Plot normalised RT to the first probe for all probes
        firstProbeRT = R.probeRT(R.probeTargetPos == 1);%gives first probe RT, ordered by subj
        R.probeRTRel = nan(length(R.probeRT), 1);
        loopCount = 1;%to count through firstProbeRT
        for i=1:max(R.probeTargetPos)%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeRTRel(R.probeTargetPos == i & R.subjN == j) = ...
                    R.probeRT(R.probeTargetPos == i & R.subjN == j) / firstProbeRT(loopCount) * 100;
                loopCount = loopCount + 1;
            end%for subj
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        R.probeRTRel = R.probeRTRel - 100;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRTRel, 'split', R.fractal,...
            'linecolor', colour);
        ylabel('Relative probe RT (%)')
        xlabel('Probe position')
        title(['N = ' num2str(length(unique(R.subjN)))])
        legend('', 'Seq 1', 'Seq 2');
        % ---------------------------------------------------------------- %
    case 'gradientRTSplitBySeqset'       %as above, split by seqSet
        [A, ~] = CQHC_initCase(saveDir);%init
        colour = {[0 0 0], [0.7 0.7 0.7]};
        %legend = ('Seq set 1', 'Seq set 2');
        
        %Plot raw RT for each position in both used and unused probes
        R = tapply(A,{'seqSet','probeTargetPos','subjN'},{A.RT(:,1),'nanmedian','name','probeRT'},...
            'subset', A.trialType==2&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.probeRT = R.probeRT * 1000; %convert to ms
        R.unusedProbeIdx = ones(length(R.probeRT),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT, 'split', R.seqSet,...
            'linecolor', colour);
        ylabel('Probe RT (ms)')
        xlabel('Probe position')
        legend('', 'Seq set 1', 'Seq set 2');
        % ---------------------------------------------------------------- %
        
        %Plot normalised RT to the first probe for all probes
        firstProbeRT = R.probeRT(R.probeTargetPos == 1);%gives first probe RT, ordered by subj
        R.probeRTRel = nan(length(R.probeRT), 1);
        loopCount = 1;%to count through firstProbeRT
        for i=1:max(R.probeTargetPos)%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeRTRel(R.probeTargetPos == i & R.subjN == j) = ...
                    R.probeRT(R.probeTargetPos == i & R.subjN == j) / firstProbeRT(loopCount) * 100;
                loopCount = loopCount + 1;
            end%for subj
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        R.probeRTRel = R.probeRTRel - 100;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRTRel, 'split', R.seqSet,...
            'linecolor', colour);
        ylabel('Relative probe RT (%)')
        xlabel('Probe position')
        title(['N = ' num2str(length(unique(R.subjN)))])
        legend('', 'Seq set 1', 'Seq set 2');
        % ---------------------------------------------------------------- %
    case 'gradientRTByPartic'            %as above, by participant
        [A, ~] = CQHC_initCase(saveDir);%init
        
        %%%remove outliers and separate trials of interest into B struct
        fieldnames = fields(A);
        for i=1:numel(fieldnames)%for fieldnames
            B.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==2&A.points>0&A.day==3&A.TN>21&A.outlierError==0&A.probeTargetPos<=8);
        end%for fieldnames
        
        B.outlier = NaN(length(B.RT), 1);
        for i=unique(B.subjN')
            B.outlier(B.subjN == i) = isoutlier(B.RT(B.subjN == i));
        end
        
        B.unusedProbeIdx = ones(length(B.RT),1);
        B.unusedProbeIdx(B.probeTargetPos > 4) = 2;
        B.RT = B.RT * 1000; %convert to ms
        
        figure
        lineplot([B.unusedProbeIdx B.probeTargetPos], B.RT, 'split', B.subjN)
        ylabel('Probe RT (ms)')
        xlabel('Probe position')
        % ---------------------------------------------------------------- %
        
        B.RTnormed = NaN(length(B.RT),1);
        for i=unique(B.subjN)'
            B.firstProbeRT = median(B.RT(B.probeTargetPos == 1 & B.subjN == i));
            B.RTnormed(B.subjN == i) = B.RT(B.subjN == i) / B.firstProbeRT * 100;
        end
        B.RTnormed = B.RTnormed - 100;
        
        figure
        lineplot([B.unusedProbeIdx B.probeTargetPos], B.RTnormed, 'split', B.subjN)
        ylabel('Relative probe RT (%)')
        xlabel('Probe position')
        title(['N = ' num2str(length(unique(B.subjN)))])
    case 'gradientRTSelectPartic'        %specify participant ID to plot with varargin{1}
        [A, ~] = CQHC_initCase(saveDir);%init
        ID = varargin{1};
        
        for sn = ID
            %%%remove outliers and separate trials of interest into B struct
            fieldnames = fields(A);
            for i=1:numel(fieldnames)%for fieldnames
                B.(fieldnames{i}) = A.(fieldnames{i})(A.subjID==sn&A.trialType==2&A.points>0&A.day==3&A.TN>21&A.probeTargetPos<=8);
            end%for fieldnames
            
            B.outlier = NaN(length(B.RT), 1);
            for i=unique(B.subjN')
                B.outlier(B.subjN == i) = isoutlier(B.RT(B.subjN == i));
            end
            
            B.unusedProbeIdx = ones(length(B.RT),1);
            B.unusedProbeIdx(B.probeTargetPos > 4) = 2;
            B.RT = B.RT * 1000; %convert to ms
            
            %figure
            %lineplot([B.unusedProbeIdx B.probeTargetPos], B.RT, 'split', B.subjN)
            %ylabel('Probe RT (ms)')
            %xlabel('Probe position')
            % ---------------------------------------------------------------- %
            
            B.RTnormed = NaN(length(B.RT),1);
            for i=unique(B.subjN)'
                B.firstProbeRT = median(B.RT(B.probeTargetPos == 1 & B.subjN == i));
                B.RTnormed(B.subjN == i) = B.RT(B.subjN == i) / B.firstProbeRT * 100;
            end
            B.RTnormed = B.RTnormed - 100;
            
            figure
            lineplot([B.unusedProbeIdx B.probeTargetPos], B.RTnormed, 'split', B.subjN)
            ylabel('Relative probe RT (%)')
            xlabel('Probe position')
            title(['Participant ID = ' num2str(sn)])
        end
    case 'gradientRTMedianSplit'
        [A, ~] = CQHC_initCase(saveDir);%init
        
        %%%Calc average of measure to split by
        sb = tapply(A,{'subjN'},{A.RT(:,1),'nanmedian','name','memRT'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        
        %%%Find median across whole group
        splitByValuemedian = (sb.memRT);
        
        %%%Assign participants to each group
        
        
        %%%Run analyses by split
        
        %Plot raw RT for each position in both used and unused probes
        R = tapply(A,{'probeTargetPos','subjN'},{A.RT(:,1),'nanmedian','name','probeRT'},...
            'subset', A.trialType==2&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.probeRT = R.probeRT * 1000; %convert to ms
        R.unusedProbeIdx = ones(length(R.probeRT),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT);
        ylabel('Probe RT (ms)')
        xlabel('Probe position')
        % ---------------------------------------------------------------- %
        
        %Plot normalised RT to the first probe for all probes
        firstProbeRT = R.probeRT(R.probeTargetPos == 1);%gives first probe RT, ordered by subj
        R.probeRTRel = nan(length(R.probeRT), 1);
        loopCount = 1;%to count through firstProbeRT
        for i=1:max(R.probeTargetPos)%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeRTRel(R.probeTargetPos == i & R.subjN == j) = ...
                    (R.probeRT(R.probeTargetPos == i & R.subjN == j) / firstProbeRT(loopCount)) * 100;
                loopCount = loopCount + 1;
            end%for subj
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        R.probeRTRel = R.probeRTRel - 100;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRTRel);
        ylabel('Relative probe RT (%)')
        xlabel('Probe position')
        title(['N = ' num2str(length(unique(R.subjN)))])
        
        %test significance of CQ gradient (normalised to first probe)
        probeRT = NaN(length(R.probeRTRel(R.probeTargetPos == 1)), length(unique(R.probeTargetPos)'));
        t = NaN(length(unique(R.probeTargetPos)') - 1,1); p = NaN(length(unique(R.probeTargetPos)') - 1,1);
        for i = unique(R.probeTargetPos)'%for probes
            probeRT(:,i) = R.probeRTRel(R.probeTargetPos == i);
        end%for probes
        for i = 1:length(unique(R.probeTargetPos)') - 1%for diff between probes
            [t(i), p(i)] = ttest(probeRT(:,i),probeRT(:,i+1),2,'paired');
        end%for diff between probes
        
        p = p / 2; %convert to ONE-TAILED test (was annoying to code into the function directly)
        astXLoc = [1.35, 2.05, 2.75, 3.6, 4.45, 5.15, 5.85]; %x coordinates for the significance *s on plot
        astYLoc = [15,   17,   18,   20,  30,   27,   24];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
        
        %%%calculate relative RT differences (average difference between
        %%%adjacent probe positions, Mantziara et al (2021)) and calculate
        %%%area under the CQ curve as a proxy for CQ. Used in the
        %%%'gradientRTPerformanceCorrelation' case.
        
        %Relative RT difference between adjacent probe positions, meaned
        relRTDiff = NaN(length(R.probeRT(R.probeTargetPos == 1)), 3);
        for i=1:3%for probe diffs
            relRTDiff(:,i) = R.probeRTRel(R.probeTargetPos == i+1) - R.probeRTRel(R.probeTargetPos == i);
        end%for probe diffs
        relRTDiff = mean(relRTDiff, 2);
        
        %Calculate each participant's area under CQ curve
        probeLine = [R.probeRTRel(R.probeTargetPos == 1), R.probeRTRel(R.probeTargetPos == 2), R.probeRTRel(R.probeTargetPos == 3), R.probeRTRel(R.probeTargetPos == 4)];
        for i=1:length(probeLine)
            relAreaUnderCurve(i,1) = trapz(probeLine(i,:));
        end
        
        
        %Add back to A struct
        A.relRTDiff         = NaN(length(A.subjID),1);
        A.relAreaUnderCurve = NaN(length(A.subjID),1);
        loopCounter = 1;
        for i=unique(A.subjN(A.include == 1))'
            A.relRTDiff(A.subjN == i, 1)         = relRTDiff(loopCounter);
            A.relAreaUnderCurve(A.subjN == i, 1) = relAreaUnderCurve(loopCounter);
            loopCounter = loopCounter + 1;
        end
        
        
        %%%Save our changes back into A
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
        
        
    case 'gradientError'                 %plot probe error rates, normalised to first position
        [A, subj] = CQHC_initCase(saveDir); %init
        
        %remove outlier participants and separate trials of interest. Here 
        %we take correct trials as opposed to errors to avoid dividing by 
        %zero, and then convert to errors after data extraction.
        R = tapply(A,{'probeTargetPos','subjN'},{~A.errorTrial(:,1),'sum','name','probeCorrect'}, ...
            'subset', A.trialType==2&A.day==3&A.TN>21&A.include==1);
        
        %Convert to percentage (allows for comparison between used and
        %unused probes
        L = tapply(A,{'probeTargetPos','subjN'},{~A.errorTrial(:,1),'length','name','probeLength'}, ...
            'subset', A.trialType==2 & A.day==3 & A.TN>21 & A.include==1);
        R.probeCorrectPerc = (R.probeCorrect ./ L.probeLength) * 100;
        
        R.probeErrorRel = NaN(length(R.probeCorrect), 1); %preallocate
        
        firstProbeCorrect = R.probeCorrectPerc(R.probeTargetPos == min(R.probeTargetPos));%gives first probe error, ordered by subj
        loopCount = 1;%to count through firstProbeError
        for i=unique(R.probeTargetPos)'%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeErrorRel(R.probeTargetPos == i & R.subjN == j, :) = ...
                    (R.probeCorrectPerc(R.probeTargetPos == i & R.subjN == j)  / firstProbeCorrect(loopCount) - 1) * 100; %probe error relative to first position
                loopCount = loopCount + 1;
            end%for sub
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        
        R.probeErrorRel(isnan(R.probeErrorRel) | isinf(R.probeErrorRel)) = 0; %remove infs and nans (since sometimes we divide by zero)
        R.probeErrorRel = R.probeErrorRel * -1; %make relative to 0
        
        R.unusedProbeIdx = ones(length(R.probeCorrect),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure; %%%Plot relative error CQ gradient
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeErrorRel);
        title ('Relative error');
        ylabel('Relative Error(%)');
        
        %test significance of CQ gradient (normalised to first probe)
        probeError = NaN(length(R.probeErrorRel(R.probeTargetPos == 1)), length(unique(R.probeTargetPos)'));
        t = NaN(length(unique(R.probeTargetPos)') - 1,1); p = NaN(length(unique(R.probeTargetPos)') - 1,1);
        for i = unique(R.probeTargetPos)'%for probes
            probeError(:,i) = R.probeErrorRel(R.probeTargetPos == i);
        end%for probes
        for i = 1:length(unique(R.probeTargetPos)') - 1%for diff between probes
            [t(i), p(i)] = ttest(probeError(:,i),probeError(:,i+1),2,'paired');
        end%for diff between probes
        
        p = p / 2; %convert to ONE-TAILED test (was annoying to code into the function directly)
        astXLoc = [1.3, 2.05, 2.75, 3.6, 4.45, 5.15, 5.85]; %x coordinates for the significance *s on plot
        astYLoc = [8,   13,   14,   15,  20,   15,   17];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        
        %%%calculate relative error differences (average difference between
        %%%adjacent probe positions, Mantziara et al (2021)) and calculate
        %%%area under the CQ curve as a proxy for CQ. Used in the
        %%%'gradientErrorPerformanceCorrelation' case.
        
        %Relative RT difference between adjacent probe positions, meaned
        relErrorDiff = NaN(length(R.probeErrorRel(R.probeTargetPos == 1)), 3);
        for i=1:3%for probe diffs
            relErrorDiff(:,i) = R.probeErrorRel(R.probeTargetPos == i+1) - R.probeErrorRel(R.probeTargetPos == i);
        end%for probe diffs
        relErrorDiff = mean(relErrorDiff, 2);
        
        %Calculate each participant's area under CQ curve
        probeLine = [R.probeErrorRel(R.probeTargetPos == 1), R.probeErrorRel(R.probeTargetPos == 2), ...
                     R.probeErrorRel(R.probeTargetPos == 3), R.probeErrorRel(R.probeTargetPos == 4)];
        for i=1:length(probeLine)
            relAreaUnderCurve(i,1) = trapz(probeLine(i,:));
        end
        
        
        %Add back to A struct
        A.relErrorDiff         = NaN(length(A.subjID),1);
        A.relErrorAreaUnderCurve = NaN(length(A.subjID),1);
        loopCounter = 1;
        for i=unique(A.subjN(A.include == 1))'
            A.relErrorDiff(A.subjN == i, 1)              = relErrorDiff(loopCounter);
            A.relErrorAreaUnderCurve(A.subjN == i, 1) = relAreaUnderCurve(loopCounter);
            loopCounter = loopCounter + 1;
        end
        
        
        %%%Save our changes back into A
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
    case 'gradientErrorSplitBySeq'       %as above, split by sequence (fractal - right left)
        [A, subj] = CQHC_initCase(saveDir); %init
        
        %remove outlier participants and separate trials of interest. Here 
        %we take correct trials as opposed to errors to avoid dividing by 
        %zero, and then convert to errors after data extraction.
        R = tapply(A,{'fractal','probeTargetPos','subjN'},{~A.errorTrial(:,1),'sum','name','probeCorrect'}, ...
            'subset', A.trialType==2&A.day==3&A.TN>21&A.include==1);
        
        %Convert to percentage (allows for comparison between used and
        %unused probes
        L = tapply(A,{'probeTargetPos','subjN'},{~A.errorTrial(:,1),'length','name','probeLength'}, ...
            'subset', A.trialType==2 & A.day==3 & A.TN>21 & A.include==1);
        R.probeCorrectPerc = (R.probeCorrect ./ L.probeLength) * 100;
        
        R.probeErrorRel = NaN(length(R.probeCorrect), 1); %preallocate
        
        firstProbeCorrect = R.probeCorrectPerc(R.probeTargetPos == min(R.probeTargetPos));%gives first probe error, ordered by subj
        loopCount = 1;%to count through firstProbeError
        for i=unique(R.probeTargetPos)'%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeErrorRel(R.probeTargetPos == i & R.subjN == j, :) = ...
                    (R.probeCorrectPerc(R.probeTargetPos == i & R.subjN == j)  / firstProbeCorrect(loopCount) - 1) * 100; %probe error relative to first position
                loopCount = loopCount + 1;
            end%for sub
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        
        R.probeErrorRel(isnan(R.probeErrorRel) | isinf(R.probeErrorRel)) = 0; %remove infs and nans (since sometimes we divide by zero)
        R.probeErrorRel = R.probeErrorRel * -1; %make relative to 0
        
        R.unusedProbeIdx = ones(length(R.probeCorrect),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure; %%%Plot relative error CQ gradient
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeErrorRel);
        title ('Relative error');
        ylabel('Relative Error(%)');
        
        %test significance of CQ gradient (normalised to first probe)
        probeError = NaN(length(R.probeErrorRel(R.probeTargetPos == 1)), length(unique(R.probeTargetPos)'));
        t = NaN(length(unique(R.probeTargetPos)') - 1,1); p = NaN(length(unique(R.probeTargetPos)') - 1,1);
        for i = unique(R.probeTargetPos)'%for probes
            probeError(:,i) = R.probeErrorRel(R.probeTargetPos == i);
        end%for probes
        for i = 1:length(unique(R.probeTargetPos)') - 1%for diff between probes
            [t(i), p(i)] = ttest(probeError(:,i),probeError(:,i+1),2,'paired');
        end%for diff between probes
        
        p = p / 2; %convert to ONE-TAILED test (was annoying to code into the function directly)
        astXLoc = [1.3, 2.05, 2.75, 3.6, 4.45, 5.15, 5.85]; %x coordinates for the significance *s on plot
        astYLoc = [8,   13,   14,   15,  20,   15,   17];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        %disp(p)
        % ---------------------------------------------------------------- %
        
        
        %%%calculate relative error differences (average difference between
        %%%adjacent probe positions, Mantziara et al (2021)) and calculate
        %%%area under the CQ curve as a proxy for CQ. Used in the
        %%%'gradientErrorPerformanceCorrelation' case.
        
        %Relative RT difference between adjacent probe positions, meaned
        relErrorDiff = NaN(length(R.probeErrorRel(R.probeTargetPos == 1)), 3);
        for i=1:3%for probe diffs
            relErrorDiff(:,i) = R.probeErrorRel(R.probeTargetPos == i+1) - R.probeErrorRel(R.probeTargetPos == i);
        end%for probe diffs
        relErrorDiff = mean(relErrorDiff, 2);
        
        %Calculate each participant's area under CQ curve
        probeLine = [R.probeErrorRel(R.probeTargetPos == 1), R.probeErrorRel(R.probeTargetPos == 2), ...
                     R.probeErrorRel(R.probeTargetPos == 3), R.probeErrorRel(R.probeTargetPos == 4)];
        for i=1:length(probeLine)
            relAreaUnderCurve(i,1) = trapz(probeLine(i,:));
        end
        
        
        %Add back to A struct
        A.relErrorDiff         = NaN(length(A.subjID),1);
        A.relErrorAreaUnderCurve = NaN(length(A.subjID),1);
        loopCounter = 1;
        for i=unique(A.subjN(A.include == 1))'
            A.relErrorDiff(A.subjN == i, 1)              = relErrorDiff(loopCounter);
            A.relErrorAreaUnderCurve(A.subjN == i, 1) = relAreaUnderCurve(loopCounter);
            loopCounter = loopCounter + 1;
        end
        
        
        %%%Save our changes back into A
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
        
    case 'gradientRTPerformanceCorrelation'    %Correlate RT CQ effect with performance - requires gradientRT to be run first
        [A, ~] = CQHC_initCase(saveDir);%init
        
        %%%Correlate performance with mean difference between adjacent
        %%%probe positions
        
        %%%Plot memoryRT against relRTDiff (CQ curve)
        R = tapply(A,{'subjN','relRTDiff'},{A.RT(:,1),'nanmedian','name','memoryRT'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.memoryRT = R.memoryRT * 1000; %convert from s to ms
        
        [r, p] = corrcoef(R.relRTDiff, R.memoryRT);
        figure
        scatterplot(R.memoryRT, R.relRTDiff, 'regression', 'linear')
        xlabel('Initiation RT(ms)')
        ylabel('Relative RT differences (%)')
        title(['N = ' num2str(length(R.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        
        %%%Plot prod time against relRTDiff (CQ curve)
        P = tapply(A,{'subjN','relRTDiff'},{A.RT(:,4),'nanmedian','name','memoryProd'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        P.memoryProd = P.memoryProd * 1000; %convert from s to ms (last press time)
        
        %Subtract last press time from first press time (= prod length)
        P.memoryProd = P.memoryProd - R.memoryRT;
        
        [r, p] = corrcoef(P.relRTDiff, P.memoryProd);
        figure
        scatterplot(P.memoryProd, P.relRTDiff, 'regression', 'linear')
        xlabel('Total production time (ms)')
        ylabel('Relative RT differences (%)')
        title(['N = ' num2str(length(P.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        
        %%%Correlate performance with area under curve
        R = tapply(A,{'subjN','relAreaUnderCurve'},{A.RT(:,1),'nanmedian','name','memoryRT'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.memoryRT = R.memoryRT * 1000; %convert from s to ms
        
        [r, p] = corrcoef(R.relAreaUnderCurve, R.memoryRT);
        figure
        scatterplot(R.memoryRT, R.relAreaUnderCurve, 'regression', 'linear')
        xlabel('Initiation RT(ms)')
        ylabel('Area under curve')
        title(['N = ' num2str(length(R.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        P = tapply(A,{'subjN','relAreaUnderCurve'},{A.RT(:,4),'nanmedian','name','memoryProd'},...
            'subset',  A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        P.memoryProd = P.memoryProd * 1000; %convert from s to ms
        
        [r, p] = corrcoef(P.relAreaUnderCurve, P.memoryProd);
        figure
        scatterplot(P.memoryProd, P.relAreaUnderCurve, 'regression', 'linear')
        xlabel('Total production time (ms)')
        ylabel('Area under curve')
        title(['N = ' num2str(length(P.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
    case 'gradientErrorPerformanceCorrelation' %Correlate error CQ effect with performance - requires gradientError to be run first
        [A, ~] = CQHC_initCase(saveDir);%init
        
        %%%Correlate performance with mean difference between adjacent
        %%%probe positions
        
        %%%Plot memoryRT against relRTDiff (CQ curve)
        R = tapply(A,{'subjN','relErrorDiff'},{A.RT(:,1),'nanmedian','name','memoryRT'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.memoryRT = R.memoryRT * 1000; %convert from s to ms
        
        [r, p] = corrcoef(R.relErrorDiff, R.memoryRT);
        figure
        scatterplot(R.memoryRT, R.relErrorDiff, 'regression', 'linear')
        xlabel('Initiation RT(ms)')
        ylabel('Relative error differences (%)')
        title(['N = ' num2str(length(R.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        
        %%%Plot prod time against relRTDiff (CQ curve)
        P = tapply(A,{'subjN','relErrorDiff'},{A.RT(:,4),'nanmedian','name','memoryProd'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        P.memoryProd = P.memoryProd * 1000; %convert from s to ms (last press time)
        
        %Subtract last press time from first press time (= prod length)
        P.memoryProd = P.memoryProd - R.memoryRT;
        
        [r, p] = corrcoef(P.relErrorDiff, P.memoryProd);
        figure
        scatterplot(P.memoryProd, P.relErrorDiff, 'regression', 'linear')
        xlabel('Total production time (ms)')
        ylabel('Relative error differences (%)')
        title(['N = ' num2str(length(P.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        
        %%%Correlate performance with area under curve
        R = tapply(A,{'subjN','relErrorAreaUnderCurve'},{A.RT(:,1),'nanmedian','name','memoryRT'},...
            'subset', A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        R.memoryRT = R.memoryRT * 1000; %convert from s to ms
        
        [r, p] = corrcoef(R.relErrorAreaUnderCurve, R.memoryRT);
        figure
        scatterplot(R.memoryRT, R.relErrorAreaUnderCurve, 'regression', 'linear')
        xlabel('Initiation RT(ms)')
        ylabel('Error area under curve')
        title(['N = ' num2str(length(R.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        P = tapply(A,{'subjN','relErrorAreaUnderCurve'},{A.RT(:,4),'nanmedian','name','memoryProd'},...
            'subset',  A.trialType==3&A.day==3&A.TN>21&A.points>0&A.include==1);
        P.memoryProd = P.memoryProd * 1000; %convert from s to ms
        
        [r, p] = corrcoef(P.relErrorAreaUnderCurve, P.memoryProd);
        figure
        scatterplot(P.memoryProd, P.relErrorAreaUnderCurve, 'regression', 'linear')
        xlabel('Total production time (ms)')
        ylabel('Error area under curve')
        title(['N = ' num2str(length(P.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        
        
        
    case 'demographicOverview'
        [A, ~] = CQHC_initCase(saveDir);%init
        [Q, ~] = CQHC_initCaseDemographic(saveDir); %initDemo
        
        Q.include = ismember(Q.subjID, unique(A.subjID(A.include == 1))); %add include variable
        
        %%%remove outliers and separate trials of interest into B struct
        fieldnames = fields(Q);
        for i=1:numel(fieldnames)%for fieldnames
            B.(fieldnames{i}) = Q.(fieldnames{i})(Q.include);
        end%for fieldnames
        
        nMusical = sum(B.musical); nSporty = sum(B.sporty); nDancer = sum(B.dancer); nGamer = sum(B.gamer);
        nTotal = length(B.subjID);
        
        N.experience = [nMusical; nSporty; nDancer; nGamer];
        N.expCategories(:,1) = 1:4; %1 = musical, 2 = sporty, 3 = dancer, 4 = gamer
        N.experiencePerc = (N.experience ./ nTotal) * 100;
        
        N.experienceRows = [B.musical B.sporty B.dancer B.gamer];
        
        nTalents = sum(N.experienceRows, 2);
        nMultiTalent = sum(nTalents > 1);
        talentCategories = 0:4; %according to how many talents each person has (0:4)
        talentCounts = NaN(1,length(talentCategories));
        
        for i=1:length(talentCategories)
            talentCounts(i) = sum(nTalents == talentCategories(i));
        end
        
        figure %Plot proportion of talent numbers in bar chart
        talentPercs = round((talentCounts ./ sum(talentCounts)) * 100);
        labels = sprintfc('%d',talentCategories);
        talentPercsLabels = strcat(sprintfc('%d',talentPercs), '%'); labels = categorical(labels);
        % pie(talentCounts, labels)
        bar(labels, talentCounts)
        text(1:length(labels),talentCounts,talentPercsLabels,'vert','bottom','horiz','center')
        ylim([-1, 20])
        set(gca, 'box', 'off')
        xlabel('Number of talents')
        ylabel('Number of participants')
        
        %pre-allocate loop storage variables
        experienceRowsIdx = NaN(length(N.experienceRows(:,1)),length(N.experienceRows(1,:)),length(N.experience));
        
        for i=1:length(N.experience)
            
            experienceRowsIdx = N.experienceRows;
            experienceRowsIdx(nTalents ~= i,:) = 0;
            
            experienceColIdx = NaN(length(experienceRowsIdx),i);
            for j=1:length(experienceRowsIdx)
                
                if ~isempty(find(experienceRowsIdx(j,:), 1))
                    experienceColIdx(j,:) = find(experienceRowsIdx(j,:));
                else
                    experienceColIdx(j,:) = NaN;
                end
            end
            if i == 1
                oneTalent = experienceColIdx;
            elseif i == 2
                twoTalents = experienceColIdx;
            elseif i == 3
                threeTalents = experienceColIdx;
            elseif i == 4
                fourTalents = experienceColIdx;
            end
        end
        
        Q;
        save(fullfile(saveDir, 'cqHC_questionnaire.mat'),'Q')
    case 'plot'  %extract RT, errors per condition and plot
        [A, ~] = CQHC_initCase(saveDir);
        
        %Raincloud plot
        colPos=[0.5 0.8 0.9; 1 0.7 1; 0.7 0.8 0.9; 0.8 0.5 0.4];
        
        %         fig_position = [200 200 600 400]; % coordinates for figures
        figure;
        
        for i=1:4%for probe position
            RTpos=A.RT(A.trialType==2 & A.points>0 & A.TN>21 & A.include==1 & A.probeTargetPos==i | A.probeTargetPos==i+4);
            subplot(1,4,i);
            raincloud_plot(RTpos,'color',colPos(i,:));
            camroll(+90)
            xlim([0 1.2]);
            title(['ProbePos' num2str(i)]);
            if i==1
                xlabel('RT (seconds)')
            end
            %             ax = gca;
        end%for probe position
        
        clear RTpos
        % ---------------------------------------------------------------- %
        
        figure;
        for i=1:4%for position
            %RTpos=A.RT(A.trialType==2 & A.points>0 & A.day == 3 & A.TN>21 & A.include==1, i);
            RTpos=A.RT(A.trialType==3 & A.points>0 & A.day == 3 & A.TN>21 & A.include==1, i);
            
            
            raincloud_plot(RTpos,'color',colPos(i,:));
            %             ax = gca;
            
            %xlim([0 3]);
            %             ylim([-3 8]);
            camroll(+90)
            title('Sequence Timing');
            hold on;
            
        end%for probe position
        ylim([-4 6]);
        ylabel('Frequency')
        xlabel('RT (seconds)')
        % ---------------------------------------------------------------- %
    case 'stats'  %basic stats
        [A, subj] = CQHC_initCase(saveDir);
        
        B = structfun(@(X) X(A.trialType == 3 & A.day == 3 & A.points >= 1,:), A, 'Uni', false);
        
        for i=subj'%for each subj
            for j=1:length(B.RT(1,:))%for each press col
                
                %get an index of all outliers in each column of RT for each participant
                [~, outlierIdx(:,j)] = rmoutliers(B.RT(B.subjID == i,j));
                
            end%for each press col
            
            outlierIdx = sum(outlierIdx,2); %if there's any outliers across all 4 columns...
            B = structfun(@(X) X(outlierIdx <=1,:), B, 'Uni', false); %remove entire trial
        end%for each subj
        
        RFirst = tapply(A,{'subjID'},{A.RT(:,1),'nanmean','name','moveTime'},'subset',A.trialType == 3 & A.day == 3);
        R  = tapply(A,{'subjID'},{A.RT(:,4),'nanmean','name','moveTime'},'subset',A.trialType == 3 & A.day == 3);
        
        R.moveTime = R.moveTime - RFirst.moveTime;
    case 'errors'
        
        cd(saveDir);
        filename='cqHC_dataAll.mat';
        load(filename,'A') %load A
        % sequence trials number of correct presses. 4 = sequence all
        % correct, 3 = 1 incorrect, 2 = 2 incorrect, 1 = 3 incorrect
        A.numErrorpress=zeros(length(A.errorSum),1);
        for i=1:length(A.errorSum)
            if A.errorSum(i)==4
                A.numErrorpress(i)=0;
            elseif A.errorSum(i)==3
                A.numErrorpress(i)=1;
            elseif A.errorSum(i)==2
                A.numErrorpress(i)=2;
            elseif A.errorSum(i)==1
                A.numErrorpress(i)=3;
            elseif A.errorSum(i)==0
                A.numErrorpress(i)=4;
            end
        end
        M=tapply(A,{'subjN'},{A.errorSum,'sum','name','pressError'},'subset',A.day==3&A.trialType==3&A.TN>20);
        figure;
        scatterplot(M.subjN,M.pressError,...
            'leg','auto')
        title ('Press error for seqeunce Trials (DCD)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        figure;
        scatterplot(M.subject(M.group==2),M.pressError(M.group==2),...
            'leg','auto')
        title ('Press error for seqeunce Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant') % percentage of errors for sequence trials
        M.percentage =[];
        subjID=unique((M.subject));
        for subj=1:length(subjID)
            catHolder=M.pressError(M.subject==subjID(subj))./560;
            M.percentage = [M.percentage; catHolder];
        end
        M.percentage=M.percentage*100;
        figure;
        scatterplot(M.subject(M.group==1),M.percentage(M.group==1),...
            'leg','fill')
        title ('Press error for seqeunce Trials (DCD)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        xticklabels({'1', '2','3','4','5','6','7','8','9','10','11'});
        legend('DCD','Control')
        figure;
        scatterplot(M.subject(M.group==2),M.percentage(M.group==2),...
            'leg','auto')
        title ('Press error for seqeunce Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        %         participants need to have >14 of the probe trials correct to be
        %         included in the analysis
        %         29 probe trials for each position
        T=tapply(A,{'group','subject','probeTargetPos'},{A.ErrorTrial(:,1),'sum','name','probeErrorSum'},'subset',A.day==3&A.trialType==2&A.TN>20);
        T.rawError=29-T.probeErrorSum;
        figure;
        subplot(1,1,1);
        lineplot(T.probeTargetPos(T.group==1), T.rawError(T.group==1),'split',T.subject(T.group==1),'style_thickline','leg','auto');
        title ('Errors (DCD)');
        ylabel('Number of errors');
        drawline(14,'dir','horz','color',[0 0 0],'linestyle','-')
        figure;
        subplot(1,1,1);
        lineplot(T.probeTargetPos(T.group==2), T.rawError(T.group==2),'split',T.subject(T.group==2),'style_thickline','leg','auto');
        title ('Errors (Control)');
        ylabel('Number of errors');
        drawline(14,'dir','horz','color',[0 0 0],'linestyle','-')
        %         participants to include and exclude, 26 control excluded based on
        % probe trials.
        % sequence trial errors exclusion
        A.NumError=zeros(length(A.ErrorTrial),1);
        for i=1:length(A.ErrorTrial)
            if A.ErrorTrial(i)==1
                A.NumError(i)=0;
            else
                A.NumError(i)=1;
            end
        end
        % sequence trials on day 3
        G=tapply(A,{'subject','group'},{A.NumError,'sum','name','MemError'},'subset',A.day==3&A.trialType==3&A.TN>20);
        % sequence trials overall
        %         G=tapply(A,{'subject','group'},{A.NumError,'sum','name','MemError'},'subset',A.trialType==3);
        figure;
        scatterplot(G.subject(G.group==1),G.MemError(G.group==1),...
            'leg','auto')
        title ('Error for seqeunce Trials (DCD)');
        % ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        figure;
        scatterplot(G.subject(G.group==2),G.MemError(G.group==2),...
            'leg','auto')
        title ('Error for seqeunce Trials (Control)');
        % ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        % percentage of errors for sequence trials
        G.percentage =[];
        subjID=unique((G.subject));
        for subj=1:length(subjID)
            catHolder=G.MemError(G.subject==subjID(subj))./140;
            G.percentage = [G.percentage; catHolder];
        end
        G.percentage=G.percentage*100;
        figure;
        scatterplot(G.subject(G.group==1),G.percentage(G.group==1),...
            'leg','fill')
        title ('Error for seqeunce Trials (DCD)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(30,'dir','horz','color',[0 0 0],'linestyle','-')
        % xticklabels({'1', '2','3','4','5','6','7','8','9','10','11'});
        % legend('DCD','Control') figure;
        scatterplot(G.subject(G.group==2),G.percentage(G.group==2),...
            'leg','auto')
        title ('Error for seqeunce Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(30,'dir','horz','color',[0 0 0],'linestyle','-')
        
        
        
end