function D=cqDyspraxia_importFile(fileIn)

%% Import data from text file
%
% filename: /Users/katjakornysheva/Dropbox/SAMlab/projects/cqPD/data/pilot/yqh88_behaviouralCQ_2021-09-06_11h22.43.125.csv


%% Set up the Import Options and import the data
%opts = delimitedTextImportOptions("NumVariables", 87);
% opts = delimitedTextImportOptions("NumVariables", 100);
% 
% % Specify range and delimiter
% opts.DataLines = [2, Inf];
% opts.Delimiter = ",";
% 
% % Specify column names and types
% opts.VariableNames = ["setUpTrialsthisRepN", "setUpTrialsthisTrialN", "setUpTrialsthisN", "setUpTrialsthisIndex", "setUpTrialsran", "breakBlock", "trialType", "RepA", "RepB", "RepC", "condFile", "fractalIm", "participant", "day", "date1", "expName", "psychopyVersion", "OS", "frameRate", "setUpBlocksthisRepN", "setUpBlocksthisTrialN", "setUpBlocksthisN", "setUpBlocksthisIndex", "setUpBlocksran", "condFiles", "startMsg", "setUpDaysthisRepN", "setUpDaysthisTrialN", "setUpDaysthisN", "setUpDaysthisIndex", "setUpDaysran", "thisDay", "startPresskeys", "startPressrt", "startKeykeys", "startKeyrt", "endBreakkeys", "prematureResponseskeys", "key_respBkeys", "key_respBcorr", "key_respBrt", "pointCount", "fingerSequenceBthisRepN", "fingerSequenceBthisTrialN", "fingerSequenceBthisN", "fingerSequenceBthisIndex", "fingerSequenceBran", "thisImage", "corAns", "Finger", "Digit", "respList", "corAnsList", "iconList", "RTs", "targetIntervals", "deviations", "deviationsTxt", "percentAbsDeviations", "yList", "finalPoints", "Digits", "Fingers", "thisSound", "correct", "trialsthisRepN", "trialsthisTrialN", "trialsthisN", "trialsthisIndex", "trialsran", "probeRespkeys", "probeRespcorr", "probeResprt", "mapping", "probeSelectthisRepN", "probeSelectthisTrialN", "probeSelectthisN", "probeSelectthisIndex", "probeSelectran", "Fractal_1_mapping", "Fractal_8_mapping", "daythisRepN", "daythisTrialN", "daythisN", "daythisIndex", "dayran", "cummulativeScore"];
% opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "categorical", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "char", "char", "char", "char", "char", "char"];
% 
% % Specify file level properties
% opts.ExtraColumnsRule = "ignore";
% opts.EmptyLineRule = "read";
% 
% % Specify variable properties
% opts = setvaropts(opts, ["startMsg", "setUpDaysthisRepN", "setUpDaysthisTrialN", "setUpDaysthisN", "setUpDaysthisIndex", "setUpDaysran", "thisDay", "startPresskeys", "startPressrt", "startKeykeys", "startKeyrt", "endBreakkeys", "prematureResponseskeys", "key_respBkeys", "key_respBcorr", "key_respBrt", "pointCount", "fingerSequenceBthisRepN", "fingerSequenceBthisTrialN", "fingerSequenceBthisN", "fingerSequenceBthisIndex", "fingerSequenceBran", "thisImage", "corAns", "Finger", "Digit", "respList", "corAnsList", "iconList", "RTs", "targetIntervals", "deviations", "deviationsTxt", "percentAbsDeviations", "yList", "finalPoints", "Digits", "Fingers", "thisSound", "correct", "trialsthisRepN", "trialsthisTrialN", "trialsthisN", "trialsthisIndex", "trialsran", "probeRespkeys", "probeRespcorr", "probeResprt", "mapping", "probeSelectthisRepN", "probeSelectthisTrialN", "probeSelectthisN", "probeSelectthisIndex", "probeSelectran", "daythisRepN", "daythisTrialN", "daythisN", "daythisIndex", "dayran", "cummulativeScore"], "WhitespaceRule", "preserve");
% opts = setvaropts(opts, ["trialType", "date1", "expName", "psychopyVersion", "startMsg", "setUpDaysthisRepN", "setUpDaysthisTrialN", "setUpDaysthisN", "setUpDaysthisIndex", "setUpDaysran", "thisDay", "startPresskeys", "startPressrt", "startKeykeys", "startKeyrt", "endBreakkeys", "prematureResponseskeys", "key_respBkeys", "key_respBcorr", "key_respBrt", "pointCount", "fingerSequenceBthisRepN", "fingerSequenceBthisTrialN", "fingerSequenceBthisN", "fingerSequenceBthisIndex", "fingerSequenceBran", "thisImage", "corAns", "Finger", "Digit", "respList", "corAnsList", "iconList", "RTs", "targetIntervals", "deviations", "deviationsTxt", "percentAbsDeviations", "yList", "finalPoints", "Digits", "Fingers", "thisSound", "correct", "trialsthisRepN", "trialsthisTrialN", "trialsthisN", "trialsthisIndex", "trialsran", "probeRespkeys", "probeRespcorr", "probeResprt", "mapping", "probeSelectthisRepN", "probeSelectthisTrialN", "probeSelectthisN", "probeSelectthisIndex", "probeSelectran", "daythisRepN", "daythisTrialN", "daythisN", "daythisIndex", "dayran", "cummulativeScore"], "EmptyFieldRule", "auto");
% opts = setvaropts(opts, ["condFile", "fractalIm", "participant", "day", "OS", "condFiles", "Fractal_1_mapping", "Fractal_8_mapping"], "TrimNonNumeric", true);
% opts = setvaropts(opts, ["condFile", "fractalIm", "participant", "day", "OS", "condFiles", "Fractal_1_mapping", "Fractal_8_mapping"], "ThousandsSeparator", ",");

