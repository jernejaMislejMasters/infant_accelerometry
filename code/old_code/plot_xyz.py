import sys
import pandas
import matplotlib.pyplot as ploty
from scipy.signal import medfilt
from scipy.signal import savgol_filter

#read how much data to proccess
if len(sys.argv)>2:
        hours=int(sys.argv[2])
else:
        hours=48

#read filter width
if len(sys.argv)>3:
        filter_width=int(sys.argv[3])
else:
        filter_width=9

#prepare window and how much data points to proccess according to hours
data_points=hours*60*60*40 # hours*minutes*seconds*samples per second #minimum 1h=144000 points

#load file and extract the axis
GENEA_csv=pandas.read_csv(sys.argv[1], low_memory=False, nrows=data_points+15)

x_axis=GENEA_csv['x'][15:data_points+15]
y_axis=GENEA_csv['y'][15:data_points+15]
z_axis=GENEA_csv['z'][15:data_points+15]

#plot

#plot entire signal
ploty.figure(1)
ploty.plot(range(0,data_points),x_axis,'b-')
ploty.show(block=False)

#plot filtered
filtered_x_axis=medfilt(x_axis,filter_width)
ploty.plot(range(0,len(filtered_x_axis)),filtered_x_axis,'y-')
ploty.draw()

#plot smoothed
smooth_x_axis=savgol_filter(x_axis, filter_width, 2)
ploty.plot(range(0,len(smooth_x_axis)),smooth_x_axis,'g-')
ploty.draw()

#plot smoothed filtered
smooth_filtered_x_axis=savgol_filter(filtered_x_axis, filter_width, 2)
ploty.plot(range(0,len(smooth_filtered_x_axis)),smooth_filtered_x_axis,'k-')
ploty.draw()

#plot entire signal
ploty.figure(2)
ploty.plot(range(0,data_points),y_axis,'b-')
ploty.show(block=False)

#plot filtered
filtered_y_axis=medfilt(y_axis,filter_width)
ploty.plot(range(0,len(filtered_y_axis)),filtered_y_axis,'y-')
ploty.draw()

#plot smoothed
smooth_y_axis=savgol_filter(y_axis, filter_width, 2)
ploty.plot(range(0,len(smooth_y_axis)),smooth_y_axis,'g-')
ploty.draw()

#plot smoothed filtered
smooth_filtered_y_axis=savgol_filter(filtered_y_axis, filter_width, 2)
ploty.plot(range(0,len(smooth_filtered_y_axis)),smooth_filtered_y_axis,'k-')
ploty.draw()

#plot entire signal
ploty.figure(3)
ploty.plot(range(0,data_points),z_axis,'b-')
ploty.show(block=False)

#plot filtered
filtered_z_axis=medfilt(z_axis,filter_width)
ploty.plot(range(0,len(filtered_z_axis)),filtered_z_axis,'y-')
ploty.draw()

#plot smoothed
smooth_z_axis=savgol_filter(z_axis, filter_width, 2)
ploty.plot(range(0,len(smooth_z_axis)),smooth_z_axis,'g-')
ploty.draw()

#plot smoothed filtered
smooth_filtered_z_axis=savgol_filter(filtered_z_axis, filter_width, 2)
ploty.plot(range(0,len(smooth_filtered_z_axis)),smooth_filtered_z_axis,'k-')
ploty.draw()

ploty.show(block=True)
