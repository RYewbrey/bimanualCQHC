function cqDyspraxia_ana(ana) %wrapper code
%Imports raw data, saves relevant data in a structure, plots individual and group data, and does
%basics stats

%Written by K. Kornysheva, September 2021
%Load toolboxes and experimental code

addpath(genpath('\\adf\storage\h\w\hxw544\PhD\Matlab_code\util'));%Joern Diedrichsen's util toolbox
addpath(genpath('\\adf\storage\h\w\hxw544\PhD\Matlab_code\graph'));%Joern Diedrichsen's util toolbox
addpath(genpath('\\adf\storage\h\w\hxw544\PhD\Matlab_code\pivot'));%Joern Diedrichsen's util toolbox
addpath(genpath('Z:\toolboxes\RainCloudPlots-master')); %raincloud plot toolbox
addpath(genpath('\\adf\storage\h\w\hxw544\PhD\Matlab_code\Robust_Statistical_Toolbox-master')); %Robust statistical toolbox master
addpath(genpath('Z:\helena\cqDyspraxia\matlab'));%experimental code
addpath(genpath('Z:\toolboxes\userfun'));

% %%% Mac
% addpath(genpath('/Users/katjakornysheva/Dropbox/SAMlab/projects/toolboxes/matlab/userfun'));%Joern Diedrichsen's util toolbox
% addpath(genpath('/Users/katjakornysheva/Dropbox/SAMlab/projects/toolboxes/matlab/raincloud')); %raincloud plot toolbox
% addpath(genpath('/Users/katjakornysheva/Dropbox/SAMlab/projects/cqPD/matlab'));%experimental code
%
% rawDir= '/Users/katjakornysheva/Dropbox/SAMlab/projects/cqPD/data/pilot';

