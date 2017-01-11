close all

figure('Position',[0,0,1800,1000]);

%kernel for averaging
B=(1/8)*ones(1,8);

%each subject
for subj=1:30
    
    disp(strcat(num2str(subj),'. subjects'))
    
    %load data
    infant_torso=csvread(strcat('../proccessed_data/timed_wear/',num2str(subj),'_infant_torso_timed_wear.csv'));
    infant_ankle=csvread(strcat('../proccessed_data/timed_wear/',num2str(subj),'_infant_ankle_timed_wear.csv'));
    
    %truncate to have same lenght in both
    infant_torso=infant_torso(1:min(length(infant_torso),length(infant_ankle)),:);
    infant_ankle=infant_ankle(1:min(length(infant_torso),length(infant_ankle)),:);
    
    %keep raw data also
    infant_torso_raw=sqrt(infant_torso(:,1).^2 +infant_torso(:,2).^2 +infant_torso(:,3).^2)-1;
    infant_ankle_raw=sqrt(infant_ankle(:,1).^2 +infant_ankle(:,2).^2 +infant_ankle(:,3).^2)-1;
    
    %correct the baseline even further since minus one for gravitation is very aproximate and can leave some gravitational effects
    infant_torso_raw=infant_torso_raw-pattern_extraction(infant_torso_raw,1000000);
    infant_ankle_raw=infant_ankle_raw-pattern_extraction(infant_ankle_raw,1000000);
    
    %extract the summary Euclidian norm minus gravitation with outliers removed and then average
    infant_torso_summary=conv(sqrt(medfilt1(infant_torso(:,1),11).^2 +medfilt1(infant_torso(:,2),11).^2 +medfilt1(infant_torso(:,3),11).^2)-1, B, 'same');
    infant_ankle_summary=conv(sqrt(medfilt1(infant_ankle(:,1),11).^2 +medfilt1(infant_ankle(:,2),11).^2 +medfilt1(infant_ankle(:,3),11).^2)-1, B, 'same');
    
    %correct the baseline even further since minus one for gravitation is very aproximate and can leave some gravitational effects
    infant_torso_summary=infant_torso_summary-pattern_extraction(infant_torso_summary,1000000);
    infant_ankle_summary=infant_ankle_summary-pattern_extraction(infant_ankle_summary,1000000);

    %-------------------------INFANT BEING MOVED CORRECTION-----------------------
    
    %prepare correction vector
    infant_torso_summary_correction=zeros(length(infant_torso_summary),1);
    infant_ankle_summary_correction=zeros(length(infant_ankle_summary),1);
    
    %go over windows of seconds length and a step size of window_step seconds*40
    seconds=60;
        
    window_length=seconds*40;
    window_step=400;
    
    %prepare plot
    clf
    subplot(2,1,1)
    plot(infant_torso_summary)
    subplot(2,1,2)
    plot(infant_ankle_summary)   
    
    %go over with sliding window
    window_index=1;  
    for window=1:window_step:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %if std is large, infant is being moved
        if (std(infant_torso_summary(window:window_end))>0.005 && std(infant_ankle_summary(window:window_end))>0.005)
            
            %plot it red
            subplot(2,1,1)
            hold on
            plot(window:window_end, infant_torso_summary(window:window_end),'r-')
            subplot(2,1,2)
            hold on
            plot(window:window_end, infant_ankle_summary(window:window_end),'r-')
            
            %set indexes
            infant_torso_summary_correction(window:window_end)=ones(length(infant_torso_summary(window:window_end)),1);
            infant_ankle_summary_correction(window:window_end)=ones(length(infant_ankle_summary(window:window_end)),1);
            
        end
        window_index=window_index+1;    
    end
    
    %summary output
    %get number of total minutes of infant being moved
    total_minutes=length(infant_torso_summary_correction(infant_torso_summary_correction==1))/2400;
    total_minutes_check=length(infant_torso_summary_correction(infant_torso_summary_correction==1))/2400;
    
    %get starts of caretakers movement blocks and ends
    being_moved_start_end=[find(diff([0;infant_torso_summary_correction])==1)+1 find(diff([infant_torso_summary_correction;0])==-1)];
    mean_being_moved=mean(being_moved_start_end(:,2)-being_moved_start_end(:,1)+1)/2400;
    min_being_moved=min(being_moved_start_end(:,2)-being_moved_start_end(:,1)+1)/2400;
    max_being_moved=max(being_moved_start_end(:,2)-being_moved_start_end(:,1)+1)/2400;
    std_being_moved=std(being_moved_start_end(:,2)-being_moved_start_end(:,1)+1)/2400;
    being_moved_blocks={};
    being_moved_intensity=[];
    for block=1:length(being_moved_start_end(:,1))
        being_moved_blocks{block}=infant_torso_summary(being_moved_start_end(block,1):being_moved_start_end(block,2));
        being_moved_intensity(block)=sum(abs(infant_torso_raw(being_moved_start_end(block,1):being_moved_start_end(block,2))))/length(infant_torso_raw(being_moved_start_end(block,1):being_moved_start_end(block,2)));
    end
    
    disp(strcat([num2str(subj),'. subjects had all together ', num2str(round(total_minutes,1)),' (',num2str(round(total_minutes_check,1)),') ',' minutes of infant being moved by third person removed']))
    disp(' ')
    disp(strcat(['Average duration of caretakers movement: ', num2str(round(mean_being_moved,1)),' minutes with minimum at ', num2str(round(min_being_moved,1)),' minutes and maximum at ',num2str(round(max_being_moved,1)),' minutes with std ', num2str(round(std_being_moved,1)), ' minutes']))
    disp(' ')
    disp(strcat(['Average intensity of caretakers movement: ',num2str(round(mean(being_moved_intensity),5)),' with minimum at ', num2str(round(min(being_moved_intensity),3)),' maximum at ',num2str(round(max(being_moved_intensity),3)),' and std ', num2str(round(std(being_moved_intensity),3))]))
    disp(' ')
    disp(' ')
    disp(' ')
    
    %add data to plot and save it
    subplot(2,1,1)
    title({strcat([num2str(subj), '. subjects with ', num2str(round(total_minutes,1)),' of infant being moved by third person']),' ',' ','infant torso'})                        
    xlabel('hours')
    ylabel('g')
    set(gca,'XTick',[0:288000:length(infant_torso_summary)+1]);
    set(gca,'XTickLabel',cellstr(num2str([0:2:48]')))
    legend('infant torso','infant being moved')
    ylim([min([infant_torso_summary;infant_ankle_summary]) max([infant_torso_summary;infant_ankle_summary])]) 
    subplot(2,1,2)
    title('infant ankle');
    xlabel('hours')
    ylabel('g')
    set(gca,'XTick',[0:288000:length(infant_ankle_summary)+1]);
    set(gca,'XTickLabel',cellstr(num2str([0:2:48]')))
    legend('infant ankle','infant being moved')
    ylim([min([infant_torso_summary;infant_ankle_summary]) max([infant_torso_summary;infant_ankle_summary])]) 
    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/being_moved/F/',num2str(subj), '_subject_final_plot.png'))
    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/being_moved/F/',num2str(subj), '_subject_final_plot.fig'))
    
    %get indexes for timestamp extraction(done in python)
    infant_torso_movement_i=find(infant_torso_summary_correction==1)-1;
    infant_ankle_movement_i=find(infant_ankle_summary_correction==1)-1;
    csvwrite(strcat('../proccessed_data/being_moved/',num2str(subj),'_infant_torso_being_moved_F_i.csv'),infant_torso_movement_i);    
    csvwrite(strcat('../proccessed_data/being_moved/',num2str(subj),'_infant_ankle_being_moved_F_i.csv'),infant_ankle_movement_i);
    
    %correct the signals and save the result 
    infant_torso_summary_final=infant_torso_summary(infant_torso_summary_correction==0);
    infant_ankle_summary_final=infant_ankle_summary(infant_ankle_summary_correction==0);
    csvwrite(strcat('../proccessed_data/being_moved/',num2str(subj),'_infant_torso_being_moved_F.csv'),infant_torso_summary_final);    
    csvwrite(strcat('../proccessed_data/being_moved/',num2str(subj),'_infant_ankle_being_moved_F.csv'),infant_ankle_summary_final);
    
    %get the indexes for ploting
    infant_ankle_indexes=1:length(infant_ankle_summary);
    infant_ankle_indexes=infant_ankle_indexes(infant_ankle_summary_correction==0);
    
    %-------------------------END OF INFANT BEING MOVED CORRECTION-----------------------
    
    %-------------------------INFANT VARIABLES-----------------------
    
    %-------------------------PA-----------------------
    
    %look at the remaining signal and extract infants activity over windows of 60 seconds with step 10 seconds
    
    seconds=60;
        
    window_length=seconds*40;
    window_step=400;
    
    %go over with sliding window
    window_index=1;  
    for window=1:window_step:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %if std is large, infant is active
        if (std(infant_ankle_summary_final(window:window_end))>0.005)
            
            %plot it green
            subplot(2,1,2)
            hold on
            plot(infant_ankle_indexes(window:window_end), infant_ankle_summary(window:window_end),'g-')
            
        end
        window_index=window_index+1;    
    end
    
end
                