close all

figure('Position',[0,0,1800,1000]);

for subj=1:5
    
    disp(strcat(num2str(subj),'. subjects'))
    
    infant_torso=csvread(strcat('../proccessed_data/timed_wear/',num2str(subj),'_infant_torso_timed_wear.csv'));
    infant_ankle=csvread(strcat('../proccessed_data/timed_wear/',num2str(subj),'_infant_ankle_timed_wear.csv'));
    
    %extract the summary Euclidian norm minus gravitation with outliers removed first
    infant_torso_summary=sqrt(hampel(infant_torso(:,1),11).^2 +hampel(infant_torso(:,2),11).^2 +hampel(infant_torso(:,3),11).^2)-1;
    infant_ankle_summary=sqrt(hampel(infant_ankle(:,1),11).^2 +hampel(infant_ankle(:,2),11).^2 +hampel(infant_ankle(:,3),11).^2)-1;
    
    %correct the baseline even further since minus one for gravitation is very aproximate and can leave some gravitational effects
    infant_torso_summary=infant_torso_summary-pattern_extraction(infant_torso_summary,1000000);
    infant_ankle_summary=infant_ankle_summary-pattern_extraction(infant_ankle_summary,1000000);
    
    infant_torso_summary_correction=zeros(length(infant_torso_summary),1);
    infant_ankle_summary_correction=zeros(length(infant_ankle_summary),1);
    %examine correlation between the summary of all axis in torso and ankle-----------------------------------
    
    %go over windows of seconds length and a step size of 2 seconds
    seconds=10;
    
    disp(strcat([num2str(seconds),' seconds windowed correlation']))
    
    window_length=seconds*40;
    window_step=80;
    
    random_correlations=[];
    window_index=1;  
    for window=1:window_step:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        window_end_q=min([window+window_length-window_step-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %check several pattern extraction weights(from tight-fit to loose), correlate only if equal variance, break as soon as there is at least 0.5 correlation
        weights=[0.1:0.1:5];
        
        pattern_correlation=0;
        pattern_p=1;
                    
        for weight=1:length(weights)
            
            %extract pattern
            infant_torso_summary_pattern=pattern_extraction(infant_torso_summary(window:window_end),weights(weight));
            infant_ankle_summary_pattern=pattern_extraction(infant_ankle_summary(window:window_end),weights(weight));
      
            if(~vartest2(infant_torso_summary_pattern,infant_ankle_summary_pattern))
                  
                %correlate
                [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);

                if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)

    %                 %check assumptions for correlation
    %                 if swtest(infant_torso_summary_pattern, 0.05)
    %                     disp('infant torso data not normaly distributed')
    %                     clf
    %                     hist((infant_torso_summary_pattern-mean(infant_torso_summary_pattern))/std(infant_torso_summary_pattern))
    %                     saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_infant_torso_normality.png'))
    %                 end
    % 
    %                 if swtest(infant_ankle_summary_pattern, 0.05)
    %                     disp('infant ankle data not normaly distributed')
    %                     clf
    %                     hist((infant_ankle_summary_pattern-mean(infant_ankle_summary_pattern))/std(infant_ankle_summary_pattern))
    %                     saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_infant_ankle_normality.png'))
    %                 end
    % 
    %                 if vartest2(infant_torso_summary_pattern,infant_ankle_summary_pattern)
    %                     disp('variance is not equal')
    %                     clf
    %                     scatter(infant_torso_summary_pattern,infant_ankle_summary_pattern)
    %                     saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_variation.png'))
    %                 end

                    %display correlation, baseline param and random correlation
                    [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                    random_correlations=[random_correlations R];
                    disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))

                    %always take biggest variation for four fifths and keep the final fifth as is 
                    infant_torso_summary_correction(window:window_end_q)=(std(infant_torso_summary_pattern(1:length(infant_torso_summary_correction(window:window_end_q))))>std(infant_torso_summary_correction(window:window_end_q)))*infant_torso_summary_pattern(1:length(infant_torso_summary_correction(window:window_end_q)))+(std(infant_torso_summary_pattern(1:length(infant_torso_summary_correction(window:window_end_q))))<std(infant_torso_summary_correction(window:window_end_q)))*infant_torso_summary_correction(window:window_end_q);
                    infant_ankle_summary_correction(window:window_end_q)=(std(infant_ankle_summary_pattern(1:length(infant_ankle_summary_correction(window:window_end_q))))>std(infant_ankle_summary_correction(window:window_end_q)))*infant_ankle_summary_pattern(1:length(infant_ankle_summary_correction(window:window_end_q)))+(std(infant_ankle_summary_pattern(1:length(infant_ankle_summary_correction(window:window_end_q))))<std(infant_ankle_summary_correction(window:window_end_q)))*infant_ankle_summary_correction(window:window_end_q);
                    infant_torso_summary_correction(min(window_end_q+1,window_end):window_end)=infant_torso_summary_pattern(min(window_length-window_step+1,length(infant_torso_summary_pattern)):length(infant_torso_summary_pattern));
                    infant_ankle_summary_correction(min(window_end_q+1,window_end):window_end)=infant_ankle_summary_pattern(min(window_length-window_step+1,length(infant_ankle_summary_pattern)):length(infant_ankle_summary_pattern));

                    %display and save as subplots
                    clf
                    s1=subplot(2,3,1);
                    s1_position=s1.Position;
                    s1_position(1)=0.05;
                    s1_position(3)=0.36;
                    s1_position(2)=s1_position(2)-0.03;
                    subplot('Position',s1_position)
                    plot(window:window_end, infant_torso_summary(window:window_end))
                    hold on
                    plot(window:window_end, infant_torso_summary_pattern,'r')
                    title('infant torso')            
                    xlabel('seconds')
                    ylabel('g')
                    set(gca,'XTick',[window:40:window_end+1]-1);
                    set(gca,'XTickLabel',cellstr(num2str([0:seconds+1]')))
                    legend('infant torso','correlated signal')
                    ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
                    s2=subplot(2,3,4);
                    s2_position=s2.Position;
                    s2_position(1)=0.05;
                    s2_position(3)=0.36;
                    s2_position(2)=s2_position(2)-0.03;
                    subplot('Position',s2_position)
                    plot(window:window_end, infant_ankle_summary(window:window_end))
                    hold on
                    plot(window:window_end, infant_ankle_summary_pattern,'r')
                    title('infant ankle');
                    xlabel('seconds')
                    ylabel('g')
                    set(gca,'XTick',[window:40:window_end+1]-1);
                    set(gca,'XTickLabel',cellstr(num2str([0:seconds+1]')))
                    legend('infant ankle','correlated signal')
                    ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
                    s3=subplot(2,3,2);
                    s3_positions=s3.Position;
                    s3_positions(1)=s3_positions(1)+0.05;
                    s3_position(2)=s3_position(2)-0.03;
                    subplot('Position',s3_positions)
                    qqplot(infant_torso_summary_pattern)
                    title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window with pattern weight ', num2str(weights(weight)), ' correlation ',num2str(round(pattern_correlation,2)),' and p value ',num2str(pattern_p)]),' ',' ','infant torso qq plot'})            
                    s4=subplot(2,3,5);
                    s4_positions=s4.Position;
                    s4_positions(1)=s4_positions(1)+0.05;
                    s4_position(2)=s4_position(2)-0.03;
                    subplot('Position',s4_positions)                    
                    qqplot(infant_ankle_summary_pattern)
                    title('infant ankle qq plot');
                    s5=subplot(2,3,[3,6]);
                    s5_position=s5.Position;
                    s5_position(1)=s5_position(1)+0.02;
                    s5_position(3)=s5_position(3)+0.05;
                    s5_position(2)=s5_position(2)-0.03;
                    subplot('Position',s5_position)
                    scatter(infant_ankle_summary_pattern, infant_torso_summary_pattern)
                    title('infant ankle VS infant torso');
                    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_window_',num2str(seconds),'sec_correlation.png'))
                    break;
                end
            end
        end
        window_index=window_index+1;    
    end
    
    %summary output
    %get number of total minutes
    total_minutes=length(infant_torso_summary_correction(infant_torso_summary_correction~=0))/2400;
    total_minutes_check=length(infant_torso_summary_correction(infant_torso_summary_correction~=0))/2400;
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(round(total_minutes,1)),' (',num2str(round(total_minutes_check,1)),') ',' minutes of infant being moved by third person detected']))
    
    %get indexes for timestamp extraction(done in python)
    infant_torso_movement_i=infant_torso_summary_correction~=0;
    infant_ankle_movement_i=infant_ankle_summary_correction~=0;
    
    %correct the signals
    infant_torso_summary_final=infant_torso_summary-infant_torso_summary_correction;
    infant_ankle_summary_final=infant_ankle_summary-infant_ankle_summary_correction;
    
    %summary plot
    clf
    subplot(2,1,1)
    plot(infant_torso_summary)
    hold on
    plot(infant_torso_summary_final,'r')
    title({strcat([num2str(subj), '. subjects with ', num2str(total_minutes),' of infant being moved by third person']),' ',' ','infant torso'})                        
    xlabel('hours')
    ylabel('g')
    set(gca,'XTick',[0:288000:length(infant_torso_summary)+1]);
    set(gca,'XTickLabel',cellstr(num2str([0:2:48]')))
    legend('infant torso','corrected infant torso')
    ylim([min([infant_torso_summary;infant_ankle_summary]) max([infant_torso_summary;infant_ankle_summary])]) 
    subplot(2,1,2)
    plot(infant_ankle_summary)
    hold on
    plot(infant_ankle_summary_final,'r')
    title('infant ankle');
    xlabel('hours')
    ylabel('g')
    set(gca,'XTick',[0:288000:length(infant_ankle_summary)+1]);
    set(gca,'XTickLabel',cellstr(num2str([0:2:48]')))
    legend('infant ankle','corrected infant ankle')
    ylim([min([infant_torso_summary;infant_ankle_summary]) max([infant_torso_summary;infant_ankle_summary])]) 
    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_final_plot.png'))
    %------------------------------------------------------------------------------------------------------
    
end
                
% disp('correlations overall')
% 
% disp(strcat([num2str([1:5]'),'. infant had alltogether ',num2str(correlated_minutes'),' minutes of being moved by third person detected']))