rawDir= 'Z:\helena\cqDyspraxia\data\';
SavePath= 'Z:\helena\cqDyspraxia\docs\';
%fileName={'yqh88_behaviouralCQ_2021-09-06_11h22.43.125.csv'}; %
%   fileName={'6mjf9u_behaviouralCQ_2022-04-13_09h41.48.629.csv'};
% fileName={'6mjf9u_behaviouralCQ_2022-04-13_09h41.48.629.csv','6mjf9u_behaviouralCQ_2022-04-11_09h28.53.795.csv','6mjf9u_behaviouralCQ_2022-04-12_09h36.22.791.csv'};
% fileName={'gvydkg_behaviouralCQ_2022-04-11_10h00.58.654.csv','gvydkg_behaviouralCQ_2022-04-13_10h47.28.054.csv','gvydkg_behaviouralCQ_2022-04-12_23h26.10.410.csv'};
% fileName={'nayqy8_behaviouralCQ_2022-04-07_19h16.40.152.csv','nayqy8_behaviouralCQ_2022-04-08_23h50.40.048.csv','nayqy8_behaviouralCQ_2022-04-06_19h35.21.028.csv','gvydkg_behaviouralCQ_2022-04-11_10h00.58.654.csv','gvydkg_behaviouralCQ_2022-04-13_10h47.28.054.csv','gvydkg_behaviouralCQ_2022-04-12_23h26.10.410.csv','gvjg9r_behaviouralCQ_2022-04-12_11h58.11.163.csv','gvjg9r_behaviouralCQ_2022-04-13_12h19.16.091.csv','gvjg9r_behaviouralCQ_2022-04-11_11h54.36.818.csv','tspxji_behaviouralCQ_2022-04-11_16h53.22.228.csv','tspxji_behaviouralCQ_2022-04-12_16h43.43.146.csv','tspxji_behaviouralCQ_2022-04-13_21h20.17.711.csv','rc5v2a_behaviouralCQ_2022-04-11_16h50.23.943.csv','rc5v2a_behaviouralCQ_2022-04-12_17h00.37.929.csv','rc5v2a_behaviouralCQ_2022-04-13_19h25.31.241.csv','x1hjut_behaviouralCQ_2022-04-13_19h31.18.452.csv','x1hjut_behaviouralCQ_2022-04-14_22h55.08.641.csv','x1hjut_behaviouralCQ_2022-04-15_15h17.45.547.csv','qjqobq_behaviouralCQ_2022-04-11_13h02.46.csv','qjqobq_behaviouralCQ_2022-04-14_22h47.19.csv','qjqobq_behaviouralCQ_2022-04-14_23h12.35.csv','6mjf9u_behaviouralCQ_2022-04-13_09h41.48.629.csv','6mjf9u_behaviouralCQ_2022-04-11_09h28.53.795.csv','6mjf9u_behaviouralCQ_2022-04-12_09h36.22.791.csv','k8qay7_behaviouralCQ_2022-05-11_21h59.45.563.csv','k8qay7_behaviouralCQ_2022-05-12_22h18.14.680.csv','k8qay7_behaviouralCQ_2022-05-13_23h18.56.563.csv'};
% fileName={'xtmc3c_behaviouralCQ_2022-05-18_18h11.33.455.csv','xtmc3c_behaviouralCQ_2022-05-19_18h42.03.879.csv','xtmc3c_behaviouralCQ_2022-05-17_17h45.05.749.csv','rjxuv7_behaviouralCQ_2022-05-19_21h57.33.297.csv','rjxuv7_behaviouralCQ_2022-05-21_24h57.46.888.csv','rjxuv7_behaviouralCQ_2022-05-18_22h31.50.105.csv','k8qay7_behaviouralCQ_2022-05-11_21h59.45.563.csv','k8qay7_behaviouralCQ_2022-05-12_22h18.14.680.csv','k8qay7_behaviouralCQ_2022-05-13_23h18.56.563.csv','ue9umm_behaviouralCQ_2022-05-12_17h07.50.238.csv','ue9umm_behaviouralCQ_2022-05-11_13h02.30.717.csv','ue9umm_behaviouralCQ_2022-05-13_20h00.03.527.csv'};
fileName={'RYC8PW9P_behaviouralCQ_2022-08-22_22h51.25.637.csv','RYC8PW9P_behaviouralCQ_2022-08-23_22h03.18.427.csv','RYC8PW9P_behaviouralCQ_2022-08-24_23h37.05.559.csv'...
    '8P5K4BUL_behaviouralCQ_2022-08-24_12h02.14.777.csv','8P5K4BUL_behaviouralCQ_2022-08-25_15h07.16.182.csv','8P5K4BUL_behaviouralCQ_2022-08-26_21h27.30.555.csv'...
    'FR9FTPXW_behaviouralCQ_2022-09-12_18h23.34.629.csv','FR9FTPXW_behaviouralCQ_2022-09-14_17h29.43.829.csv','FR9FTPXW_behaviouralCQ_2022-09-15_18h04.15.381.csv' ...
    '3NRN85LN_behaviouralCQ_2022-09-12_15h54.21.176.csv','3NRN85LN_behaviouralCQ_2022-09-14_09h31.12.432.csv','3NRN85LN_behaviouralCQ_2022-09-14_09h56.04.551.csv'...
    'QK2ZAG5D_behaviouralCQ_2022-09-07_15h30.01.433.csv','QK2ZAG5D_behaviouralCQ_2022-09-08_18h14.58.862.csv','QK2ZAG5D_behaviouralCQ_2022-09-09_16h04.40.337.csv'...
    'AK48USK3_behaviouralCQ_2022-09-06_11h37.32.616.csv','AK48USK3_behaviouralCQ_2022-09-05_10h52.50.692.csv','AK48USK3_behaviouralCQ_2022-09-07_10h43.42.934.csv'...
    'AMCJ6RPV_behaviouralCQ_2022-09-05_22h24.57.194.csv','AMCJ6RPV_behaviouralCQ_2022-09-03_15h09.34.890.csv','AMCJ6RPV_behaviouralCQ_2022-09-04_16h10.42.738.csv'...
    'AQ4ZP844_behaviouralCQ_2022-08-26_19h26.43.899.csv','AQ4ZP844_behaviouralCQ_2022-08-30_20h28.52.643.csv','AQ4ZP844_behaviouralCQ_2022-08-25_21h03.12.155.csv'...
    '97CH6BDY_behaviouralCQ_2022-08-24_11h35.48.264.csv','97CH6BDY_behaviouralCQ_2022-08-22_10h40.46.370.csv','97CH6BDY_behaviouralCQ_2022-08-23_11h23.57.020.csv'...
    '4R9K6K4G_behaviouralCQ_2022-08-22_09h39.49.893.csv','4R9K6K4G_behaviouralCQ_2022-08-23_15h29.23.605.csv','4R9K6K4G_behaviouralCQ_2022-08-24_09h18.57.132.csv'...
    '86FSEHLN_behaviouralCQ_2022-09-23_15h40.32.781.csv','86FSEHLN_behaviouralCQ_2022-09-24_18h22.20.502.csv','86FSEHLN_behaviouralCQ_2022-09-25_18h01.33.425.csv'...
    '25VEGY9M_behaviouralCQ_2022-09-03_11h39.15.559.csv','25VEGY9M_behaviouralCQ_2022-09-04_10h27.56.990.csv','25VEGY9M_behaviouralCQ_2022-09-02_16h50.55.305.csv'...
    '5U9QU45U_behaviouralCQ_2022-08-31_15h04.36.630.csv','5U9QU45U_behaviouralCQ_2022-09-01_16h56.39.743.csv','5U9QU45U_behaviouralCQ_2022-09-02_15h33.05.972.csv'...
    '2F2F8234_behaviouralCQ_2022-09-02_18h02.26.817.csv','2F2F8234_behaviouralCQ_2022-09-03_17h59.51.594.csv','2F2F8234_behaviouralCQ_2022-09-04_11h17.19.355.csv'...
    'L2LVF3B6_behaviouralCQ_2022-09-05_10h23.04.124.csv','L2LVF3B6_behaviouralCQ_2022-09-03_10h16.49.672.csv','L2LVF3B6_behaviouralCQ_2022-09-04_10h09.13.094.csv'...
    'NMNL5HL9_behaviouralCQ_2022-09-02_15h56.17.265.CSV','NMNL5HL9_behaviouralCQ_2022-08-31_15h25.59.511.csv','NMNL5HL9_behaviouralCQ_2022-09-02_15h19.02.094.csv'...
    'HSFEKXLX_behaviouralCQ_2022-09-08_12h03.19.020.csv','HSFEKXLX_behaviouralCQ_2022-09-06_11h43.13.661.csv','HSFEKXLX_behaviouralCQ_2022-09-07_11h50.45.564.csv'...
    'DT3W3NQC_behaviouralCQ_2022-09-05_21h05.10.500.csv','DT3W3NQC_behaviouralCQ_2022-09-07_21h01.28.310.csv','DT3W3NQC_behaviouralCQ_2022-09-06_21h01.28.676.csv'...
    'KZ68F3WL_behaviouralCQ_2022-09-05_12h59.28.174.csv','KZ68F3WL_behaviouralCQ_2022-09-07_13h22.34.369.csv','KZ68F3WL_behaviouralCQ_2022-09-06_13h12.22.524.csv'...
    'V7A74G2H_behaviouralCQ_2022-09-26_13h14.44.359.csv','V7A74G2H_behaviouralCQ_2022-09-27_12h24.34.633.csv','V7A74G2H_behaviouralCQ_2022-09-28_13h11.47.369.csv'...
    '82RBSXKF_behaviouralCQ_2022-09-28_11h23.19.998.csv','82RBSXKF_behaviouralCQ_2022-09-27_11h34.06.841.csv','82RBSXKF_behaviouralCQ_2022-09-29_11h28.23.705.csv'...
    '58F7DTFF_behaviouralCQ_2022-09-26_15h49.41.948.csv','58F7DTFF_behaviouralCQ_2022-09-27_21h36.35.523.csv','58F7DTFF_behaviouralCQ_2022-09-28_16h05.54.192.csv'...
    'YVQZA8QH_behaviouralCQ_2022-09-28_10h47.29.563.csv','YVQZA8QH_behaviouralCQ_2022-09-27_11h09.28.395.csv','YVQZA8QH_behaviouralCQ_2022-09-29_13h39.33.971.csv'...
    'CUJPLFHU_behaviouralCQ_2022-09-28_18h28.41.044.csv','CUJPLFHU_behaviouralCQ_2022-09-29_18h23.34.093.csv','CUJPLFHU_behaviouralCQ_2022-09-30_18h29.59.464.csv'...
    'AD9CAVC_behaviouralCQ_2022-09-27_11h12.39.289.csv','AD9CAVC_behaviouralCQ_2022-09-28_10h39.09.097.csv','AD9CAVC_behaviouralCQ_2022-09-29_09h12.04.413.csv'...
    'NZQCSQPZ_behaviouralCQ_2022-09-27_13h05.34.115.csv','NZQCSQPZ_behaviouralCQ_2022-09-28_12h22.23.944.csv','NZQCSQPZ_behaviouralCQ_2022-09-29_12h35.19.215.csv'...
    'W8GF8EZ5_behaviouralCQ_2022-09-29_12h28.09.csv','W8GF8EZ5_behaviouralCQ_2022-09-28_10h55.40.csv','W8GF8EZ5_behaviouralCQ_2022-09-30_13h22.56.csv'...
    'RY5KQ92N_behaviouralCQ_2022-09-28_11h22.41.681.csv','RY5KQ92N_behaviouralCQ_2022-09-29_10h26.53.756.csv','RY5KQ92N_behaviouralCQ_2022-09-30_09h05.57.352.csv'...
    'NPE6WJMJ_behaviouralCQ_2022-09-28_18h07.42.743.csv','NPE6WJMJ_behaviouralCQ_2022-09-29_11h13.15.330.csv','NPE6WJMJ_behaviouralCQ_2022-09-30_20h48.28.368.csv'...
    'CZ5UUXQJ_behaviouralCQ_2022-09-28_15h46.22.524.csv','CZ5UUXQJ_behaviouralCQ_2022-09-29_16h30.40.204.csv','CZ5UUXQJ_behaviouralCQ_2022-09-30_22h27.06.819.csv'...
    'v3wb8_behaviouralCQ_2022-10-17_20h18.23.520.csv','v3wb8_behaviouralCQ_2022-10-18_10h53.22.644.csv','v3wb8_behaviouralCQ_2022-10-19_16h26.08.170.csv'...
    'gbqmD_behaviouralCQ_2022-10-17_17h17.05.220.csv','gbqmD_behaviouralCQ_2022-10-18_17h21.30.393.csv','gbqmD_behaviouralCQ_2022-10-19_16h44.51.826.csv'...
    'o3qic_behaviouralCQ_2022-10-17_15h27.29.244.csv','o3qjc_behaviouralCQ_2022-10-18_23h07.38.134.csv','o3qjc_behaviouralCQ_2022-10-19_16h23.05.985.csv'};
