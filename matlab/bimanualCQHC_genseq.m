function cqPD_genseq

% addpath(genpath('C:\Users\bugsy\OneDrive\Documents\University\PhD\3rd Year\PD Online Study\cqPD\matlab')) %paths to add, Rhys' oneDrive
% addpath(genpath('E:\projects\toolboxes'))
% addpath(genpath('C:\Users\yewbreyr\OneDrive\Documents\University\PhD\3rd Year\PD Online Study\cqPD')) %Rhys CHBH PC

%Generate sequences for online PD study and test according to a
%number of contraints. Runs through a series of cases, checking one
%constraint each time. If at any point the sequence doesn't match the
%constraints, this script generates a new sequence and starts again.

seqNum=2; %2 sequences, one on the left hand and one on the right.
seqNew = [1,2,3,4]; % 4 element sequences, index to pinkie fingers.

state=1; % variable that allows progression through switch cases
i=0; % variable that tracks the current number of eligible sequences generated

while i<seqNum %number of sequences
    
    switch(state)
        
        case 1 %%% Shuffle new sequence
            seq = seqNew;
            untrained=seq(randperm(length(seq)));
            if i<=3
                firstDigit(i+1)=untrained(1,1); %write out first digit
            end
            state=state+1; 
            
        case 2 %%% check whether the first element is different across sequences
%             disp(i);
            if i>0 && i<=3 
                %First
                if ismember(untrained(:,1),firstDigit(1:i)) %& any(check_trans~=0)
                    state=1;%generate new sequence
                else
                    state=state+1;
                end

            else
                state=state+1;
            end
        case 3 %%% Exclude sequences that have (ascending or descending) triplets
            
            %%% Determine triplets
            sorted=0;
            for j=1:2 %for 4 intervals
                %ascending order
                subset=untrained(1,j:j+2);
                nr=issorted(subset);
                %descending order
                subset_flip=fliplr(untrained(1,j:j+2));
                nr_flip=issorted(subset_flip);
                sorted=sorted+nr+nr_flip;
            end

            if sorted>0 %%% Exclude triplets
                state=1; %generate new sequence
            else
                if i==0
                    seqPool=untrained; %write out first sequence
                    i=i+1;
                    state=1; %generate next sequence
                else
                    state=state+1;
                end
            end
            
        case 4 %%% Exclude sequences that are the same (Control sequences)   %in case we update parameter case 2 to different first element in training sequences only 
            untrained_rep=repmat(untrained,size(seqPool,1),1);
            diff_seq=seqPool-untrained_rep;
            check_diff=all(diff_seq==0,2); % is there a row in which all elements are 0
            check_diff=any(check_diff==1);
            
            if check_diff>0
                state=1;
            else
                state=state+1;
            end
            
        case 5 %%% check if the sequences match in extrinsic space - for bimanual task only.
            % reference doi:10.1523/JNEUROSCI.5363-13.2014 
            
            refMatrix = [1,4; 2,3; 3,2; 4,1];
            seqPoolMirror = refMatrix(seqPool,2);
            
            if untrained == seqPoolMirror
                state=1;
            else
                state = state + 1;
            end
            
        case 6 %%% check that sequences aren't mirrors of one another
            
            if untrained == flip(seqPool)
                state=1;
            else
                state = state + 1;
            end
            
        case 7 %%% check that no sequence positions match presses
            
            anymatches(1) = seqPool(1) == untrained(1);
            anymatches(2) = seqPool(2) == untrained(2);
            anymatches(3) = seqPool(3) == untrained(3);
            anymatches(4) = seqPool(4) == untrained(4);
            
            if any(anymatches)
                state = 1;
            else
                state = state + 1;
            end
                
        case 8 %%% Collect sequences into seqPool;
            seqPool=[seqPool;untrained];
            i=i+1;
            state=1;   
    end
end

disp(seqPool)

% %%% OUT:
% if dim==1
%     gExp.temp(1:length(seqPool),1:length(seq))=0;
%     gExp.temp=seqPool;
%     %     for i=2:max(seq)
%     %         gExp.temp(gExp.temp==i)=seqT(i); %replace digits by intervals
%     %     end;
%     for i=1:size(gExp.temp)
%         gExp.temp(i,:)=seqT(i,:); %replace digits by intervals by row (over 10 rows)
%     end
%     % Overwrite first column to be equal to a vector of zeros:
%     %gExp.temp(:,1)=0; %As option to kill the first interval
%     display(gExp.temp);
%     dsave(outfileTemp,gExp);
%     
% elseif dim==2
%     gExp.ord(1:length(seqPool),1:length(seq))=0;
%     gExp.ord=seqPool;
%     display(gExp.ord);
%     dsave(outfileOrd,gExp);
% end

clearvars
