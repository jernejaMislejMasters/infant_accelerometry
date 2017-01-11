close all

figure('Position',[0,0,1500,900]);

for subj=1:5
    
    disp(strcat(num2str(subj),'. subjects'))
    
    infant_torso=csvread(strcat('../proccessed_data/timed/',num2str(subj),'_infant_torso_timed_wear.csv'));
    infant_ankle=csvread(strcat('../proccessed_data/timed/',num2str(subj),'_infant_ankle_timed_wear.csv'));
    
    %extract the summary Euclidian norm minus gravitation
    infant_torso_summary=sqrt(infant_torso(:,1).^2 +infant_torso(:,2).^2 +infant_torso(:,3).^2)-1;
    infant_ankle_summary=sqrt(infant_ankle(:,1).^2 +infant_ankle(:,2).^2 +infant_ankle(:,3).^2)-1;
    
    %prepare final summaries as just copies that will be corrected
    infant_torso_final_summary=infant_torso_summary;
    infant_ankle_final_summary=infant_ankle_summary;
    
    %examine correlation between the summary of all axis in torso and ankle-----------------------------------
    
    %go over several window lengths to best extract hidden correlated
    %movements---------------------------------------------------------------------------
    
    %15 minutes window
    disp('15 minutes windowed correlation')    

    window_length=36000;
    
    correlations=0;   
    random_correlations=[];
    
    window_index=1;  
    for window=1:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %check several pattern extraction weights(from tight-fit to loose) break as soon as there is at least 0.5 correlation
        weights=[3 5:5:200 225:25:500 550:50:1000 2000 3000 4000 5000];
        
        pattern_correlation=0;
        pattern_p=1;
            
        for weight=1:length(weights)
            
            %extract pattern
            infant_torso_summary_pattern=pattern_extraction(infant_torso_summary(window:window_end),weights(weight));
            infant_ankle_summary_pattern=pattern_extraction(infant_ankle_summary(window:window_end),weights(weight));

            %correlate
            [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);
            
            if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                %display correlation, baseline param and random correlation
                [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                random_correlations=[random_correlations R];
                disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))
                break;
            end
        end
        
        %if correlation significant, remove pattern from signal and save plot
        if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
            infant_torso_final_summary(window:window_end)=infant_torso_summary(window:window_end)-infant_torso_summary_pattern;
            infant_ankle_final_summary(window:window_end)=infant_ankle_summary(window:window_end)-infant_ankle_summary_pattern;
            correlations=correlations+1;
            
            %display and save as subplots
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_summary(window:window_end))
            hold on
            plot(window:window_end, infant_torso_summary_pattern,'r')
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window with pattern weight ', num2str(weights(weight)), ' correlation ',num2str(round(pattern_correlation,2)),' and p value ',num2str(pattern_p)]),' ',' ','infant torso'})
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:36000:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([0:15]')));
            legend('infant torso','correlated signal')
            ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
            subplot(2,1,2)
            plot(window:window_end, infant_ankle_summary(window:window_end))
            hold on
            plot(window:window_end, infant_ankle_summary_pattern,'r')
            title('infant ankle');
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:36000:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([0:15]')));
            legend('infant ankle','correlated signal')
            ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
            saveas(gcf,strcat('~/Desktop/CRC_project/pngs/',num2str(subj), '_subject_',num2str(window_index),'_window_15min_correlation.png'))

        end
        window_index=window_index+1;    
    end
    
    %summary output for 15 minutes window
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*15),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 15 minutes windows detected as correlated']))
  
    %set signal under examination as the final output of 15min correlation
    infant_torso_summary=infant_torso_final_summary;
    infant_ankle_summary=infant_ankle_final_summary;
    %-------------------------------------------------------------------------------------
    
    %5 minutes window
    disp('5 minutes windowed correlation')
    
    window_length=12000;
    
    correlations=0;   
    random_correlations=[];
    
    window_index=1;  
    for window=1:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %check several pattern extraction weights(from tight-fit to loose) break as soon as there is at least 0.5 correlation
        weights=[3 5:5:200 225:25:500 550:50:1000 2000 3000 4000 5000];
        
        pattern_correlation=0;
        pattern_p=1;
            
        for weight=1:length(weights)
            
            %extract pattern
            infant_torso_summary_pattern=pattern_extraction(infant_torso_summary(window:window_end),weights(weight));
            infant_ankle_summary_pattern=pattern_extraction(infant_ankle_summary(window:window_end),weights(weight));

            %correlate
            [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);
            
            if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                %display correlation, baseline param and random correlation
                [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                random_correlations=[random_correlations R];
                disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))
                break;
            end
        end
        
        %if correlation significant, remove pattern from signal and save plot
        if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
            infant_torso_final_summary(window:window_end)=infant_torso_summary(window:window_end)-infant_torso_summary_pattern;
            infant_ankle_final_summary(window:window_end)=infant_ankle_summary(window:window_end)-infant_ankle_summary_pattern;
            correlations=correlations+1;
            
            %display and save as subplots
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_summary(window:window_end))
            hold on
            plot(window:window_end, infant_torso_summary_pattern,'r')
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window with pattern weight ', num2str(weights(weight)), ' correlation ',num2str(round(pattern_correlation,2)),' and p value ',num2str(pattern_p)]),' ',' ','infant torso'})
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:12000:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([0:5]')));
            legend('infant torso','correlated signal')
            ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
            subplot(2,1,2)
            plot(window:window_end, infant_ankle_summary(window:window_end))
            hold on
            plot(window:window_end, infant_ankle_summary_pattern,'r')
            title('infant ankle');
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:12000:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([0:5]')));
            legend('infant ankle','correlated signal')
            ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
            saveas(gcf,strcat('~/Desktop/CRC_project/pngs/',num2str(subj), '_subject_',num2str(window_index),'_window_5min_correlation.png'))

        end
        window_index=window_index+1;    
    end
    
    %summary output for 5 minutes window
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*5),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 5 minutes windows detected as correlated']))
    
    %set signal under examination as the final output of 15min correlation
    infant_torso_summary=infant_torso_final_summary;
    infant_ankle_summary=infant_ankle_final_summary;
    %------------------------------------------------------------------------------------------------------
 
    
    %1 minute window
    disp('1 minute windowed correlation')
    
    window_length=2400;
    
    correlations=0;   
    random_correlations=[];
    
    window_index=1;  
    for window=1:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %check several pattern extraction weights(from tight-fit to loose) break as soon as there is at least 0.5 correlation
        weights=[3 5:5:200 225:25:500 550:50:1000 1200:200:2000];
        
        pattern_correlation=0;
        pattern_p=1;
            
        for weight=1:length(weights)
            
            %extract pattern
            infant_torso_summary_pattern=pattern_extraction(infant_torso_summary(window:window_end),weights(weight));
            infant_ankle_summary_pattern=pattern_extraction(infant_ankle_summary(window:window_end),weights(weight));

            %correlate
            [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);
            
            if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                %display correlation, baseline param and random correlation
                [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                random_correlations=[random_correlations R];
                disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))
                break;
            end
        end
        
        %if correlation significant, remove pattern from signal and save plot
        if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
            infant_torso_final_summary(window:window_end)=infant_torso_summary(window:window_end)-infant_torso_summary_pattern;
            infant_ankle_final_summary(window:window_end)=infant_ankle_summary(window:window_end)-infant_ankle_summary_pattern;
            correlations=correlations+1;
            
            %display and save as subplots
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_summary(window:window_end))
            hold on
            plot(window:window_end, infant_torso_summary_pattern,'r')
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window with pattern weight ', num2str(weights(weight)), ' correlation ',num2str(round(pattern_correlation,2)),' and p value ',num2str(pattern_p)]),' ',' ','infant torso'})            
            xlabel('seconds')
            ylabel('g')
            set(gca,'XTick',[window:400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([0:10:61]')))
            legend('infant torso','correlated signal')
            ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
            subplot(2,1,2)
            plot(window:window_end, infant_ankle_summary(window:window_end))
            hold on
            plot(window:window_end, infant_ankle_summary_pattern,'r')
            title('infant ankle');
            xlabel('seconds')
            ylabel('g')
            set(gca,'XTick',[window:400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([0:10:61]')))
            legend('infant ankle','correlated signal')
            ylim([min([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)]) max([infant_torso_summary(window:window_end);infant_ankle_summary(window:window_end)])]) 
            saveas(gcf,strcat('~/Desktop/CRC_project/pngs/',num2str(subj), '_subject_',num2str(window_index),'_window_1min_correlation.png'))
        end
        window_index=window_index+1;    
    end
    
    %summary output for 1 minutes window
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 1 minutes windows detected as correlated']))
    
    %------------------------------------------------------------------------------------------------------
    
end
                
% disp('correlations overall')
% 
% disp(strcat([num2str([1:5]'),'. infant had alltogether ',num2str(correlated_minutes'),' minutes of being moved by third person detected']))
