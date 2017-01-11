%15 minutes window 0 minutes start
    disp('15 minutes windowed correlation 0 minutes start')    

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
            
            %check for assumptions for correlation first
            if (~kstest((infant_torso_summary_pattern-mean(infant_torso_summary_pattern))/std(infant_torso_summary_pattern)) && ~kstest((infant_ankle_summary_pattern-mean(infant_ankle_summary_pattern))/std(infant_ankle_summary_pattern)) && ~vartest2(infant_torso_summary_pattern, infant_ankle_summary_pattern))

                %correlate
                [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);

                if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                    %display correlation, baseline param and random correlation
                    [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                    random_correlations=[random_correlations R];
                    disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))

                    infant_torso_summary(window:window_end)=infant_torso_summary(window:window_end)-infant_torso_summary_pattern;
                    infant_ankle_summary(window:window_end)=infant_ankle_summary(window:window_end)-infant_ankle_summary_pattern;
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
                    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_window_15min_correlation_0min_start.png'))

                    break;
                end
            end
        end
        window_index=window_index+1;    
    end
    
    %summary output for 15 minutes window starting at 0 minutes
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*15),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 15 minutes windows detected as correlated']))
  
    %15 minutes window 5 minutes start
    disp('15 minutes windowed correlation 5 minutes start')    

    window_length=36000;
    
    correlations=0;   
    random_correlations=[];
    
    window_index=1;  
    for window=12000:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
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

            %check for assumptions for correlation first
            if (~kstest((infant_torso_summary_pattern-mean(infant_torso_summary_pattern))/std(infant_torso_summary_pattern)) && ~kstest((infant_ankle_summary_pattern-mean(infant_ankle_summary_pattern))/std(infant_ankle_summary_pattern)) && ~vartest2(infant_torso_summary_pattern, infant_ankle_summary_pattern))

                %correlate
                [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);

                if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                    %display correlation, baseline param and random correlation
                    [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                    random_correlations=[random_correlations R];
                    disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))

                    infant_torso_summary(window:window_end)=infant_torso_summary(window:window_end)-infant_torso_summary_pattern;
                    infant_ankle_summary(window:window_end)=infant_ankle_summary(window:window_end)-infant_ankle_summary_pattern;
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
                    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_window_15min_correlation_5min_start.png'))

                    break;
                end
            end
        end
        window_index=window_index+1;    
    end
    
    %summary output for 15 minutes window starting at 5 minutes
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*15),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 15 minutes windows detected as correlated']))

    %15 minutes window 10 minutes start
    disp('15 minutes windowed correlation 10 minutes start')    

    window_length=36000;
    
    correlations=0;   
    random_correlations=[];
    
    window_index=1;  
    for window=24000:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
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

            %check for assumptions for correlation first
            if (~kstest((infant_torso_summary_pattern-mean(infant_torso_summary_pattern))/std(infant_torso_summary_pattern)) && ~kstest((infant_ankle_summary_pattern-mean(infant_ankle_summary_pattern))/std(infant_ankle_summary_pattern)) && ~vartest2(infant_torso_summary_pattern, infant_ankle_summary_pattern))

                %correlate
                [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);

                if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                    %display correlation, baseline param and random correlation
                    [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                    random_correlations=[random_correlations R];
                    disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))

                    infant_torso_summary(window:window_end)=infant_torso_summary(window:window_end)-infant_torso_summary_pattern;
                    infant_ankle_summary(window:window_end)=infant_ankle_summary(window:window_end)-infant_ankle_summary_pattern;
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
                    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_window_15min_correlation_10min_start.png'))

                    break;
                end
            end
        end
        window_index=window_index+1;    
    end
    
    %summary output for 15 minutes window starting at 10 minutes
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*15),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 15 minutes windows detected as correlated']))
    
    %set signal under examination as the final output of 15min correlation
    %infant_torso_summary=infant_torso_final_summary;
    %infant_ankle_summary=infant_ankle_final_summary;
    %-------------------------------------------------------------------------------------
    
    
    %go over several window lengths and several step starts to best extract hidden correlated
    %movements---------------------------------------------------------------------------
    
    %5 minutes window 0 minutes start
    disp('5 minutes windowed correlation 0 minutes start')
    
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

            %check for assumptions for correlation first
            if (~kstest((infant_torso_summary_pattern-mean(infant_torso_summary_pattern))/std(infant_torso_summary_pattern)) && ~kstest((infant_ankle_summary_pattern-mean(infant_ankle_summary_pattern))/std(infant_ankle_summary_pattern)) && ~vartest2(infant_torso_summary_pattern, infant_ankle_summary_pattern))

                %correlate
                [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);

                if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                    %display correlation, baseline param and random correlation
                    [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                    random_correlations=[random_correlations R];
                    disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))

                    infant_torso_summary_correction(window:window_end)=infant_torso_summary_pattern;
                    infant_ankle_summary_correction(window:window_end)=infant_ankle_summary_pattern;
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
                    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_window_5min_correlation_0min_start.png'))

                    break;
                end
            end
        end
        window_index=window_index+1;    
    end
    
    %summary output for 5 minutes window
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*5),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 5 minutes windows detected as correlated']))
    
    %5 minutes window 2.5 minutes start
    disp('5 minutes windowed correlation 2.5 minutes start')
    
    window_length=12000;
    
    correlations=0;   
    random_correlations=[];
    
    window_index=1;  
    for window=6000:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        %dont go too far and upset matlab
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        window_end_half=min([window+window_length/2-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        %check several pattern extraction weights(from tight-fit to loose) break as soon as there is at least 0.5 correlation
        weights=[3 5:5:200 225:25:500 550:50:1000 2000 3000 4000 5000];
        
        pattern_correlation=0;
        pattern_p=1;
            
        for weight=1:length(weights)
            
            %extract pattern
            infant_torso_summary_pattern=pattern_extraction(infant_torso_summary(window:window_end),weights(weight));
            infant_ankle_summary_pattern=pattern_extraction(infant_ankle_summary(window:window_end),weights(weight));

            %check for assumptions for correlation first
            if (~kstest((infant_torso_summary_pattern-mean(infant_torso_summary_pattern))/std(infant_torso_summary_pattern)) && ~kstest((infant_ankle_summary_pattern-mean(infant_ankle_summary_pattern))/std(infant_ankle_summary_pattern)) && ~vartest2(infant_torso_summary_pattern, infant_ankle_summary_pattern))

                %correlate
                [pattern_correlation, pattern_p]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern);

                if(abs(pattern_correlation)>=0.5 && pattern_p<0.05)
                    %display correlation, baseline param and random correlation
                    [R, P]=corr(infant_torso_summary_pattern,infant_ankle_summary_pattern(randperm(length(infant_ankle_summary_pattern))));
                    random_correlations=[random_correlations R];
                    disp(strcat([num2str(subj),'. subjects in the ',num2str(window_index),'. window with weight ',num2str(weights(weight)),' have correlation ',num2str(pattern_correlation),' with random correlation ',num2str(R)]))

                    %take maximum of both step windows
                    infant_torso_summary_correction(window:window_end_half)=max([infant_torso_summary_correction(window:window_end_half);infant_torso_summary_pattern(1:length(infant_torso_summary_correction(window:window_end_half)))]);
                    infant_ankle_summary_correction(window:window_end_half)=max([infant_ankle_summary_correction(window:window_end_half);infant_ankle_summary_pattern(1:length(infant_ankle_summary_correction(window:window_end_half)))]);
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
                    saveas(gcf,strcat('~/Desktop/CRC_project/pngs/correlation/normal/whittaker/',num2str(subj), '_subject_',num2str(window_index),'_window_5min_correlation_2_5_min_start.png'))

                    break;
                end
            end
        end
        window_index=window_index+1;    
    end
    
    %summary output for 5 minutes window
    disp(strcat([num2str(subj),'. subjects had all together ',num2str(correlations*5),' minutes of infant being moved by third person detected']))
    disp(strcat(['out of ',num2str(correlations),' correlated windows ',num2str(length(find(abs(random_correlations)>=0.5))),' had inner absolute random correlation bigger or equal to 0.5']))
    disp(strcat([num2str(round((correlations*100)/window_index,2)),'% of 5 minutes windows detected as correlated']))
    
    %set signal under examination as the final output of 15min correlation
    %infant_torso_summary=infant_torso_final_summary;
    %infant_ankle_summary=infant_ankle_final_summary;
    %------------------------------------------------------------------------------------------------------
 