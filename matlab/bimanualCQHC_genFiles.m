function bimanualCQ_genFiles(subj)

%%% Home Paths
% addpath(genpath('C:\Users\bugsy\OneDrive\Documents\University\PhD\3rd Year\PD Online Study\cqPD\matlab')) %paths to add, Rhys' oneDrive
% addpath(genpath('E:\projects\toolboxes'))

%%% CHBH Paths
% addpath(genpath('C:\Users\yewbreyr\OneDrive\Documents\University\PhD\3rd Year\bimanualCQ_HC\CQHC\matlab'))
% addpath(genpath('Z:\toolboxes'))

subjFolderName={'s01','s02','s03','s04','s05','s06','s07','s08','s09','s10',...
    's11','s12','s13','s14','s15','s16','s17','s18','s19','s20','s21','s22','s23',...
    's24','s25','s26','s27','s28','s29','s30','s31','s32','s33','s34','s35','s36',...
    's37','s38','s39','s40','s41','s42','s43','s44','s45','s46','s47','s48','s49',...
    's50','s51','s52','s53','s54','s55','s56','s57','s58','s59','s60'};

%%% Adjust baseDir to personal use
% baseDir='C:\projects\rhys\prepProd2\data\behavioural'; %Rhys home PC
% baseDir='C:\Users\bugsy\OneDrive\Documents\University\PhD\3rd Year\PD Online Study\cqPD\data'; %Rhys oneDrive
% baseDir='C:\documents'; % Rhys CHBH PC, save to local hard drive
baseDir='C:\Users\yewbreyr\OneDrive\Documents\University\PhD\3rd Year\bimanualCQ_HC\CQHC\files'; %Rhys oneDrive CHBH PC

subjSaveFolder=fullfile(baseDir,subjFolderName{subj});

if ~isfolder(subjSaveFolder)
    mkdir(subjSaveFolder);
end

cd(subjSaveFolder);

% define the names of all files to be generated
fileNamesA = {'A_trials1', 'A_trials2', 'A_trials3', 'A_trials4', 'A_trials5', 'A_trials6', 'A_trials7', 'A_trials8'};
fileNamesB = {'B_trials1', 'B_trials2', 'B_trials3', 'B_trials4', 'B_trials5', 'B_trials6', 'B_trials7', 'B_trials8'};
fileNamesC = {'C_trials1', 'C_trials2', 'C_trials3', 'C_trials4', 'C_trials5', 'C_trials6', 'C_trials7', 'C_trials8'};
fileNamesTest = {'Test_trials1', 'Test_trials2', 'Test_trials3', 'Test_trials4', 'Test_trials5', 'Test_trials6',...
    'Test_trials7', 'Test_trials8', 'Test_trials9', 'Test_trials10', 'Test_trials11', 'Test_trials12'};

% define header row for each condition file
fileHeader = {'breakBlock','trialType','RepA','RepB','RepC','condFile','fractalIm'};

% put together the excel sheet rows required for each sequence condition
instructedSequences = {...
    0, 'InstructedB',0,1,0,['orders/conditionsFiles/instructed/' subjFolderName{subj} '/Order1.xlsx'],'Fractals/Fractal_1.png';...
    0, 'InstructedB',0,1,0,['orders/conditionsFiles/instructed/' subjFolderName{subj} '/Order2.xlsx'],'Fractals/Fractal_8.png'};

memorySequences = {...
    0, 'MemoryB',0,1,0,['orders/conditionsFiles/memory/' subjFolderName{subj} '/Order1.xlsx'],'Fractals/Fractal_1.png';...
    0, 'MemoryB',0,1,0,['orders/conditionsFiles/memory/' subjFolderName{subj} '/Order2.xlsx'],'Fractals/Fractal_8.png'};

