function [] = GENEA_baseline(filename)
    GENEA_data=csvread(filename);
    
    %remove outliers
    x=hampel(GENEA_data(:,1),9);
    y=hampel(GENEA_data(:,2),9);
    z=hampel(GENEA_data(:,3),9);
    
    
    %extract broad baseline
    [~,x_b]=baseline_correction(x,1000000000, 0.5);
    [~,y_b]=baseline_correction(y,1000000000, 0.5);
    [~,z_b]=baseline_correction(z,1000000000, 0.5);
      
    [~,x_b_jump]= findpeaks(diff(x_b),'MINPEAKHEIGHT',0.0003);
    [~,y_b_jump]= findpeaks(diff(y_b),'MINPEAKHEIGHT',0.0003);
    [~,z_b_jump]= findpeaks(diff(z_b),'MINPEAKHEIGHT',0.0003);
    
    [~,x_b_drop]= findpeaks(-1*diff(x_b),'MINPEAKHEIGHT',0.0003);
    [~,y_b_drop]= findpeaks(-1*diff(y_b),'MINPEAKHEIGHT',0.0003);
    [~,z_b_drop]= findpeaks(-1*diff(z_b),'MINPEAKHEIGHT',0.0003);
    
    %check plots
    
    figure(1)%x
    plot(x)
    hold on
    scatter(x_b_jump,x(x_b_jump),'bs')
    hold on
    scatter(x_b_drop,x(x_b_drop),'bs')

    figure(2)%y
    plot(y)
    hold on
    scatter(y_b_jump,y(y_b_jump),'bs')
    hold on
    scatter(y_b_drop,y(y_b_drop),'bs')
    
    figure(3)%z
    plot(z)
    hold on
    scatter(z_b_jump,z(z_b_jump),'bs')
    hold on
    scatter(z_b_drop,z(z_b_drop),'bs')
        
    %smooth the corrected signal
    
    [x_cb,~]=baseline_correction(x,10000, 0.5);
    [y_cb,~]=baseline_correction(y,10000, 0.5);
    [z_cb,~]=baseline_correction(z,10000, 0.5);
    
    [~,x_b]=baseline_correction(x_cb,100, 0.5);
    [~,y_b]=baseline_correction(y_cb,100, 0.5);
    [~,z_b]=baseline_correction(z_cb,100, 0.5);
    
    figure(4)
    plot(x_b,'r')
    
    figure(5)
    plot(y_b,'r')
    
    figure(6)
    plot(z_b,'r')
    
    