%fileName={'nayqy8_behaviouralCQ_2022-04-07_19h16.40.152.csv','nayqy8_behaviouralCQ_2022-04-08_23h50.40.048.csv','nayqy8_behaviouralCQ_2022-04-06_19h35.21.028.csv'};
%fileName={'yqh88_behaviouralCQ_2021-09-06_11h22.43.125.csv','yqh88_behaviouralCQ_2021-09-07_11h42.32.223.csv','yqh88_behaviouralCQ_2021-09-08_11h48.31.689.csv'};
%fileName={'yqh88_behaviouralCQ_2021-09-06_11h22.43.125.csv','yqh88_behaviouralCQ_2021-09-07_11h42.32.223.csv','yqh88_behaviouralCQ_2021-09-08_11h48.31.689.csv','anita_behaviouralCQ_2021-12-14_16h57.20.867.csv','rhys_1_behaviouralCQ_2022-01-03_15h15.57.072.csv'};
% fileName={'yqh88_behaviouralCQ_2021-09-06_11h22.43.125.csv','yqh88_behaviouralCQ_2021-09-08_11h48.31.689.csv'}; %temporarily
%fileName={'97CH6BDY_behaviouralCQ_2022-08-24_11h35.48.264.csv','97CH6BDY_behaviouralCQ_2022-08-22_10h40.46.370.csv','97CH6BDY_behaviouralCQ_2022-08-23_11h23.57.020.csv'};
% fileName={'yqh88_behaviouralCQ_2021-09-06_11h22.43.125.csv'};
% 'AQ4ZP844_behaviouralCQ_2022-08-26_19h26.43.899.csv','AQ4ZP844_behaviouralCQ_2022-08-30_20h28.52.643.csv','AQ4ZP844_behaviouralCQ_2022-08-25_21h03.12.155.csv'
%'8P5K4BUL_behaviouralCQ_2022-08-24_12h02.14.777.csv','8P5K4BUL_behaviouralCQ_2022-08-25_15h07.16.182.csv','8P5K4BUL_behaviouralCQ_2022-08-26_21h27.30.555.csv',
%'RYC8PW9P_behaviouralCQ_2022-08-22_22h51.25.637.csv','RYC8PW9P_behaviouralCQ_2022-08-23_22h03.18.427.csv','RYC8PW9P_behaviouralCQ_2022-08-24_23h37.05.559.csv',
%
%     '4R9K6K4G_behaviouralCQ_2022-08-24_09h18.57.132.csv'... put in after
%     97
%     '86FSEHLN_behaviouralCQ_2022-09-25_18h01.33.425.csv'...
%  '3NRN85LN_behaviouralCQ_2022-09-14_09h56.04.551.csv'... put 3rd from the
%  top
switch ana
    case 'loadData' %% Import files
        cd(rawDir);
        A=[]; %structure across subj
        S=[]; %structure across days
        
        for subj=1:size(fileName,1) %subj loop
            for day=1:size(fileName,2) %day loop
                disp([fileName{subj, day} 'in progress..']);
                D = cqDyspraxia_importFile(fileName{subj,day}); % imports data from raw in puts it into a structure array
                D.TN= (1:size(D.RT,1))';
                disp([fileName{subj, day} 'done.']);
                S=addstruct(S,D); %within subj
                clear D;
            end;
            A=addstruct(A,S); %within subj
            clear S;
        end;
        A;
        
        A.subject = grp2idx(A.subjID);
        A.group(:,1) = size(A.subject(:,1));
        for i=1:length(A.subject(:,1))
            if (A.subject(i)<=11) %11%if (A.subject(i)<=11 || A.subject(i)==19 || A.subject(i)==34)
                A.group(i) = 1; % 1 = Dyspraxia, 2 = Control
            else
                A.group(i) = 2;
            end
        end
        
        A.outliersRemoved = [];
        
        for i = 1:length(A.subject(:,1))
            if A.subject(i)==33 ||  A.subject(i)==31 ||  A.subject(i)==30 ...
                    ||  A.subject(i)==26 ||  A.subject(i)==28 || A.subject(i)==1 ...
                    || A.subject(i)==2 || A.subject(i)==3 || A.subject(i)==6 ...
                    || A.subject(i)==12 || A.subject(i)==14 || A.subject(i)==8
                placeHolder(i)=0;
            else
                placeHolder(i)=1;
            end
            A.outliersRemoved(i)=placeHolder(i);
        end
        A.outliersRemoved=A.outliersRemoved';
        
        filename='cqDyspraxia_dataAll.mat';
        save(filename, 'A')
        
        
    case 'outliers'
        
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A') %load A
        
        % sequence trials number of correct presses. 4 = sequence all
        % correct, 3 = 1 incorrect, 2 = 2 incorrect, 1 = 3 incorrect
        
        A.NumErrorpress=zeros(length(A.ErrorSum),1);
        
        for i=1:length(A.ErrorSum)
            if A.ErrorSum(i)==4
                A.NumErrorpress(i)=0;
            elseif A.ErrorSum(i)==3
                A.NumErrorpress(i)=1;
            elseif A.ErrorSum(i)==2
                A.NumErrorpress(i)=2;
            elseif A.ErrorSum(i)==1
                A.NumErrorpress(i)=3;
            elseif A.ErrorSum(i)==0
                A.NumErrorpress(i)=4;
            end
        end
        
        M=tapply(A,{'subject','group'},{A.NumErrorpress,'sum','name','pressError'},'subset',A.day==3&A.trialType==3&A.TN>20);
        
        figure;
        scatterplot(M.subject(M.group==1),M.pressError(M.group==1),...
            'leg','auto')
        title ('Press error for seqeunce Trials (DCD)');
        % ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        
        figure;
        scatterplot(M.subject(M.group==2),M.pressError(M.group==2),...
            'leg','auto')
        title ('Press error for seqeunce Trials (Control)');
        % ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        
        % percentage of errors for sequence trials
        M.percentage =[];
        subjectID=unique((M.subject));
        for subj=1:length(subjectID)
            catHolder=M.pressError(M.subject==subjectID(subj))./560;
            M.percentage = [M.percentage; catHolder];
        end
        M.percentage=M.percentage*100;
        
        
        figure;
        scatterplot(M.subject(M.group==1),M.percentage(M.group==1),...
            'leg','fill')
        title ('Press error for seqeunce Trials (DCD)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(20,'dir','horz','color',[0 0 0],'linestyle','-')
        % xticklabels({'1', '2','3','4','5','6','7','8','9','10','11'});
        % legend('DCD','Control')
        
        figure;
        scatterplot(M.subject(M.group==2),M.percentage(M.group==2),...
            'leg','auto')
        title ('Press error for seqeunce Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(20,'dir','horz','color',[0 0 0],'linestyle','-')
        
        % participants need to have >14 of the probe trials correct to be
        % included in the analysis
        % 29 probe trials for each position
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
        
        % participants to include and exclude, 26 control excluded based on
        % probe trials.
        
        % sequence trial errors exclusion
        
    case 'outliersMem'
        
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A') %load A
        A.NumError=zeros(length(A.ErrorTrial),1);
        
        for i=1:length(A.ErrorTrial)
            if A.ErrorTrial(i)==1
                A.NumError(i)=0;
            else
                A.NumError(i)=1;
            end
        end
        
        % sequence trials on day 3
        G=tapply(A,{'subject','group'},{A.NumError,'sum','name','MemError'},'subset',A.day==2&A.trialType==3);
        % sequence trials overall
        %         G=tapply(A,{'subject','group'},{A.NumError,'sum','name','MemError'},'subset',A.trialType==3);
        
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
        subjectID=unique((G.subject));
        for subj=1:length(subjectID)
            catHolder=G.MemError(G.subject==subjectID(subj))./160; %140 for day 3
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
        % legend('DCD','Control')
        
        figure;
        scatterplot(G.subject(G.group==2),G.percentage(G.group==2),...
            'leg','auto')
        title ('Error for seqeunce Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        drawline(30,'dir','horz','color',[0 0 0],'linestyle','-')
        
        % Make a variable of subjects without the outliers - logical with the
        % subjects to exclude.
        % 33, 31, 30, 26, 28
        
        % instructed trials
        
        J=tapply(A,{'group','subject'},{A.NumError(:,1),'sum','name','InstructedError'},'subset',A.trialType==1);
        
        figure;
        scatterplot(J.subject(J.group==1),J.InstructedError(J.group==1),...
            'leg','auto')
        title ('Error for instructed Trials (DCD)');
        ylabel('Number of Errors');
        xlabel('DCD')
        
        figure;
        scatterplot(J.subject(J.group==2),J.InstructedError(J.group==2),...
            'leg','auto')
        title ('Error for instructed Trials (Control)');
        ylabel('Number of Errors');
        xlabel('control')
        
        % percentage of errors for Instructed trials
        J.percentage =[];
        subjectID=unique((J.subject));
        for subj=1:length(subjectID)
            catHolder=J.InstructedError(J.subject==subjectID(subj))./160;
            J.percentage = [J.percentage; catHolder];
        end
        J.percentage=J.percentage*100;
        
        
        figure;
        scatterplot(J.subject(J.group==1),J.percentage(J.group==1),...
            'leg','fill')
        title ('Error for instructed Trials (DCD)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        ylim([0 100]);
        drawline(30,'dir','horz','color',[0 0 0],'linestyle','-')
        
        % xticklabels({'1', '2','3','4','5','6','7','8','9','10','11'});
        % legend('DCD','Control')
        
        figure;
        scatterplot(J.subject(J.group==2),J.percentage(J.group==2),...
            'leg','auto')
        title ('Error for instructed Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Participant')
        ylim([0 100]);
        drawline(30,'dir','horz','color',[0 0 0],'linestyle','-')
        
        % 4, 5, 7, 9 (keep) DCD, 12, 14 control get rid
        
    case 'plot'  %% Extract RT, errors per condition and plot
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A') %load A
        T=tapply(A,{'subject'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20);
        V=tapply(A,{'subject'},{A.RT(:,1),'std','name','probeRTstd'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20);
        
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            B.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==2&A.points>0&A.day==3&A.TN>20);
        end
        
        B.outlier=[];
        subjID=unique((T.subject));
        for subj=1:length(subjID)
            catHolder=A.RT(A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subject==subj)>(T.probeRTmedian(subj,1)+3*(V.probeRTstd(subj,1)));
            B.outlier = [B.outlier; catHolder];
        end
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            B.(fieldnames{i})(B.outlier==1) = [];
        end
        
        for position=1:4
            
            %         testtrials=(A.day==3&A.trialType==2&A.points>0&A.probeTargetPos==position);
            meanRT(position)=nanmean(A.RT(A.probeTargetPos == position));
            stdRT(position)=nanstd(A.RT(A.probeTargetPos == position));
            
            threestd(position)=stdRT(position)*3;
            
            max(position)=meanRT(position)+threestd(position);
            min(position)=meanRT(position)-threestd(position);
            
            A.RT(A.probeTargetPos == position>max(position))=NaN;
            %         A.RT(A.RT>min(position))=[];
            
            A.RT=A.RT';
        end
        
        %         empty_matrix = zeros([4,(length(A.RT)/4])
        %         for i=1:length(A.RT)
        %
        %             disp(A.RT(i));
        %
        %
        %         end
        %
        
        %         x = [1 2 3 4];
        
        for i=1:length(A.subject)
            
            if i==1
                [A.probenoutliers1,A.outliers1] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==1&A.day==3&A.points>0),'mean');
                [A.probenoutliers2,A.outliers2] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==2&A.day==3&A.points>0),'mean');
                [A.probenoutliers3,A.outliers3] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==3&A.day==3&A.points>0),'mean');
                [A.probenoutliers4,A.outliers4] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==4&A.day==3&A.points>0),'mean');
            else
                [a, b] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==1&A.day==3&A.points>0),'mean');
                A.probenoutliers1 = [A.probenoutliers1; a];
                A.outliers1 = [A.outliers1; b];
                
                [a, b] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==2&A.day==3&A.points>0),'mean');
                A.probenoutliers2 = [A.probenoutliers2; a];
                A.outliers2 = [A.outliers2; b];
                
                [a, b] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==3&A.day==3&A.points>0),'mean');
                A.probenoutliers3 = [A.probenoutliers3; a];
                A.outliers3 = [A.outliers3; b];
                
                [a, b] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==4&A.day==3&A.points>0),'mean');
                A.probenoutliers4 = [A.probenoutliers4; a];
                A.outliers4 = [A.outliers4; b];
                
                %                 [probenoutliers2(end+1),outliers2(end+1)] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==2&A.day==3&A.points>0),'mean');
                %                 [probenoutliers3(end+1),outliers3(end+1)] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==3&A.day==3&A.points>0),'mean');
                %                 [probenoutliers4(end+1),outliers4(end+1)] = rmoutliers(A.RT(A.subject==i&A.probeTargetPos==4&A.day==3&A.points>0),'mean');
                %                 %         x = [1 2 3 4];
                
                
            end
        end
        
        
        %         Raincloud plot
        colPos=[0.5 0.8 0.9; 1 0.7 1; 0.7 0.8 0.9; 0.6 0.8 0.5];
        
        fig_position = [200 200 600 400]; % coordinates for figures
        %         figure;
        %         for i=1:4
        %             RTpos=B.RT(B.subject==10& B.probeTargetPos==i);
        %             subplot(1,4,i);
        %             raincloud_plot(RTpos,'color',colPos(i,:));
        %             ax = gca;
        %
        %              xlim([0.1 0.7]);
        %             %             ylim([-5 5]);
        %             camroll(+90)
        %             title(['ProbePos' num2str(i)]);
        %
        %         end
        
        %         figure;
        %         RTpos = []
        
        
        %
        figure;
        
        %         for i=1:1
        %             probeRT=A.firstKeyRT(A.trialType==2);
        %             subplot(1,1,i);
        %             raincloud_plot(probeRT,'color',colPos(i,:));
        %             ax=gca;
        %
        %             camroll(+90)
        %             title(['ProbeRT' num2str(i)]);
        %         end
        %
        %         figure;
        %         for i=1:1
        %             seqproduction=A.seqProd(A.trialType==3);
        %             subplot(1,1,i);
        %             raincloud_plot(seqproduction,'color',colPos(i,:));
        %             ax=gca;
        %
        %             camroll(+90)
        %             title(['Production' num2str(i)]);
        %
        %         end
        loopcounter=1;
        figure;
        RTpos=[];
        subjectID=unique((A.subject(A.group==1)));
        
        for j=3:length(subjectID)
            for i=1:4
                RTpos=A.RT(A.subject==j&A.trialType==3&A.points>0&A.day==3&A.TN>20,i);
                %                 RTpos=B.RT(B.subject==j, i);
                % A.group==3
                subplot(2,4,loopcounter)
                raincloud_plot(RTpos,'color',colPos(i,:));
                ax = gca;
                
                xlim([0 3.5]);
                %                   ylim([0 7]);
                camroll(+90)
                title(['Sequence Timing (DCD)']);
                hold on;
            end
            loopcounter=loopcounter+1;
        end
        
        loopcounter=1;
        figure;
        RTpos=[];
        
        subjectID=unique((A.subject(A.group==2)));
        for j=10:subjectID(end)
            for i=1:4
                RTpos=A.RT(A.subject==j&A.trialType==3&A.points>0&A.day==3&A.TN>20,i);
                %                 RTpos=B.RT(B.subject==j, i);
                % A.group==3
                subplot(2,4,loopcounter)
                raincloud_plot(RTpos,'color',colPos(i,:));
                ax = gca;
                
                xlim([0 3.5]);
                %                   ylim([0 7]);
                camroll(+90)
                title(['Sequence Timing (Control)']);
                hold on;
            end
            loopcounter=loopcounter+1;
        end
        loopcounter=1;
        %     subjectID=unique((A.subject));
        figure;
        for j=7
            for i=1:4
                RTpos=A.RT(A.subject==j&A.trialType==3&A.points>0&A.day==3&A.TN>20 ,i);
                %                 RTpos=B.RT(B.subject==j, i);
                % A.group==3
                subplot(1,1,loopcounter)
                raincloud_plot(RTpos,'color',colPos(i,:));
                ax = gca;
                
                %                  xlim([0 4]);
                %                   ylim([0 7]);
                camroll(+90)
                title(['Sequence Timing']);
                hold on;
            end
            loopcounter=loopcounter+1;
        end
        %         figure;
        %         RTPos=[];
        %         for i=1:4
        %             RTPos=A.RT(A.day==3&A.subject==9&A.trialType==3&A.points>0, i);
        %             subplot(1,2,1)
        %             raincloud_plot(RTPos, 'color',colPos(i,:));
        %             ax = gca;
        %
        %             xlim([0 3.3]);
        %             ylim([0 5]);
        %             camroll(+90)
        %             title(['Sequence Timing']);
        %             hold on;
        %         end
        %
        
        %
        % figure;
        % RT=[];
        % for i=1:4
        %     if A.RT(A.trialType==3,1:4)
        %
        %
        %     RT=A.RT(A.trialType==3 & A.points>0 & A.day==3 & A.press==i,:);
        %
        %     raincloud_plot(RT,'color',colPos(i,:));
        %     ax = gca;
        %
        %     ylim([0 3]);
        %     camroll(+90)
        %     title(['RT']);
        %     hold on;
        % end
        
        %         figure;
        %         for i=1:4
        %             Prod=A.firstKeyRT(A.group==3&A.trialType==2 & A.points>0 & A.probeTargetPos==i);
        %             subplot(1,4,i);
        %             raincloud_plot(Prod,'color',colPos(i,:));
        %             ax = gca;
        %
        %             xlim([0.1 1.6]);
        %             %             camroll(+90)
        %             title(['ProbeProd' num2str(i)]);
        %         end
        %
        %         figure;
        %
        %
        %         for i=1:4
        %             for j=1:4
        %                 prod=A.RT(A.group==3&A.trialType==3 & A.points>0 & A.press(:,j)==i);
        %                 subplot(1,4,j)
        %                 if isempty(prod) == 0
        %                     raincloud_plot(prod,'color',colPos(i,:),'alpha', 0.25);
        %                     %             raincloud_plot(prod,'color',colPos(i,:));
        %
        %                     %             legend([h1{prod} h2{prod2} h3{prod3} h4{prod4}], {'1','2','3','4'});
        %                     fig = gcf;
        %                     ax = fig.CurrentAxes;
        %                     %                          ax = gca;
        %
        %                     set(gca, 'XLim', [0 3]);
        %                     %             set(gca, 'YLim', [0 3]);
        %                     xlim([0 3]);
        %                     %             camroll(+90)
        %                     title(['press' num2str(i)]);
        %
        %                 end
        %             end
        %         end
        
        
        %         T.subject~=4&T.subject~=5
    case 'relativeRT'
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A')
        
        A.RT
        
        %         T=tapply(A,{'group','subject','probeTargetPos'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==3&A.points>0&A.day==3);
        T=tapply(A,{'subject'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20);
        V=tapply(A,{'subject'},{A.RT(:,1),'std','name','probeRTstd'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20);
        
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            B.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==2&A.points>0&A.day==3&A.TN>20);
        end
        
        B.outlier=[];
        subjID=unique((T.subject));
        for subj=1:length(subjID)
            catHolder=A.RT(A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subject==subj)>(T.probeRTmedian(subj,1)+3*(V.probeRTstd(subj,1)));
            B.outlier = [B.outlier; catHolder];
        end
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            B.(fieldnames{i})(B.outlier==1) = [];
        end
        
        % Outliers removed, those who did not complete enough instructed
        % trials
        % B.subject~=1&B.subject~=2&
        %         Q=tapply(A,{'group','subject','probeTargetPos'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subject~=26&A.subject~=27&A.subject~=28&A.subject~=29&A.subject~=30&A.subject~=31&A.subject~=33&A.subject~=34&A.subject~=16&A.subject~=19&A.subject~=4);
        Q=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=16&B.subject~=19&B.subject~=34);%all participants removed who didn't understand the task
        Q=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=34&B.subject~=7&B.subject~=11&B.subject~=2); %participants removed who have ADHD
        %         Q=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=33&B.subject~=2); % not enough instructed trials completed
        Q=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=34&B.subject~=2&B.subject~=16&B.subject~=28&B.subject~=30&B.subject~=21&B.subject~=22&B.subject~=25&B.subject~=3&B.subject~=4&B.subject~=7&B.subject~=8); % not enough sequence trials
        Q.probeRTrel=nan(size(Q.subject,1),1);
        
        subjectID=unique((Q.subject));
        for subj=1:length(subjectID)
            RTbase=Q.probeRTmedian(Q.subject==subjectID(subj)&Q.probeTargetPos==1,1);
            Q.probeRTrel(Q.subject==subjectID(subj),1)=(Q.probeRTmedian(Q.subject==subjectID(subj),1)/RTbase - 1)*100;
        end
        
        % Relative RT graph for DCD
        figure;
        %         subplot(1,13,subjectID);
        lineplot(Q.probeTargetPos(Q.group==1), Q.probeRTrel(Q.group==1),'split',Q.subject(Q.group==1),'style_thickline','leg','auto');
        title('RT subject(DCD)');
        ylabel('RT increase(%)');
        legend('3','4','5','8','10');
        %         legend('2','3','4','5','8','10','11','19','33'); % without ADHD
        %         legend('5','10'); % enough sequence trials
        %         ylim([-25 50])
        ylim([-5 50])
        
        figure;
        % Relative RT graph for control
        lineplot(Q.probeTargetPos(Q.group==2), Q.probeRTrel(Q.group==2),'split',Q.subject(Q.group==2),'style_thickline','leg','auto');
        title('RT subject(Control)');
        ylabel('RT increase(%)');
        legend('12','13','15','17','18','20','21','22','23','24','25','28','30','32');
        legend('12','13','15','17','18','20','23','24','32'); % enough sequence trials
        %         ylim([-25 50])
        ylim([-5 50])
        
        %         figure;
        %                 lineplot(Q.probeTargetPos(Q.group==2), Q.probeRTrel(Q.group==2),'split',Q.subject(Q.group==2),'style_thickline','leg','auto');
        %         title('RT subject(DCD)');
        %         ylabel('RT increase(%)');
        % %         legend('3','4','5','7','8','10','11');
        %         legend('19','34'); % without ADHD
        % %         legend('5','10'); % enough sequence trials
        %         % Relative RT graph split by group
        
        figure;
        %         subplot(1,33,subjectID);
        lineplot(Q.probeTargetPos, Q.probeRTrel,'split', Q.group,'style_thickline','leg','auto');
        title ('RT group');
        ylabel('RT increase(%)');
        legend('DCD','Control');
        
        % Outlier removed, those who did not get enough probe trials or
        % sequence trials correct
        
        L=tapply(A,{'group','subject','probeTargetPos'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subject~=1&A.subject~=2&A.subject~=3&A.subject~=4&A.subject~=6&A.subject~=7&A.subject~=8&A.subject~=9&A.subject~=14&A.subject~=16&A.subject~=26&A.subject~=27&A.subject~=28&A.subject~=29&A.subject~=30&A.subject~=31);
        L=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=2&B.subject~=3&B.subject~=4&B.subject~=6&B.subject~=7&B.subject~=8&B.subject~=9&B.subject~=14&B.subject~=16&B.subject~=26&B.subject~=27&B.subject~=28&B.subject~=29&B.subject~=30&B.subject~=31&B.subject~=19&B.subject~=21&B.subject~=22&B.subject~=25&B.subject~=34&B.subject~=23&B.subject~=11&B.outliersRemoved==1);
        
        L.probeRTrel=nan(size(L.subject,1),1);
        
        subjectID=unique((L.subject));
        for subj=1:length(subjectID)
            RTbase=L.probeRTmedian(L.subject==subjectID(subj)&L.probeTargetPos==1,1);
            L.probeRTrel(L.subject==subjectID(subj),1)=(L.probeRTmedian(L.subject==subjectID(subj),1)/RTbase - 1)*100;
        end
        
        % Relative RT graph for DCD
        figure;
        %         subplot(1,13,subjectID);
        lineplot(L.probeTargetPos(L.group==1), L.probeRTrel(L.group==1),'split',L.subject(L.group==1),'style_thickline','leg','auto');
        title('RT subject(DCD)');
        ylabel('RT increase(%)');
        legend('5','10','11');
        
        figure;
        % Relative RT graph for control
        lineplot(L.probeTargetPos(L.group==2), L.probeRTrel(L.group==2),'split',L.subject(L.group==2),'style_thickline','leg','auto');
        title('RT subject(Control)');
        ylabel('RT increase(%)');
        %         legend('4','5','6','7','8','9','10','11');
        
        % Relative RT graph split by group
        figure;
        %         subplot(1,33,subjectID);
        lineplot(L.probeTargetPos, L.probeRTrel,'split', L.group,'style_thickline','leg','auto');
        title ('RT group');
        ylabel('RT increase(%)');
        legend('DCD','Control');
        %         G=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'});
        G=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.outliersRemoved==1);
        %         M=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',B.outliersRemoved==1);
        
        
        %         A.outlier=...zeros(,)
        %         for... subj
        %                 A.outlier=A.RT(A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subj(..,),1)>(T.probeRTmedian(subj,1)+3*(T.probeRTstd(subj,1)));
        %         end
        %
        figure;
        subplot(1,1,1);
        lineplot(G.probeTargetPos, G.probeRTmedian*1000,'split',G.group,'style_thickline','leg','auto');
        title ('RT');
        ylabel('RT(ms)');
        legend('DCD', 'Control');
        
        
        figure;
        subplot(1,2,1);
        lineplot(G.probeTargetPos(G.group==1), G.probeRTmedian(G.group==1)*1000,'split', G.subject(G.group==1),'style_thickline','leg','auto');
        title (' RT (DCD)');
        ylabel('RT(ms)');
        %         ylim([350 800]);
        legend('1', '2','3 Flute','4','5','6','7','8','9','10','11');
        
        subplot(1,2,2);
        lineplot(G.probeTargetPos(G.group==2), G.probeRTmedian(G.group==2)*1000,'split', G.subject(G.group==2),'style_thickline','leg','auto');
        title (' RT (Control)');
        ylabel('RT(ms)');
        %         ylim([350 800]);
        legend('12', '13','14','15','16','17','18','19','20','21','22','23','24','25','26','27(outlier)','28','29','30','31','32','33');
        
        figure;
        subplot(1,2,2);
        lineplot(G.probeTargetPos, G.probeRTmedian*1000,'split', G.subject==33,'style_thickline','leg','auto');
        title (' RT (Control)');
        ylabel('RT(ms)');
        %         ylim([350 800]);
        %         legend('31','32','33');
        
        G.probeRTrel=nan(size(G.subject,1),1);
        
        subjectID=unique((G.subject));
        for subj=1:length(subjectID)
            RTbase=G.probeRTmedian(G.subject==subjectID(subj)&G.probeTargetPos==1,1);
            G.probeRTrel(G.subject==subjectID(subj),1)=(G.probeRTmedian(G.subject==subjectID(subj),1)/RTbase - 1)*100;
        end
        
        figure;
        %         subplot(1,13,subjectID);
        lineplot(G.probeTargetPos(G.group==1), G.probeRTrel(G.group==1),'split',G.subject(G.group==1),'style_thickline','leg','auto');
        title('RT subject(DCD)');
        ylabel('RT increase(%)');
        ylim([-5 30]);
        %         legend('1 Cello/Piano','2','3','4','5','6','7','8');
        legend('1 NoSeqProd','2 NoSeqProd','3','4 Grade7Piano','5','6','7 Grade4Flute','8','9');
        %         xticks([1 2]);
        %         xticklabels({'DCD', 'Control'});
        %         legend('DCD','Control')
        
        figure;
        %         subplot(1,13,subjectID);
        
        lineplot(G.probeTargetPos(G.group==2), G.probeRTrel(G.group==2),'split',G.subject(G.group==2),'style_thickline','leg','auto');
        title('RT subject(control)');
        ylabel('RT increase(%)');
        %         ylim([-10 35]);
        legend('1 Cello/Piano','2','3','4','5','6','7','8');
        
        figure;
        %         subplot(1,33,subjectID);
        lineplot(G.probeTargetPos, G.probeRTrel,'split', G.group,'style_thickline','leg','auto');
        title ('RT group');
        ylabel('RT increase(%)');
        legend('DCD','Control');
        %                 ylim([0 15]);
        figure;
        %         subplot(1,13,subjectID);
        lineplot(G.probeTargetPos(G.subject==15), G.probeRTrel(G.subject==15),'style_thickline','leg','auto');
        title('RT subject');
        ylabel('RT increase(%)');
        
        % ylim([0,10]);
        set(gca,'Fontsize',16)
        
        K=tapply(B,{'group','subject','probeTargetPos'},{B.RT(:,1),'nanmedian','name','probeRTmedian'});
        
        K.probeRTrel=nan(size(K.subject,1),1);
        
        
        for position=1:4
            RTbase=K.probeRTmedian&K.probeTargetPos==position;
            K.probeRTrel=(K.probeRTmedian/RTbase - 1)*100;
        end
        figure;
        subplot(1,33,subjectID);
        lineplot(K.probeTargetPos, K.probeRTrel,'split',K.subject,'style_thickline','leg','auto');
        title('RT subject');
        ylabel('RT increase(%)');
        
    case 'relativeError'
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A')
        
        T=tapply(A,{'subject'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20);
        V=tapply(A,{'subject'},{A.RT(:,1),'std','name','probeRTstd'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20);
        
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            B.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==2&A.points>0&A.day==3&A.TN>20);
        end
        
        B.outlier=[];
        subjID=unique((T.subject));
        for subj=1:length(subjID)
            catHolder=A.RT(A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subject==subj)>(T.probeRTmedian(subj,1)+3*(V.probeRTstd(subj,1)));
            B.outlier = [B.outlier; catHolder];
        end
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            B.(fieldnames{i})(B.outlier==1) = [];
        end
        
        %         for i=1:length(A.RT)
        %
        %             disp(A.RT(i))
        %
        %
        %         end
        %
        %                 A.ErrorTrial = 1 - A.ErrorTrial;
        %         T=tapply(B,{'group','subject','probeTargetPos'},{B.ErrorTrial(:,1),'sum','name','probeErrorSum'},'subset',B.subject~=1&B.subject~=2&B.subject~=3&B.subject~=4&B.subject~=6&B.subject~=7&B.subject~=8&B.subject~=9&B.subject~=14&B.subject~=16&B.subject~=26&B.subject~=27&B.subject~=28&B.subject~=29&B.subject~=30&B.subject~=31);
        T=tapply(B,{'group','subject','probeTargetPos'},{B.ErrorTrial(:,1),'sum','name','probeErrorSum'},'subset',B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=16&B.subject~=19&B.subject~=34); % participants removed who didn't understand the task
        %          T=tapply(B,{'group','subject','probeTargetPos'},{B.ErrorTrial(:,1),'sum','name','probeErrorSum'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=16&B.subject~=19&B.subject~=33); % not enough instructed trials completed
        T=tapply(B,{'group','subject','probeTargetPos'},{B.ErrorTrial(:,1),'sum','name','probeErrorSum'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=34&B.subject~=7&B.subject~=11); % participants removed that have ADHD
        %          T=tapply(B,{'group','subject','probeTargetPos'},{B.ErrorTrial(:,1),'sum','name','probeErrorSum'},'subset',B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=34&B.subject~=2&B.subject~=16&B.subject~=28&B.subject~=30&B.subject~=21&B.subject~=22&B.subject~=25&B.subject~=3&B.subject~=4&B.subject~=7&B.subject~=8); % not enough sequence trials
        %         B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=33&B.subject~=2&B.subject~=16&B.subject~=28&B.subject~=30&B.subject~=21&B.subject~=22&B.subject~=25&B.subject~=3&B.subject~=4&B.subject~=7&B.subject~=8
        %         L=tapply(A,{'group','subject','probeTargetPos'},{A.RT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==2&A.points>0&A.day==3&A.TN>20&A.subject~=1&A.subject~=2&A.subject~=3&A.subject~=4&A.subject~=6&A.subject~=7&A.subject~=8&A.subject~=9&A.subject~=14&A.subject~=16&A.subject~=26&A.subject~=27&A.subject~=28&A.subject~=29&A.subject~=30&A.subject~=31);
        
        T.rawError=29-T.probeErrorSum;
        figure;
        subplot(1,1,1);
        lineplot(T.probeTargetPos, T.rawError,'split',T.group,'style_thickline','leg','auto');
        title ('Errors');
        ylabel('Number of errors');
        legend('DCD','Control');
        
        T.rawErrorRates=T.rawError./29;
        T.rawErrorPercent=T.rawErrorRates*100;
        figure;
        subplot(1,1,1);
        lineplot(T.probeTargetPos, T.rawErrorPercent,'split',T.group,'style_thickline','leg','auto');
        title ('% of errors for each position');
        ylabel('Errors(%)');
        legend('DCD','Control');
        
        figure;
        subplot(1,3,1);
        lineplot(T.probeTargetPos, T.probeErrorSum,'split', T.group,'style_thickline','leg','auto');
        title ('Number of correct presses for probe trials');
        ylabel('Number of correct trials');
        
        figure;
        subplot(1,3,1);
        lineplot(T.probeTargetPos(T.group==1), T.probeErrorSum(T.group==1),'split', T.subject(T.group==1),'style_thickline','leg','auto');
        title ('Number of correct presses for probe trials (DCD)');
        ylabel('Number of correct trials');
        legend('1', '2','3','4','5','6','7','8','9','10(outlier)','11');
        ylim([0 30]);
        
        subplot(1,2,2);
        lineplot(T.probeTargetPos(T.group==2), T.probeErrorSum(T.group==2),'split', T.subject(T.group==2),'style_thickline','leg','auto');
        title ('Number of correct presses for probe trials (Control)');
        ylabel('Number of correct trials');
        legend('12', '13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33');
        ylim([0 30]);
        %         ylim([400 600]);
        
        
        T.probeErrorrel=nan(size(T.subject,1),1);
        
        subjectID=unique((T.subject));
        for subj=1:length(subjectID)
            Errorbase=T.probeErrorSum(T.subject==subjectID(subj)&T.probeTargetPos==1,1);
            T.probeErrorrel(T.subject==subjectID(subj),1)=(T.probeErrorSum(T.subject==subjectID(subj),1)/Errorbase-1 )*100;
            if any(isnan(T.probeErrorrel(T.subject==subjectID(subj),1)))
                nans = isnan(T.probeErrorrel);
                T.probeErrorrel(nans) = 0;
            end
            if any(isinf(T.probeErrorrel(T.subject==subjectID(subj),1)))
                infs = isinf(T.probeErrorrel);
                T.probeErrorrel(infs) = 0;
            end
        end
        %         T.probeErrorrel = ((T.probeErrorrel*-1)-100)*-1;
        
        T.probeErrorrel = (T.probeErrorrel*-1);
        
        figure;
        %         subplot(1,34,subjectID);
        lineplot(T.probeTargetPos, T.probeErrorrel,'split', T.group,'style_thickline','leg','auto');
        title ('Relative Error');
        ylabel('Relative Error(%)');
        legend('DCD','Control');
        %         ylim([0 15]);
        
        figure;
        %         subplot(1,2,1);
        lineplot(T.probeTargetPos(T.group==1), T.probeErrorrel(T.group==1),'split', T.subject(T.group==1),'style_thickline','leg','auto');
        title ('Relative Error (DCD)');
        ylabel('Relative Error(%)');
        %         legend('1 NoSeqProd','2 NoSeqProd','3','4 Grade7Piano','5','6','7 Grade4Flute','8','9');
        legend('3','4','5','7','8','10','11');
        legend('2','3','4','5','8','10'); % participants without ADHD
        %         legend('5','10','11'); % enough sequence trials
        ylim([-25 50]);
        %         ylim([0 50]);
        
        figure;
        %         subplot(1,2,2);
        lineplot(T.probeTargetPos(T.group==2), T.probeErrorrel(T.group==2),'split', T.subject(T.group==2),'style_thickline','leg','auto');
        title ('Relative Error (Control)');
        ylabel('Relative Error(%)');
        legend('1 Cello/Piano','2','3','4','5','6','7','8');
        legend('12','13','15',',16','17','18','20','21','22','23','24','25','28','30','32')
        %         legend('19','34'); % enough sequence trials
        
        ylim([-25 50]);
        %         ylim([0 50]); % not enough sequence trials
        
        figure;
        %         subplot(1,2,2);
        lineplot(T.probeTargetPos(T.group==3), T.probeErrorrel(T.group==3),'split', T.subject(T.group==3),'style_thickline','leg','auto');
        title ('Relative Error (Control)');
        ylabel('Relative Error(%)');
        legend('1 Cello/Piano','2','3','4','5','6','7','8');
        legend('12','13','15',',16','17','18','20','21','22','23','24','25','28','30','32')
        legend('12','13','15','17','18','20','23','24','32'); % enough sequence trials
        
        %         ylim([-25 50]);
        
        figure;
        %         CAT.markertype={'v','^'};
        CAT.linecolor=...
            {[0 0 0],[0 0 1]};
        CAT.markercolor=...
            {[0 0 0],[0 0 1]};
        CAT.markerfill=...
            {[0 0 0],[0 0 1]};
        lineplot([T.probeTargetPos],T.probeErrorrel,...
            'split',T.group,...
            'CAT',CAT)
        % 'CAT',CAT)
        
        
    case 'Error'
        
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A') %load A
        
        
        A.NumError=zeros(length(A.ErrorTrial),1);
        
        for i=1:length(A.ErrorTrial)
            if A.ErrorTrial(i)==1
                A.NumError(i)=0;
            else
                A.NumError(i)=1;
            end
        end
        
        figure;
        T=tapply(A,{'subject','group'},{A.NumError,'sum','name','MemCorrect'},'subset',A.day==3&A.trialType==3&A.TN>20&A.subject~=1&A.subject~=6&A.subject~=9&A.subject~=14&A.subject~=26&A.subject~=27&A.subject~=29&A.subject~=31&A.subject~=16&A.subject~=19&A.subject~=34); %excluding participants that did not understand or scored high on ADC checklist in control group
        T=tapply(A,{'subject','group'},{A.NumError,'sum','name','MemCorrect'},'subset',A.day==3&A.trialType==3&A.TN>20&A.subject~=1&A.subject~=6&A.subject~=9&A.subject~=14&A.subject~=26&A.subject~=27&A.subject~=29&A.subject~=31&A.subject~=19&A.subject~=16&A.subject~=34&A.subject~=2&A.subject~=16&A.subject~=28&A.subject~=30&A.subject~=21&A.subject~=22&A.subject~=25&A.subject~=3&A.subject~=4&A.subject~=7&A.subject~=8);
        
        
        T.percentage =[];
        subjectID=unique((T.subject));
        for subj=1:length(subjectID)
            catHolder=T.MemCorrect(T.subject==subjectID(subj))./140;
            T.percentage = [T.percentage; catHolder];
        end
        T.percentage=T.percentage*100;
        
        myboxplot(T.group,T.percentage,...
            'split',T.group,...
            'style_tukey',...
            'leg','auto','xtickoff')
        title ('Error for seqeunce Trials');
        ylabel('Percentage of Errors(%)');
        xlabel('Group')
        xticklabels({'DCD', 'Control'});
        legend('DCD','Control')
        
        figure;
        scatterplot(T.subject(T.group==1),T.percentage(T.group==1),...
            'split',T.subject(T.group==1),...
            'leg','auto')
        title ('Error for seqeunce Trials (DCD)');
        ylabel('Percentage of Errors(%)');
        xlabel('Group')
        % xticklabels({'1', '2','3','4','5','6','7','8','9','10','11'});
        % legend('DCD','Control')
        
        figure;
        scatterplot(T.subject(T.group==2),T.percentage(T.group==2),...
            'split',T.subject(T.group==2),...
            'leg','auto')
        title ('Error for seqeunce Trials (Control)');
        ylabel('Percentage of Errors(%)');
        xlabel('Group')
        
    case 'violinplots'
        
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A')
        
        
        T=tapply(A,{'subject'},{A.seqProd(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==3&A.points>0&A.day==3&A.TN>20);
        V=tapply(A,{'subject'},{A.seqProd(:,1),'std','name','probeRTstd'},'subset',A.trialType==3&A.points>0&A.day==3&A.TN>20);
        
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            J.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==3&A.points>0&A.day==3&A.TN>20);
        end
        
        J.outlier=[];
        subjID=unique((T.subject));
        for subj=1:length(subjID)
            catHolder=A.seqProd(A.trialType==3&A.points>0&A.day==3&A.TN>20&A.subject==subj)>(T.probeRTmedian(subj,1)+3*(V.probeRTstd(subj,1)));
            J.outlier = [J.outlier; catHolder];
        end
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            J.(fieldnames{i})(J.outlier==1) = [];
        end
        
        T=tapply(J,{'group','subject'},{J.seqProd,'nanmedian','name','seqProdmedian'},'subset',J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33&J.subject~=7&J.subject~=11&J.subject~=2&J.subject~=34);
        %         % without ADHD
        T=tapply(J,{'group','subject'},{J.seqProd,'nanmedian','name','seqProdmedian'},'subset',J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33&J.subject~=2&J.subject~=16&J.subject~=28&J.subject~=30&J.subject~=21&J.subject~=22&J.subject~=25&J.subject~=3&J.subject~=4&J.subject~=7&J.subject~=8&J.subject~=34&J.subject~=11); %not enough sequence trials
        %         T=tapply(J,{'group','subject'},{J.seqProd,'nanmedian','name','seqProdmedian'},'subset',J.trialType==3&J.points>0&J.day==3&J.TN>20&J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33&J.subject~=34); % no understand and not enough instructed
        %         B.trialType==2&B.points>0&B.day==3&B.TN>20&B.subject~=1&B.subject~=6&B.subject~=9&B.subject~=14&B.subject~=26&B.subject~=27&B.subject~=29&B.subject~=31&B.subject~=19&B.subject~=16&B.subject~=33&B.subject~=2
        %         T=tapply(J,{'group','subject'},{J.seqProd,'nanmedian','name','seqProdmedian'});
        T.seqProdmedian = T.seqProdmedian*1000;
        figure;
        myboxplot(T.group,T.seqProdmedian,...
            'split',T.group,...
            'style_tukey',...
            'leg','auto',...
            'xtickoff')
        % title ('Movement Time (ms) ');
        ylabel('Movement Time (ms)');
        xlabel('Group')
        xticks([1,2]);
        xticklabels({'DCD', 'Control'});
        legend('DCD','Control')
        
        
        T=tapply(A,{'subject'},{A.firstKeyRT(:,1),'nanmedian','name','probeRTmedian'},'subset',A.trialType==3&A.points>0&A.day==3&A.TN>20);
        V=tapply(A,{'subject'},{A.firstKeyRT(:,1),'std','name','probeRTstd'},'subset',A.trialType==3&A.points>0&A.day==3&A.TN>20);
        
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            J.(fieldnames{i}) = A.(fieldnames{i})(A.trialType==3&A.points>0&A.day==3&A.TN>20);
        end
        
        J.outlier=[];
        subjID=unique((T.subject));
        for subj=1:length(subjID)
            catHolder=A.seqProd(A.trialType==3&A.points>0&A.day==3&A.TN>20&A.subject==subj)>(T.probeRTmedian(subj,1)+3*(V.probeRTstd(subj,1)));
            J.outlier = [J.outlier; catHolder];
        end
        
        fieldnames = fields(A);
        
        for i=1:numel(fieldnames)
            J.(fieldnames{i})(J.outlier==1) = [];
        end
        
        
        %           T=tapply(J,{'group','subject'},{J.firstKeyRT,'nanmedian','name','seqInitiationmedian'},'subset',J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33&J.subject~=7&J.subject~=11&J.subject~=2&J.subject~=34);
        %         no ADHD
        T=tapply(J,{'group','subject'},{J.firstKeyRT,'nanmedian','name','seqInitiationmedian'},'subset',J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33&J.subject~=2&J.subject~=16&J.subject~=28&J.subject~=30&J.subject~=21&J.subject~=22&J.subject~=25&J.subject~=3&J.subject~=4&J.subject~=7&J.subject~=8&J.subject~=34); % not enough sequence trials
        %          T=tapply(J,{'group','subject'},{J.firstKeyRT,'nanmedian','name','seqInitiationmedian'});
        %          T=tapply(J,{'group','subject'},{J.firstKeyRT,'nanmedian','name','seqInitiationmedian'},'subset',J.trialType==3&J.points>0&J.day==3&J.TN>20&J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33&J.subject~=2&J.subject~=34);
        %         T=tapply(J,{'group','subject'},{J.firstKeyRT,'nanmedian','name','seqInitiationmedian'},'subset',J.subject~=1&J.subject~=6&J.subject~=9&J.subject~=14&J.subject~=26&J.subject~=27&J.subject~=29&J.subject~=31&J.subject~=19&J.subject~=16&J.subject~=33);% didn't understand the task
        
        T.seqInitiationmedian = T.seqInitiationmedian*1000;
        figure;
        myboxplot(T.group,T.seqInitiationmedian,...
            'split',T.group,...
            'style_tukey',...
            'leg','auto','xtickoff')
        % title ('Movement Time (ms) ');
        ylabel('Sequence Initiation (ms)');
        xlabel('Group')
        xticklabels({'DCD', 'Control'});
        legend('DCD','Control')
        
    case 'raster'
        
        cd(rawDir);
        filename='cqDyspraxia_dataAll.mat';
        load(filename,'A')
        
        
        
        figure;
        size(A.subject(:,1))
        
        A.spikes=[];
        subjectID=unique((A.subject));
        for subj=1:length(subjectID)
            for i=1:4
                %            A.spikes=size(A.RT(:,i));
                
                spikes=A.RT(A.subject==subjectID(subj)&A.day==3&A.trialType==3&A.points>0, i);
                %            if isempty(
                spikes = spikes';
                
                A.spikes = [A.spikes; spikes];
            end
        end
end


%         nrPressesColor=[0.75, 0, 0.75; 0, 0.5, 0; 1, 0.4, 0; 0.4 .4 .4];


end

