function bimanualCQHC_ana(which) %wrapper code
% Imports raw data, saves relevant data in a structure, plots individual and
% group data, and does basics stats
%
% Foundation written by K. Kornysheva, September 2021
% Adjusted and expanded by R. Yewbrey, October 2022

% Paths to toolboxes and experimental code
%
%%%% CHBH RY PC
% addpath(genpath('Z:\toolboxes\userfun'));%Joern Diedrichsen's util toolbox
% addpath(genpath('Z:\toolboxes\RainCloudPlots-master')); %raincloud plot toolbox
% addpath(genpath('C:\Users\yewbreyr\OneDrive\Documents\University\PhD\3rd Year\bimanualCQ_HC\CQHC\matlab'));%experimental code
% 
%%%% Home RY PC
% addpath(genpath('E:\projects\toolboxes'));%toolboxes
% addpath(genpath('C:\Users\bugsy\OneDrive\Documents\University\PhD\3rd Year\bimanualCQ_HC\CQHC\matlab'));%experimental code

%%%% CHBH RY PC
% baseDir= 'C:\Users\yewbreyr\OneDrive\Documents\University\PhD\3rd Year\bimanualCQ_HC';

%%%% Home RY PC
baseDir= 'C:\Users\bugsy\OneDrive\Documents\University\PhD\3rd Year\bimanualCQ_HC';

%Directory where psychoPy saves to
rawDir= [baseDir '\bimanualCQ_HC\data'];

%Directory where processed data should be saved
saveDir= [baseDir '\CQHC\data'];

%Name of psychoPy excel data files, subj x day matrix. Keep neat for your own sake
rawFileName={...
    '27127_bimanualCQ_HC_2022-09-23_15h26.34.409.csv','27127_bimanualCQ_HC_2022-09-24_15h50.41.000.csv','27127_bimanualCQ_HC_2022-09-25_21h49.16.770.csv';...
    '27150_bimanualCQ_HC_2022-11-17_13h48.50.509.csv','27150_bimanualCQ_HC_2022-11-18_15h36.12.882.csv','27150_bimanualCQ_HC_2022-11-19_18h32.07.965.csv';
    '27152_bimanualCQ_HC_2022-09-25_15h24.49.561.csv','27152_bimanualCQ_HC_2022-09-26_18h38.15.499.csv','27152_bimanualCQ_HC_2022-09-27_18h08.34.785.csv';...
    '27169_bimanualCQ_HC_2022-11-17_22h56.12.160.csv','27169_bimanualCQ_HC_2022-11-19_00h27.45.135.csv','27169_bimanualCQ_HC_2022-11-20_00h08.51.922.csv';...
    '27184_bimanualCQ_HC_2022-11-10_17h56.03.205.csv','27184_bimanualCQ_HC_2022-11-11_19h05.28.538.csv','27184_bimanualCQ_HC_2022-11-12_18h44.13.237.csv';...
    '27192_bimanualCQ_HC_2022-11-17_13h26.03.074.csv','27192_bimanualCQ_HC_2022-11-18_15h40.07.718.csv','27192_bimanualCQ_HC_2022-11-19_14h58.08.968.csv';...
    '27205_bimanualCQ_HC_2022-09-24_16h19.12.889.csv','27205_bimanualCQ_HC_2022-09-25_16h17.26.471.csv','27205_bimanualCQ_HC_2022-09-26_16h28.52.077.csv';...
    '27208_bimanualCQ_HC_2022-11-11_12h36.38.516.csv','27208_bimanualCQ_HC_2022-11-12_14h21.18.666.csv','27208_bimanualCQ_HC_2022-11-13_16h22.23.437.csv';...
    '27251_bimanualCQ_HC_2022-11-17_18h23.45.715.csv','27251_bimanualCQ_HC_2022-11-18_21h11.10.341.csv','27251_bimanualCQ_HC_2022-11-19_20h27.52.639.csv';...
    '27265_bimanualCQ_HC_2022-11-11_19h47.09.501.csv','27265_bimanualCQ_HC_2022-11-12_19h27.35.092.csv','27265_bimanualCQ_HC_2022-11-13_19h13.08.695.csv';...
    '27645_bimanualCQ_HC_2022-11-17_13h55.40.948.csv','27645_bimanualCQ_HC_2022-11-18_17h47.31.406.csv','27645_bimanualCQ_HC_2022-11-19_17h37.26.565.csv';...
    '27652_bimanualCQ_HC_2022-11-15_11h47.20.001.csv','27652_bimanualCQ_HC_2022-11-16_15h03.04.948.csv','27652_bimanualCQ_HC_2022-11-17_14h34.26.494.csv'...
    };