%% Import the data
% tbl = readtable(fileIn);

% tbl = readtable(fileIn, ...
%     'Range','A:Z',...
%     'ReadVariableNames', True);

opts = detectImportOptions(fileIn);
opts.SelectedVariableNames =([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 ...
    31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55:92]);
% opts.SelectedVariableNames = {'setUpTrials.thisTrialN','setUpTrials.thisN','setUpTrials.thisIndex','setUpTrials.ran','breakBlock','trialType','RepA','RepB','RepC','condFile','fractalIm','sequence','participant','day','date','expName','psychopyVersion','OS','frameRate','setUpBlocks.thisRepN','setUpBlocks.thisTrialN','setUpBlocks.thisN','setUpBlocks.thisIndex','setUpBlocks.ran','condFiles','startImage','setUpDays.thisRepN','setUpDays.thisTrialN','setUpDays.thisN','setUpDays.thisIndex','setUpDays.ran','thisDay','startPress.keys','startPress.rt','startKey.keys','startKey.rt','endBreak.keys','prematureResponses.keys','probeResp.keys','probeResp.corr','probeResp.rt','probeSelect.thisRepN','probeSelect.thisTrialN','probeSelect.thisN','probeSelect.thisIndex','probeSelect.ran','thisImage','corAns','Finger','Digit','Fractal_9_mapping','Fractal_10_mapping','motor_times_relative_to_go','stim_times_relative_to_go','respList','corAnsList','iconList','trialType_',',routine_times','motor_times_global_monotonic','stim_times_global_monotonic','RTs','targetIntervals','deviations','deviationsTxt','percentAbsDeviations','yList','finalPoints','Digits','Fingers','thisSound','correct','trials.thisRepN','trials.thisTrialN','trials.thisN','trials.thisIndex','trials.ran','key_respB.keys','key_respB.corr','fingerSequenceB.thisRepN','fingerSequenceB.thisTrialN','fingerSequenceB.thisN','fingerSequenceB.thisIndex','fingerSequenceB.ran','key_respB.rt','day.thisRepN','day.thisTrialN','day.thisN','day.thisIndex','day.ran','cummulativeScore'};
% 'setUpTrials.thisRepN'
% opts.SelectedVariableNames =([1:92]);
opts.ExtraColumnsRule = "ignore";
tbl = readtable(fileIn, opts);

%% Convert to output type
%data info
participant = tbl.participant;
day = tbl.day;
date = tbl.date;

%conditions
trialType = grp2idx(tbl.trialType); %1: InstructedB; 2: Probe; 3: Memory 
fractal = grp2idx(tbl.fractalIm); % 1: fractal_9, 2: Fractal_10
%probeTargetDigit=tbl.probeRespcorr; %% NOTE: this data is offset by one row!!!
% probeTargetPos=tbl.mapping; %% NOTE: this data is offset by one row!!!
%
probeTargetPos=cell(length(tbl.Fractal_9_mapping),1);

for i=1:length(tbl.Fractal_9_mapping)
    if i==1
        continue
    elseif strcmp(tbl.fractalIm{i}, 'Fractals/Fractal_9.png')
        probeTargetPos{i}=tbl.Fractal_9_mapping{i-1};
    elseif strcmp(tbl.fractalIm{i}, 'Fractals/Fractal_10.png')
        probeTargetPos{i}=tbl.Fractal_10_mapping{i-1};
    else
        probeTargetPos{i}=[];
    end
end



%response data
RTs = tbl.RTs;
Digits = tbl.Digits;
yList = tbl.yList;
points=tbl.finalPoints;
%respList=grp2idx(tbl.respList);
respList=tbl.respList;


%% Clear temporary variables
%clear opts tbl

