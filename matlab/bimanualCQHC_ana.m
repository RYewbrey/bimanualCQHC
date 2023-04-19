function bimanualCQHC_ana(which, varargin) %wrapper code
% Imports raw data, saves relevant data in a structure, plots individual and
% group data, and does basic stats
% ---------------------------------------------------
% Foundation written by K. Kornysheva, September 2021
% Adjusted and expanded by R. Yewbrey, October 2022

% Paths to toolboxes and experimental code
%
%%%% CHBH RY PC
% addpath(genpath('Z:/toolboxes/userfun'));%Joern Diedrichsen's util toolbox
% addpath(genpath('Z:/toolboxes/RainCloudPlots-master')); %raincloud plot toolbox
% addpath(genpath('C:/Users/yewbreyr/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC/CQHC/matlab'));%experimental code
% 
%%%% Home RY PC
% addpath(genpath('Z:/toolboxes'));%toolboxes
% addpath(genpath('C:/Users/bugsy/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC/CQHC/matlab'));%experimental code

%%%% CHBH RY PC
% baseDir= 'C:/Users/yewbreyr/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC';

%%%% Home RY PC
baseDir= 'C:/Users/bugsy/OneDrive/Documents/University/PhD/3rd Year/bimanualCQ_HC';

%Directory where psychoPy saves to
rawDir= [baseDir '/bimanualCQ_HC2/data'];
rawDirUoB = [baseDir '/bimanualCQ_HC2brum/data'];

%Directory where processed data should be saved
saveDir= [baseDir '/CQHC/data'];

%General variables that change analyses
errorThreshold = 20; %error threshold for participant inclusion, default 20

