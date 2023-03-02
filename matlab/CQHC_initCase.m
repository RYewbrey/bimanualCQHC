function [A, subj] = CQHC_initCase(saveDir)
% Initiates cases in bimanualCQHC_ana script
% Loads data and generates other necessary generalisable variables
% Input:
%     saveDir - save location of psychoPy excel data. Specified by _ana script
% Output:
%     A       - struct containing all behavioural variables
%     subj    - variable with each participant's unique ID
%
% RY 11/2022

cd(saveDir);
filename='cqHC_dataAll';
load(filename, 'A') %load A
subj = unique(A.subjID);