%% Write into the output structure D
maxpress=4;
D.subjID=cell(size(day,1),1);
D.day=cell(size(day,1),1);
% D.date=nan(size(RTs,1),1);
D.trialType=nan(size(day,1),1);
D.fractal=nan(size(day,1),1);
D.RT=nan(size(day,1),maxpress);
D.press=nan(size(day,1),maxpress);
D.error=nan(size(day,1),maxpress);
%D.probeTargetDigit=nan(size(day,1),1);
%D.probeTargetPos=zeros(size(day,1),1);
D.probeTargetPos =nan(size(day,1),1);
D.points=nan(size(day,1),1);
D.response=cell(size(day,1),maxpress);

for i=1:size(D.RT,1) %loop over trials
    
    
    %rowEmpty=isempty(str2num(points(i,1))); % trial data
    if isnan(points{i,1}) == 0 %if not empty (filled with values or characters)    
        %Write out:
%         disp(i);
        D.subjID{i}= convertCharsToStrings(participant{i});
        D.day{i}= convertCharsToStrings(day{i});
        %D.date=date1(i);
        D.trialType(i,:)=trialType(i);
        D.fractal(i,:)=fractal(i);
        D.points(i,1)=str2double(points{i});
        
        if D.trialType(i,:) == 2
            D.probeTargetPos(i,1)=str2double(probeTargetPos{i});
            %         D.probeTargetPos= [D.probeTargetPos probeTargetPos(i,1)];
        else
            D.probeTargetPos(i,1) = 0;
        end
%         D.response{i}=str2num(respList{i,1});
        

        %Write out data values from strings for vectors of different length 
        try %sequence
            D.RT(i,:)=str2num(RTs{i,1});
            D.press(i,:)=str2num(Digits{i,1});
            D.error(i,:)=str2num(yList{i,1});
            %D.probeTargetPos(i,1)=str2num(probeTargetPos{i,1}); %NOTE: this data is offset by one row!!!
            D.response(i,:)=cellstr(str2double(respList{i,1}));
%             D.response(i,:)=strsplit(respList{i,1});
%               D.response(i,:)=~cellfun(@isempty, respList{i,1});  
%               D.response(i,:)=cellfun(@(respList) respList(i,1),str,'UniformOutput',false);
%             ~cellfun(@isempty, D.day(:,1)), :);
            
        catch % < 4 presses or single press
            D.RT(i,1:numel(str2num(RTs{i,1})))=str2num(RTs{i,1});
            D.press(i,1:numel(str2num(Digits{i,1})))=str2num(Digits{i,1});
%             D.probeTargetPos(i)=probeTargetPos{i-1};
            
           
            try %if there's no response to the trial, the below will error...
                D.response(i,1:numel(cellstr(str2num(respList{i,1}))))=cellstr(str2num(respList{i,1}));
                
%                 D.response(i,1:numel(str2num(respList{i,1})))=str2num(respList{i,1});
%                  D.RT(i,1:nume1(RTs(i,1)))=str2double(RTs(i,1));
            catch %so fill with NaNs
                D.response{i,1} = NaN;
%                 D.RT(i,:) = NaN;
               
                    
             
                    
           
            end
%             for j=1:4  
            D.error(i,1:numel(str2num(yList{i,1})))=str2num(yList{i,1});
            %D.probeTargetPos(i,1)=NaN; %if no value, write out NaN
            
             
%             D.RT(i,j) = NaN; %if no value, write out NaN
%            end
%          for j=size(D.response,1)
%         if D.response(j,1) == 
%             D.RT(j,:) = NaN;
%         end
%          end
%     else %if no trial data
%       D.RT(i,1)  = NaN;
        end
    end  
end

%% Clean-up:
%%% Remove rows without trial response data

D.day = [D.day{:}]';
D.subjID = [D.subjID{:}]';


numrow=(isnan(D.points)); %1: no trial data; 0: trial data

D.subjID = D.subjID(~cellfun(@isempty, D.subjID(:,1)), :);
D.day = D.day(~cellfun(@isempty, D.day(:,1)), :);
D.trialType(numrow==1,:)=[];
D.fractal(numrow==1,:)=[];
D.RT(numrow==1,:)=[];
D.press(numrow==1,:)=[];
D.response(numrow==1,:)=[];
D.error(numrow==1,:)=[];
D.points(numrow==1,:)=[];
%D.probeTargetDigit(numrow==1,:)=[];
D.probeTargetPos(numrow==1,:)=[];


for i=1:length(D.day)
    D.day(i)=sscanf(D.day(i),'%*[^0123456789]%f');
end
D.day=str2double(D.day); 




%% Remove copies of 1st press is col 2-4 (Probe trials)
cond=2;

% D.RT(D.day=='day2'&D.trialType==2,2:4)=NaN;