%Analysis Cases - switch as function input
switch which
    case 'loadData' %% Import files from .csv to .mat
        cd(rawDir);
        A=[]; %structure across subj
        S=[]; %structure across days
        
        rawFileName = bimanualCQHC_prepFileNames(rawDir, rawDirUoB); %function to define filenames (edit accordingly)
        
        for subj=1:size(rawFileName,1) %subj loop
            for day=1:size(rawFileName,2) %day loop
                disp([rawFileName{subj, day} ' in progress..']);
                
                D = bimanualCQHC_importFile(rawFileName{subj,day}); % imports data from raw, puts it into a structure array
                D.TN= (1:size(D.RT,1))';
                D.subjN = ones(length(D.RT),1) * subj;
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
    case 'loadDemographics'
        cd(saveDir)
        
        %%% Delete the first and third rows of the excel sheet before you
        %%% import to matlab - they contain nuisance variables
        fileIn = 'CQ_HC Day 3 Questionnaire_27 January 2023_08.55.xlsx'; %update filename accordingly
        tbl = readtable(fileIn);
        
        subjID = tbl.id;
        musical = tbl.DoYouHaveAnyMusicalTrainingOrExperience_;
        sporty = tbl.DoYouHaveAnySportsTrainingOrExperience_;
        dancer = tbl.DoYouHaveAnyDanceTrainingOrExperience_;
        gamer = tbl.DoYouHaveAnyVideoGamingExperience_;
        
        Q.subjID = subjID;
        Q.timeSleep = tbl.AtWhatTimeDidYouFallAsleepTheNightBeforeDay3_;
        Q.timeWake  = tbl.AtWhatTimeDidYouWakeUpOnTheMorningOfDay3_;
        Q.sleepQuality = tbl.HowWasTheQualityOfYourSleepOnTheNightBeforeDay3_1BeingVeryPoorT;
        Q.strategy = tbl.PleaseDescribeTheStrategyYouUsedToPerformTheSequencesAsAccurate;
        Q.strategyCont = tbl.PleaseDescribeTheStrategyYouUsedToPerformTheSequencesAsAccura_1;
        Q.seqNGuess = tbl.HowManyDifferentSequencesWereYouTrainedToProduceFromMemory_;
        Q.seqPressGuess = tbl.PleaseWriteDownAllFingerSequencesYouCanRememberUsingDigitsForFi;
        Q.memoryStrategy = tbl.WhenYouTriedToRememberTheSequenceAbove_HowDidYouDoIt_E_g_Finger;
        
        
        Q.musical = strcmp(musical, 'Yes');
        Q.musicType = tbl.WhatTypeOfMusicalTraining_experienceDoYouHave_E_g_GuitarLessons;
        Q.musicAgeStart = tbl.AtWhatAgeDidYouFirstStartPlayingThisInstrument_;
        Q.musicYearsTraining = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__Selected;
        Q.musicFiveYearsPlus = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__5Years__;
        Q.musicHoursPerWeek = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__SelectedChoi;
        Q.musicFiveHoursPlus = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__plea;
        
        Q.sporty = strcmp(sporty, 'Yes');
        Q.sportType = tbl.WhatTypeOfSportsTraining_experienceDoYouHave_E_g_FootballCoachi;
        Q.sportAgeStart = tbl.AtWhatAgeDidYouFirstStartPlayingThisSport_;
        Q.sportYearsTraining = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__Select_1;
        Q.sportFiveYearsPlus = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__5Years_1;
        Q.sportHoursPerWeek = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__SelectedCh_1;
        Q.sportFiveHoursPlus = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__pl_1;
        
        Q.dancer = strcmp(dancer, 'Yes');
        Q.danceType = tbl.WhatTypeOfDanceTraining_experienceDoYouHave_E_g_StreetDanceLess;
        Q.danceAgeStart = tbl.AtWhatAgeDidYouFirstStartDanceTraining_;
        Q.danceYearsTraining = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__Select_2;
        Q.danceFiveYearsPlus = tbl.HowLongHaveYouBeenTraining_howMuchExperienceDoYouHave__5Years_2;
        Q.danceHoursPerWeek = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__SelectedCh_2;
        Q.danceFiveHoursPlus = tbl.HowManyHoursPerWeekOfThisActivityDoYouCurrentlyDo__5Hours__pl_2;
        
        Q.gamer = strcmp(gamer, 'Yes');
        Q.gamesType = tbl.WhatTypeOfGamingDoYouDo_E_g_PC_Console___;
        Q.gamesAgeStart = tbl.AtWhatAgeDidYouFirstStartGaming_;
        Q.gamerYearsTraining = tbl.HowMuchExperienceDoYouHave__SelectedChoice;
        Q.gamerFiveYearsPlus = tbl.HowMuchExperienceDoYouHave__5Years__pleaseSpecify__Text;
        Q.gamerHoursPerWeek = tbl.HowManyHoursOfGamingDoYouDoPerWeek__SelectedChoice;
        Q.gamerFiveHoursPlus = tbl.HowManyHoursOfGamingDoYouDoPerWeek__5_Hours_pleaseSpecify__Text;
        
        save('cqHC_questionnaire.mat','Q')
    case 'outliers'
        [A, ~] = CQHC_initCase(saveDir);
        
        %Plot number of erroneous presses (not trials) for each participant
        M=tapply(A,{'subjN'},{A.errorSum,'sum','name','pressError'},'subset',A.day==3&A.trialType==3&A.TN>21);
        
        figure;
        scatterplot(M.subjN,M.pressError,...
            'leg','auto')
        xlabel('Participant')
        ylabel('Number of erroneous presses')
        % ---------------------------------------------------------------- %
        
        % percentage of press errors for entire sequence trials
        nPressesTotal = length(A.RT(A.subjN == 1 & A.day == 3 & A.trialType==3&A.TN>21)) * 4; %total presses per subj
        M.percentage = (M.pressError / nPressesTotal) * 100; %convert n errors into percent
        
        figure;
        scatterplot(M.subjN,M.percentage,...
            'leg','fill')
        ylabel('Erroneous presses (%)');
        xlabel('Participant')
        drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        % ---------------------------------------------------------------- %
        
        % percentage of whole-trial errors
        T=tapply(A,{'subjN'},{A.errorTrial(:,1),'sum','name','errorTrialSum'},'subset',A.day==3&A.trialType==3&A.TN>21);
        
        nTrialsTotal = length(A.errorTrial(A.subjN == 1 & A.day==3&A.trialType==3&A.TN>21));
        T.percentage = (T.errorTrialSum / nTrialsTotal) * 100;
        
        figure;
        scatterplot(T.subjN,T.percentage,...
            'leg','auto')
        xlabel('Participant')
        ylabel('Percentage of erroneous trials')
        drawline(errorThreshold,'dir','horz','color',[0 0 0],'linestyle','-')
        % ---------------------------------------------------------------- %
        
        
        %identify participants with >20% error rate and mark for exclusion
        %in later cases
        A.outlierError = zeros(length(A.RT),1);
        highError = T.subjN(T.percentage > errorThreshold);
        lowError  = T.subjN(T.percentage < errorThreshold);
        A.outlierError(ismember(A.subjN, highError)) = 1;
        
        totSubj = length(highError) + length(lowError);
        percHighError = (length(highError) / totSubj) * 100;
        
        title(['Good participants: ' num2str(length(lowError)) ', bad participants: ' num2str(length(highError)) ', exclusion percentage: ' num2str(percHighError) '%'])
        
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
        
    case 'gradientRT' %plots probe RTs both raw and normalised to first position. Removes outliers.
        [A, ~] = CQHC_initCase(saveDir);%init
        
        %%%remove outliers and separate trials of interest into B struct
        fieldnames = fields(A);
        for i=1:numel(fieldnames)%for fieldnames
            B.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==2&A.points>0&A.day==3&A.TN>21&A.outlierError==0);
        end%for fieldnames
        
        B.outlier = NaN(length(B.RT), 1);
        for i=unique(B.subjN')
            B.outlier(B.subjN == i) = isoutlier(B.RT(B.subjN == i));
        end
        
        %Plot raw RT for each position in both used and unused probes
        R = tapply(B,{'probeTargetPos','subjN'},{B.RT(:,1),'nanmedian','name','probeRT'},'subset', B.points > 0);
        R.probeRT = R.probeRT * 1000; %convert to ms
        R.unusedProbeIdx = ones(length(R.probeRT),1);
        R.unusedProbeIdx(R.probeTargetPos > 4) = 2;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT)
        ylabel('Probe RT (ms)')
        xlabel('Probe position')
        % ---------------------------------------------------------------- %
        
        %Plot normalised RT to the first probe for all probes
        firstProbeRT = R.probeRT(R.probeTargetPos == 1);%gives first probe RT, ordered by subj
        loopCount = 1;%to count through firstProbeRT
        for i=1:max(R.probeTargetPos)%for each probe pos
            for j=unique(R.subjN')%for subj
                R.probeRT(R.probeTargetPos == i & R.subjN == j) = ...
                    R.probeRT(R.probeTargetPos == i & R.subjN == j) / firstProbeRT(loopCount) * 100;
                loopCount = loopCount + 1;
            end%for subj
            loopCount = 1;%reset for new probe pos
        end%for each probe pos
        R.probeRT = R.probeRT - 100;
        
        figure
        lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT)
        ylabel('Relative probe RT (%)')
        xlabel('Probe position')
        title(['N = ' num2str(length(unique(R.subjN)))])
        
        %test significance of CQ gradient (normalised to first probe)
        probeRT = NaN(length(R.probeRT(R.probeTargetPos == 1)), length(unique(R.probeTargetPos)'));
        t = NaN(length(unique(R.probeTargetPos)') - 1,1); p = NaN(length(unique(R.probeTargetPos)') - 1,1);
        for i = unique(R.probeTargetPos)'%for probes
            probeRT(:,i) = R.probeRT(R.probeTargetPos == i);
        end%for probes
        for i = 1:length(unique(R.probeTargetPos)') - 1%for diff between probes
            [t(i), p(i)] = ttest(probeRT(:,i),probeRT(:,i+1),2,'paired');
        end%for diff between probes
        
        p = p / 2; %convert to ONE-TAILED test (was annoying to code into the function directly)
        astXLoc = [1.35, 2.05, 2.75, 3.6, 4.45, 5.15, 5.85]; %x coordinates for the significance *s on plot
        astYLoc = [15,   20,   20,   25,  33,   30,   30];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
        
        %%%calculate relative RT differences (average difference between
        %%%adjacent probe positions, Mantziara et al (2021)
        relRTDiff = NaN(length(R.probeRT(R.probeTargetPos == 1)), 3);
        for i=1:3%for 
            relRTDiff(:,i) = R.probeRT(R.probeTargetPos == i+1) - R.probeRT(R.probeTargetPos == i);
        end
        relRTDiff = mean(relRTDiff, 2); 
        A.relRTDiff = NaN(length(A.subjID),1); loopCounter = 1;
        for i=unique(A.subjN(A.outlierError == 0))'
            A.relRTDiff(A.subjN == i, 1) = relRTDiff(loopCounter);
            loopCounter = loopCounter + 1;
        end
        
        filename='cqHC_dataAll';
        save(fullfile(saveDir, filename), 'A')
    case 'gradientPerformanceCorrelation'
        [A, ~] = CQHC_initCase(saveDir);%init
        
        R = tapply(A,{'subjN','relRTDiff'},{A.RT(:,1),'nanmedian','name','memoryRT'},'subset',...
            A.trialType==3&A.TN>21&A.outlierError==0);
        R.memoryRT = R.memoryRT * 1000; %convert from s to ms
        
        [r, p] = corrcoef(R.relRTDiff, R.memoryRT);
        figure
        scatterplot(R.memoryRT, R.relRTDiff, 'regression', 'linear')
        xlabel('Initiation RT(ms)')
        ylabel('Relative RT differences (%)')
        title(['N = ' num2str(length(R.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        % ---------------------------------------------------------------- %
        
        P = tapply(A,{'subjN','relRTDiff'},{A.RT(:,4),'nanmedian','name','memoryProd'},'subset',...
            A.trialType==3&A.TN>21&A.outlierError==0);
        P.memoryProd = P.memoryProd * 1000; %convert from s to ms
        
        [r, p] = corrcoef(P.relRTDiff, P.memoryProd);
        figure
        scatterplot(P.memoryProd, P.relRTDiff, 'regression', 'linear')
        xlabel('Total production time (ms)')
        ylabel('Relative RT differences (%)')
        title(['N = ' num2str(length(P.subjN)) ', r = ' num2str(r(2,1)) ', p = ' num2str(p(2,1))])
        
    case 'gradientRTBySubj'
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
    case 'gradientError'
        [A, subj] = CQHC_initCase(saveDir); %init
        
        A.errorTrial = any(A.error == 1,2); %trial = 1 when there's any error
        sCount = 1;
        posCount = 1;
        
        for i=subj'
            for j=unique(A.probeTargetPos(~isnan(A.probeTargetPos)))'
                ntrials(sCount, j) = length(A.errorTrial(A.subjID == subj(sCount) & A.probeTargetPos == j)); %ntrials
                errorSum(sCount, j) = sum(A.errorTrial(A.subjID == subj(sCount) & A.probeTargetPos == j)); %nerrors
                
                errorPerc(sCount, j) = (errorSum(sCount, j) / ntrials(sCount, j)) * 100; %percentage of errors
            end%for probe positions
            
            sCount = sCount + 1;
        end%for subjID
        
        R = tapply(A,{'probeTargetPos','subjID'},{A.RT(:,1),'mean','name','probeRT'},'subset',A.trialType == 2);
        
    case 'dayProgression'
        [A, ~] = CQHC_initCase(saveDir);
        
        R = tapply(A,{'day','subjN'},{A.RT(:,1),'nanmedian','name','memoryRT'},'subset', A.trialType == 3);
        R.memoryRT = R.memoryRT * 1000;
        
        figure
        lineplot(R.day, R.memoryRT)
        ylabel('RT (ms)')
        xlabel('Day')
        
        %test significance of RT between days
        for i = 1:length(unique(R.day)') - 1%for diff between days
            [t(i), p(i)] = ttest(R.memoryRT(R.day == i),R.memoryRT(R.day == i+1),2,'paired');
        end%for diff between days
        
        p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = [1.5, 2.5]; %x coordinates for the significance *s on plot
        astYLoc = [650, 550];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
        
        
        P = tapply(A,{'day','subjN'},{A.RT(:,4),'nanmedian','name','memoryRT'},'subset', A.trialType == 3);
        P.memoryRT = P.memoryRT * 1000;
        
        figure
        lineplot(P.day, P.memoryRT)
        ylabel('Total movement time (ms)')
        xlabel('Day')
        
        %test significance of move time between days
        for i = 1:length(unique(P.day)') - 1%for diff between days
            [t(i), p(i)] = ttest(P.memoryRT(R.day == i),P.memoryRT(R.day == i+1),2,'paired');
        end%for diff between days
        
        p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = [1.5,   2.5]; %x coordinates for the significance *s on plot
        astYLoc = [1500, 1300];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
    case 'sequenceDifferences'
        [A, ~] = CQHC_initCase(saveDir);%init
        
        R = tapply(A,{'fractal','seqSet','subjN'},{A.RT(:,1),'nanmedian','name','memoryRT'},'subset',...
            A.trialType==3&A.TN>21&A.outlierError==0);
        
        figure
        R.memoryRT = R.memoryRT * 1000; %ms conversion
        barplot([R.seqSet, R.fractal], R.memoryRT)
        ylabel('Reaction time (ms)')
        xlabel('Sequence set')
        
        %test significance of RT between seq sets
        for i = 1:length(unique(R.seqSet)') - 1%for diff between seq sets
            [t(i), p(i)] = ttest(R.memoryRT(R.seqSet == i),R.memoryRT(R.seqSet == i+1),2,'paired');
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = [2.75]; %x coordinates for the significance *s on plot
        astYLoc = [450 ];
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
        
        P = tapply(A,{'fractal','seqSet','subjN'},{A.RT(:,4),'nanmedian','name','memoryRT'},'subset',...
            A.trialType==3&A.TN>21&A.outlierError==0);
        
        figure
        P.memoryRT = P.memoryRT * 1000; %ms conversion
        barplot([P.seqSet, P.fractal], P.memoryRT)
        ylabel('Total movement time (ms)')
        xlabel('Sequence set')
        
        %test significance of RT between seq sets
        for i = 1:length(unique(P.seqSet)') - 1%for diff between seq sets
            [t(i), p(i)] = ttest(P.memoryRT(P.seqSet == i),P.memoryRT(P.seqSet == i+1),2,'paired');
        end%for diff between seq sets
        
        %p = p / 2; %convert to one-tailed test (was annoying to code into the function directly)
        astXLoc = 2.75; %x coordinates for the significance *s on plot
        astYLoc = 1250;
        %display asterisks between sig results
        text(astXLoc(p < .05),astYLoc(p < .05),'*','fontSize',20);
        disp(p)
        % ---------------------------------------------------------------- %
        
        
    case 'plot'  %% Extract RT, errors per condition and plot
        [A, ~] = CQHC_initCase(saveDir);
        
        %Raincloud plot
        colPos=[0.5 0.8 0.9; 1 0.7 1; 0.7 0.8 0.9; 0.8 0.5 0.4];
        
        %         fig_position = [200 200 600 400]; % coordinates for figures
        figure;
        
        for i=1:4%for probe position
            RTpos=A.RT(A.trialType==2 & A.points>0 & A.TN>20 & A.probeTargetPos==i | A.probeTargetPos==i+4);
            subplot(1,4,i);
            raincloud_plot(RTpos,'color',colPos(i,:));
            camroll(+90)
            xlim([0.3 1]);
            title(['ProbePos' num2str(i)]);
            %             ax = gca;
        end%for probe position
        
        clear RTpos
        
        figure;
        
        for i=1:length(A.RT(:,1))
            A.colwonk(i) = issorted(A.RT(i,:));
        end
        A.colwonk = A.colwonk';
        
        for i=1:4%for probe position
            RTpos=A.RT(A.trialType==2 & A.points>0,i);% & A.day == 3);% & A.colwonk == 1, i);
            RTpos=A.RT(A.trialType==1 & A.points>0,i);% & A.day == 3);% & A.colwonk == 1, i);
            
            
            raincloud_plot(RTpos,'color',colPos(i,:));
            %             ax = gca;
            
            %xlim([0 3]);
            %             ylim([-3 8]);
            camroll(+90)
            title('Sequence Timing');
            hold on;
            
        end%for probe position
        
        ylim([-4 8]);
        
    case 'stats'  %% Basic stats
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
        
    case 'demographicOverview'
        [Q, ~] = CQHC_initCaseDemographic(saveDir);
        
        nMusical = sum(Q.musical); nSporty = sum(Q.sporty); nDancer = sum(Q.dancer); nGamer = sum(Q.gamer);
        nTotal = length(Q.subjID);
        
        N.experience = [nMusical; nSporty; nDancer; nGamer];
        N.expCategories(:,1) = 1:4; %1 = musical, 2 = sporty, 3 = dancer, 4 = gamer
        N.experiencePerc = (N.experience ./ nTotal) * 100;
        
        N.experienceRows = [Q.musical Q.sporty Q.dancer Q.gamer];
        
        nTalents = sum(N.experienceRows, 2);
        nMultiTalent = sum(nTalents > 1);
        talentCategories = 0:4; %according to how many talents each person has (0:4)
        talentCounts = NaN(1,length(talentCategories));
        
        for i=1:length(talentCategories)
            talentCounts(i) = sum(nTalents == talentCategories(i));
        end
        
        %---- plot proportion of talent numbers in bar chart ----%
        figure
        talentPercs = round((talentCounts ./ sum(talentCounts)) * 100);
        labels = sprintfc('%d',talentCategories);
        talentPercsLabels = strcat(sprintfc('%d',talentPercs), '%'); labels = categorical(labels);
        % pie(talentCounts, labels)
        bar(labels, talentCounts)
        text(1:length(labels),talentCounts,talentPercsLabels,'vert','bottom','horiz','center')
        ylim([-1, 20])
        set(gca, 'box', 'off')
        
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
        
end