%Analysis Cases - switch as function input
switch which
    case 'loadData' %% Import files from .csv to .mat
        cd(rawDir);
        A=[]; %structure across subj
        S=[]; %structure across days
        
        for subj=1:size(rawFileName,1) %subj loop
            for day=1:size(rawFileName,2) %day loop
                disp([rawFileName{subj, day} ' in progress..']);
                
                D = bimanualCQHC_importFile(rawFileName{subj,day}); % imports data from raw, puts it into a structure array
                D.TN= (1:size(D.RT,1))';
                
                disp([rawFileName{subj, day} 'done.']);
                S=addstruct(S,D); %within subj
                clear D;
            end%for day
            A=addstruct(A,S); %within subj
            S=[];
        end%for subj
        filename='cqPD_dataAll';
        save([saveDir '\' filename], 'A')
        
    case 'gradient_RT'
        [A, subj] = CQHC_initCase(saveDir);
        
        %remove outliers
        %         for i = unique(A.subjID)'
        %             A.RT(A.trialType == 2 & A.subjID == 27127) = rmoutliers(A.RT(A.trialType == 2 & A.subjID == 27127));
        %         end
        
        R = tapply(A,{'probeTargetPos','subjID'},{A.RT(:,1),'mean','name','probeRT'},'subset',A.trialType == 2);
        R.unusedProbeIdx = [1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2;];
        
        figure
        %         lineplot([R.unusedProbeIdx, R.probeTargetPos], R.probeRT)
        lineplot([R.probeTargetPos], R.probeRT)
        
    case 'gradient_error'
        [A, subj] = CQHC_initCase(saveDir); %#ok<*ASGLU>
        
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
        
        
        
        
        
    case 'plot'  %% Extract RT, errors per condition and plot
        [A, subj] = CQHC_initCase(saveDir);
        
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
        
        for i=1:4%for probe position
            RTpos=A.RT(A.trialType==2 & A.points>0 & A.TN>20, i);
            RTpos=A.RT(A.trialType==1 & A.points>0 , i);
            
            
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
        
        B = structfun(@(X) X(A.trialType == 3 & A.day == 'day3' & A.points >= 1,:), A, 'Uni', false);
        
        for i=subj'%for each subj
            for j=1:length(B.RT(1,:))%for each press col
                
                %get an index of all outliers in each column of RT for each participant
                [~, outlierIdx(:,j)] = rmoutliers(B.RT(B.subjID == i,j));
                
            end%for each press col
            
            outlierIdx = sum(outlierIdx,2); %if there's any outliers across all 4 columns...
            B = structfun(@(X) X(outlierIdx <=1,:), B, 'Uni', false); %remove entire trial
        end%for each subj
        
        RFirst = tapply(A,{'subjID'},{A.RT(:,1),'nanmean','name','moveTime'},'subset',A.trialType == 3 & A.day == 'day3');
        R  = tapply(A,{'subjID'},{A.RT(:,4),'nanmean','name','moveTime'},'subset',A.trialType == 3 & A.day == 'day3');
        
        R.moveTime = R.moveTime - RFirst.moveTime;
end