D.RT(D.trialType==cond,2:4)=NaN;
D.press(D.trialType==cond,2:4)=NaN;
D.error(D.trialType==cond,2:4)=NaN;
% D.response(cellfun(@isempty(D.trialType==cond,2:4))=NaN;



        
% Determine the target sequence 
% cond=1;
% correctSeq1=D.press(D.trialType==cond&D.fractal==1 & D.points>0,:);
% correctSeq2=D.press(D.trialType==cond&D.fractal==2 & D.points>0,:);
% seq1=correctSeq1(1,:);
% seq2=correctSeq2(1,:);
% D.targetSeq=nan(size(D.RT,1),4);
% D.targetSeq(D.fractal==1,:)=repmat(seq1, size(D.targetSeq(D.fractal==1,:),1),1);
% D.targetSeq(D.fractal==2,:)=repmat(seq2, size(D.targetSeq(D.fractal==2,:),1),1);

% Determine the first key press 

D.firstKeyRT=D.RT(:,1);

% Determine the second key press

D.secondKeyRT=D.RT(:,2);

%Determine the third key press

D.thirdKeyRT=D.RT(:,3);

%  Determine the last key press

D.lastKeyRT=D.RT(:,4);

% Determine the RT for the probe trials

% D.ProbeRT=D.firstKeyRT(D.trialType==3);

% Determine the sequence production for all trials

D.seqProd=D.lastKeyRT-D.firstKeyRT;

% Find the RT of only memory trials

D.memRT=D.RT(D.trialType==2,:);

% Find the mean RT for memory trials of each block for day 1

%D.blockMeansDay1 = mean(reshape(D.memRT(:,1), 8, size(D.memRT, 1)/8))';

% gets rid of all the NaN's from D.probeTargetPos

B = isnan(D.probeTargetPos);
D.probeTargetPosition = D.probeTargetPos(~B);

% C = isnan(D.ProbeRT);
% D.ProbeRT = D.ProbeRT(~C);


for t = 1:size(D.response,1)
if  isempty(D.response{t,1}) == 0
    try
        for i = 1:maxpress
        D.response(t,i) = replace(D.response(t,i), 'y','1');
        D.response(t,i) = replace(D.response(t,i), 'u','2');
        D.response(t,i) = replace(D.response(t,i), 'i','3');
        D.response(t,i) = replace(D.response(t,i), 'l','4');
        end
    catch
        D.response{t,i}  = [];
    end
 end 
end

matrix = zeros(length(D.response), maxpress);

for x = 1:length(matrix(:,1))
    for y = 1:length(matrix(1,:))
        if isempty(D.response{x,y}) == 1
            matrix(x,y) = NaN;
         
        %disp(class(D.response{x,y}))
        %matrix(x,y) = str2num(convertCharsToStrings(D.response{x,y}))
        else 
            matrix(x,y) = str2num(convertCharsToStrings(D.response{x,y}));
        end
    end
end 

% D.RT(isnan(matrix)) = NaN;

D.response = matrix;
        

% Compare the responses and target responses to get the errors. 1=correct,
% 2=error

% calculates the error and gets rid of the NaN trials
D.Error = D.response==D.press;
D.Error=double(D.Error);
% D.Error(D.trialType==2,:)=NaN;


% change 0 to 1 & 1 to 0 for Errors



% D.Error = ~D.Error;
D.Error = double(D.Error);
D.Error(D.trialType==2, 2:4) = 1;
% %calculates whether a trial or correct or not
% n = length(A.TN)
% incorrect = sum(D.Error(1:n));
D.ErrorTrial = zeros(length(D.Error),1);
 for j = 1:length(D.Error)
%      disp(sum(D.Error(j,:)))
     if sum(D.Error(j,:)) == 4
%          disp("This is a 1")
         D.ErrorTrial(j,:) = 1;
     
     elseif sum(D.Error(j,:)) ~= 4
%          disp("This is a 0")
         D.ErrorTrial(j,:) = 0;
     else
%          disp("NAN")
D.ErrorTrial(j,:) = NaN;
     end
 end

 
 % Find the probe error
 
% D.probeError = D.Error(D.trialType==2);
% %  D.ErrorTrial = D.ErrorTrial(D.trialType==3);
% 
% %Percentage of error trials for each day
% 
%    day1Error = sum((D.ErrorTrial(D.day=='day1'&D.trialType==3)/32)*100); 
%    day2Error = sum((D.ErrorTrial(D.day=='day2'&D.trialType==3)/160)*100); 
%    day3Error = sum((D.ErrorTrial(D.day=='day3'&D.trialType==3)/120)*100);
%    D.percentErrorday = [day1Error; day2Error; day3Error];
   
% check which group they are in
% assign whether 1 = dyspraxia, 0 = control

% D.FirsttargetSeq = D.targetSeq(:,1);