% same as above for probe conditions...
probes = {...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/index.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/middle.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/ring.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/pinkie.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/index_left.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/middle_left.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/ring_left.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/pinkie_left.xlsx'],'Fractals/Fractal_8.png'};

% and for probes of the hand that is not used to produce the cued sequence
probesUnused = {...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/index.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/middle.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/ring.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/pinkie.xlsx'],'Fractals/Fractal_8.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/index_left.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/middle_left.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/ring_left.xlsx'],'Fractals/Fractal_1.png';...
    0, 'Probe',0,0,1, ['orders/conditionsFiles/probe/' subjFolderName{subj} '/pinkie_left.xlsx'],'Fractals/Fractal_1.png'};

nBlocksA = numel(fileNamesA);
nBlocksB = numel(fileNamesB);
nBlocksC = numel(fileNamesC);
nBlocksTest = numel(fileNamesTest);


%% A_trialsX
for i=1:nBlocksA
    % to make flexible eventually
    nProd = 16;
    nProbes = 4;
    nUnused = 1;
    
    % production trials
    sequenceA = repmat(instructedSequences(1,:),(nProd/2),1);
    sequenceB = repmat(instructedSequences(2,:),(nProd/2),1);
    prodTrials = [sequenceA; sequenceB];
    
    if i == 1
        % probe trials
        probeSeq1 = 1:4;
        probeSeq2 = 5:8;
        a = 0;
        
        while a == 0 %make sure there are no repeats of probes within blocks
            probeIndex = [...
                Shuffle(probeSeq1), Shuffle(probeSeq1);...
                Shuffle(probeSeq1), Shuffle(probeSeq1);...
                Shuffle(probeSeq2), Shuffle(probeSeq2);...
                Shuffle(probeSeq2), Shuffle(probeSeq2)];
            
            repeats = probeIndex(1,:) == probeIndex(2,:);
            repeats2 = probeIndex(3,:) == probeIndex(4,:);
            
            if any(repeats) || any(repeats2)
                a = 0;
            else
                a = 1;
            end
        end
    end
    probeTrials = probes(probeIndex(:,i),:);
    
    % probes of the unused hand
    if i == 1
        unusedIndex = Shuffle(1:8);
    end
    unusedTrials = probesUnused(unusedIndex(:,i),:);
    
    % assemble full data structure for block
    trialStruct = [fileHeader; prodTrials; probeTrials; unusedTrials];
    
    % write to excel file
    writecell(trialStruct,[fileNamesA{i}, '.xlsx'])
end

%% B_trialsX
for i=1:nBlocksB
    % to make flexible eventually
    nInstructed = 8;
    nMemory = 8;
    nProbes = 4;
    nUnused = 1;
    
    % instructed production trials
    sequenceA = repmat(instructedSequences(1,:),(nInstructed/2),1);
    sequenceB = repmat(instructedSequences(2,:),(nInstructed/2),1);
    instructedTrials = [sequenceA; sequenceB];
    
    % memory production trials
    sequenceA = repmat(memorySequences(1,:),(nMemory/2),1);
    sequenceB = repmat(memorySequences(2,:),(nMemory/2),1);
    memoryTrials = [sequenceA; sequenceB];
    
    % concatenate instructed and memory trials
    prodTrials = [instructedTrials; memoryTrials];
    
    if i == 1
        % probe trials
        probeSeq1 = 1:4;
        probeSeq2 = 5:8;
        a = 0;
        
        while a == 0 %make sure there are no repeats of probes within blocks
            probeIndex = [...
                Shuffle(probeSeq1), Shuffle(probeSeq1);...
                Shuffle(probeSeq1), Shuffle(probeSeq1);...
                Shuffle(probeSeq2), Shuffle(probeSeq2);...
                Shuffle(probeSeq2), Shuffle(probeSeq2)];
            
            repeats = probeIndex(1,:) == probeIndex(2,:);
            repeats2 = probeIndex(3,:) == probeIndex(4,:);
            
            if any(repeats) || any(repeats2)
                a = 0;
            else
                a = 1;
            end
        end
    end
    probeTrials = probes(probeIndex(:,i),:);
    
    % probes of the unused hand
    if i == 1
        unusedIndex = Shuffle(1:8);
    end
    unusedTrials = probesUnused(unusedIndex(:,i),:);
    
    % assemble full data structure for block
    trialStruct = [fileHeader; prodTrials; probeTrials; unusedTrials];
    
    % write to excel file
    writecell(trialStruct,[fileNamesB{i}, '.xlsx'])
end

%% C_trialsX
for i=1:nBlocksC
    % to make flexible eventually
    nProd = 16;
    nProbes = 4;
    nUnused = 1;
    
    % production trials
    sequenceA = repmat(memorySequences(1,:),(nProd/2),1);
    sequenceB = repmat(memorySequences(2,:),(nProd/2),1);
    prodTrials = [sequenceA; sequenceB];
    
    if i == 1
        % probe trials
        probeSeq1 = 1:4;
        probeSeq2 = 5:8;
        a = 0;
        
        while a == 0 %make sure there are no repeats of probes within blocks
            probeIndex = [...
                Shuffle(probeSeq1), Shuffle(probeSeq1);...
                Shuffle(probeSeq1), Shuffle(probeSeq1);...
                Shuffle(probeSeq2), Shuffle(probeSeq2);...
                Shuffle(probeSeq2), Shuffle(probeSeq2)];
            
            repeats = probeIndex(1,:) == probeIndex(2,:);
            repeats2 = probeIndex(3,:) == probeIndex(4,:);
            
            if any(repeats) || any(repeats2)
                a = 0;
            else
                a = 1;
            end
        end
    end
    probeTrials = probes(probeIndex(:,i),:);
    
    % probes of the unused hand
    if i == 1
        unusedIndex = Shuffle(1:8);
    end
    unusedTrials = probesUnused(unusedIndex(:,i),:);
    
    % assemble full data structure for block
    trialStruct = [fileHeader; prodTrials; probeTrials; unusedTrials];
    
    % write to excel file
    writecell(trialStruct,[fileNamesC{i}, '.xlsx'])
end

%% Test_trialsX
for i=1:nBlocksTest
    % to make flexible eventually
    nProd = 16;
    nProbes = 4;
    nUnused = 1;
    
    % production trials
    sequenceA = repmat(memorySequences(1,:),(nProd/2),1);
    sequenceB = repmat(memorySequences(2,:),(nProd/2),1);
    prodTrials = [sequenceA; sequenceB];
    
    % probe trials
    probeTrials = probes(1:8,:);
    
    % probes of the unused hand
    
    %%% spread unused probes out across blocks
%     unusedIndex = [...
%         Shuffle(1:4), Shuffle(1:4), Shuffle(1:4);...
%         Shuffle(5:8), Shuffle(5:8), Shuffle(5:8)];
%     unusedTrials = probesUnused(unusedIndex(:,i),:);

    %%% include all unused probes per block
    unusedTrials = probesUnused(1:8,:);
    
    % assemble full data structure for block
    trialStruct = [fileHeader; prodTrials; probeTrials; unusedTrials];
    
    % write to excel file
    writecell(trialStruct,[fileNamesTest{i}, '.xlsx'])
end
