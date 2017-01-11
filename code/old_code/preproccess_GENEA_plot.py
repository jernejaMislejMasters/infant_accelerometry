import sys
import pandas
import numpy as np
import matplotlib.pyplot as ploty
from scipy.signal import medfilt
import matplotlib.lines as mlines
import matplotlib.patches as mpatches
from scipy.signal import savgol_filter

#read minutes for the window of no wear detection or set the default
if len(sys.argv)>2:
	no_wear_minutes=int(sys.argv[2])
else:
	no_wear_minutes=10

#read limit of std for no wear detection or set the default
if len(sys.argv)>3:
        no_wear_std=float(sys.argv[3])
else:
        no_wear_std=0.0026

#read limit of span for no wear detection or set the default
if len(sys.argv)>4:
        no_wear_span=float(sys.argv[4])
else:
        no_wear_span=0.05

#read how much data to proccess
if len(sys.argv)>5:
        hours=int(sys.argv[5])
else:
        hours=48

#plot filename
if len(sys.argv)>6:
        plot_filename=sys.argv[6]
else:
        plot_filename="plot"


#prepare window and how much data points to proccess according to hours
data_points=hours*60*60*40 # hours*minutes*seconds*samples per second #minimum 1h=144000 points
window_points=no_wear_minutes*60*40
#stats_nr=data_points/window_points

#load file, extract the axis and remove spikes with a median filter of width 5
GENEA_csv=pandas.read_csv(sys.argv[1], low_memory=False, nrows=data_points+15)
x_axis=medfilt(GENEA_csv['x'],5)
y_axis=medfilt(GENEA_csv['y'],5)
z_axis=medfilt(GENEA_csv['z'],5)
#estimate night between 21.00 and 7.00
first_timestamp=GENEA_csv['t'][0]
first_night_begin_index=40*(60-int(first_timestamp[17:19])+60*(60-int(first_timestamp[14:16]))+60*60*(20-int(first_timestamp[11:13])))#time from first time stamp to 21.00
first_night_end_index=first_night_begin_index+10*60*60*40 #10h of night
second_night_begin_index=first_night_begin_index+24*60*60*40
second_night_end_index=second_night_begin_index+10*60*60*40

#prepare array of no wear indexes
no_wear=[]

#plot entire signal x and night time
ploty.figure(num=1, figsize=(20,20))
ploty.plot(range(0,len(x_axis)),x_axis,'b-')
ploty.ylabel('g')
ploty.xlabel('samples')
#ploty.axis([0,len(x_axis),-6,6])
ploty.title(plot_filename+' x axis')
ploty.xticks(range(0,len(x_axis),144000),[str(x)+" h" for x in range(0,48)])
ploty.axvspan(first_night_begin_index, first_night_end_index, facecolor='b', alpha=0.5)
ploty.axvspan(second_night_begin_index, second_night_end_index, facecolor='b', alpha=0.5)
blue_shade = mpatches.Patch(color='blue', alpha=0.5, label='night (21.00:7.00)')
red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
ploty.legend(handles=([red_mark,blue_shade]))
ploty.show(block=False)

#plot entire signal y and night time
ploty.figure(num=2, figsize=(20,20))
ploty.plot(range(0,len(y_axis)),y_axis,'b-')
ploty.ylabel('g')
ploty.xlabel('samples')
#ploty.axis([0,len(y_axis),-6,6])
ploty.title(plot_filename+' y axis')
ploty.xticks(range(0,len(y_axis),144000),[str(x)+" h" for x in range(0,48)])
ploty.axvspan(first_night_begin_index, first_night_end_index, facecolor='b', alpha=0.5)
ploty.axvspan(second_night_begin_index, second_night_end_index, facecolor='b', alpha=0.5)
blue_shade = mlines.Line2D([], [], color='blue', alpha=0.5, linewidth=4, linestyle='-', label='night (21.00:7.00)')
red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
ploty.legend(handles=([red_mark,blue_shade]))
ploty.show(block=False)

#plot entire signal z and night time
ploty.figure(num=3, figsize=(20,20))
ploty.plot(range(0,len(z_axis)),z_axis,'b-')
ploty.ylabel('g')
ploty.xlabel('samples')
#ploty.axis([0,len(z_axis),-6,6])
ploty.title(plot_filename+' z axis')
ploty.xticks(range(0,len(z_axis),144000),[str(x)+" h" for x in range(0,48)])
ploty.axvspan(first_night_begin_index, first_night_end_index, facecolor='b', alpha=0.5)
ploty.axvspan(second_night_begin_index, second_night_end_index, facecolor='b', alpha=0.5)
blue_shade = mlines.Line2D([], [], color='blue', alpha=0.5, linewidth=4, linestyle='-', label='night (21.00:7.00)')
red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
ploty.legend(handles=([red_mark,blue_shade]))
ploty.show(block=False)

#extract windowed statistics
for window in range(0,len(x_axis),window_points):
	cumulative_array_x=x_axis[window:window+window_points]
	cumulative_array_y=y_axis[window:window+window_points]
	cumulative_array_z=z_axis[window:window+window_points]

        avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
        avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
        avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

        std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
        std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
        std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

        span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
        span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
        span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))

	#get a fitted line to estimate slop, no wear should have (close to) zero slope
	line_fit_x=np.polyfit(range(window,window+len(cumulative_array_x)), cumulative_array_x, 1)
	line_fit_y=np.polyfit(range(window,window+len(cumulative_array_y)), cumulative_array_y, 1)
	line_fit_z=np.polyfit(range(window,window+len(cumulative_array_z)), cumulative_array_z, 1)

	#check for conditions of wear time
	if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):

		print "std: ",std_x,std_y,std_z
		print "span: ",span_x,span_y,span_z
		print "slope: ",line_fit_x[0],line_fit_y[0],line_fit_z[0]

		#add extra condition regarding baseline drift, in no-wear, there should be none, at least two of the axis need to have near to zero slope
		if ( abs(line_fit_x[0])<float('1e-07') and  abs(line_fit_y[0])<float('1e-07') and abs(line_fit_z[0])<float('1e-07')):
			no_wear.append(1)
			ploty.figure(1)
			ploty.plot(range(window,window+len(cumulative_array_x)),cumulative_array_x,'r-')
			ploty.draw()
			ploty.figure(2)
			ploty.plot(range(window,window+len(cumulative_array_y)),cumulative_array_y,'r-')
			ploty.draw()
			ploty.figure(3)
			ploty.plot(range(window,window+len(cumulative_array_z)),cumulative_array_z,'r-')
			ploty.draw()
		else:
			no_wear.append(0)		
	else:
		no_wear.append(0)

#go over the border blocks more thoroughly to get the best start and end of no wear block
x_axis_wear=[]
y_axis_wear=[]
z_axis_wear=[]
for no_wear_index in range(0,len(no_wear)):
	if no_wear_index!=(len(no_wear)-1) and no_wear[no_wear_index]==0 and no_wear[max(0,no_wear_index-1)]==1 and no_wear[min(no_wear_index+1,len(no_wear)-1)]!=1 and no_wear[min(no_wear_index+2,len(no_wear)-1)]!=1: #end of no-wear block
		#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
		beginning_window=no_wear_index*window_points+window_points
		for window in range(no_wear_index*window_points,no_wear_index*window_points+window_points,12000):
			cumulative_array_x=x_axis[window:window+12000]
			cumulative_array_y=y_axis[window:window+12000]
			cumulative_array_z=z_axis[window:window+12000]

	        	avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
			avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
			avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

			std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
			std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
			std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

			span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
			span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
			span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
			
			#check for conditions of wear time
			if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):
				#plot red
				ploty.figure(1)
				ploty.plot(range(window,window+len(cumulative_array_x)),cumulative_array_x,'r-')
				ploty.draw()
				ploty.figure(2)
				ploty.plot(range(window,window+len(cumulative_array_y)),cumulative_array_y,'r-')
				ploty.draw()
				ploty.figure(3)
				ploty.plot(range(window,window+len(cumulative_array_z)),cumulative_array_z,'r-')
				ploty.draw()
				#print "extra chunk removed"
			else:
				#reached end, save block index and break
				beginning_window=window
				break
		
		#append the rest if any
		if len(x_axis[beginning_window:no_wear_index*window_points+window_points])>0:
			x_axis_wear.extend(x_axis[beginning_window:no_wear_index*window_points+window_points])
		if len(y_axis[beginning_window:no_wear_index*window_points+window_points])>0:
			y_axis_wear.extend(y_axis[beginning_window:no_wear_index*window_points+window_points]) 
		if len(z_axis[beginning_window:no_wear_index*window_points+window_points])>0:
			z_axis_wear.extend(z_axis[beginning_window:no_wear_index*window_points+window_points]) 
			
	elif no_wear_index!=0 and no_wear[no_wear_index]==0 and no_wear[min(no_wear_index+1,len(no_wear)-1)]==1 and no_wear[max(0,no_wear_index-1)]!=1 and no_wear[max(0,no_wear_index-2)]!=1:#beginning of no-wear block
		#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
		end_window=no_wear_index*window_points
		for window in range(no_wear_index*window_points+window_points,no_wear_index*window_points,-12000):#looking from the back
			cumulative_array_x=x_axis[window-12000:window]
			cumulative_array_y=y_axis[window-12000:window]
			cumulative_array_z=z_axis[window-12000:window]

	        	avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
			avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
			avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

			std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
			std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
			std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

			span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
			span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
			span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
			
			#check for conditions of wear time
			if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):
				#plot red
				ploty.figure(1)
				ploty.plot(range(window-len(cumulative_array_x),window),cumulative_array_x,'r-')
				ploty.draw()
				ploty.figure(2)
				ploty.plot(range(window-len(cumulative_array_y),window),cumulative_array_y,'r-')
				ploty.draw()
				ploty.figure(3)
				ploty.plot(range(window-len(cumulative_array_z),window),cumulative_array_z,'r-')
				ploty.draw()
				#print "extra chunk removed"
			else:
				#reached end, save block index and break
				end_window=window
				break
		
		#append the rest if any
		if len(x_axis[no_wear_index*window_points:end_window])>0:
			x_axis_wear.extend(x_axis[no_wear_index*window_points:end_window]) 
		if len(y_axis[no_wear_index*window_points:end_window])>0:
			y_axis_wear.extend(y_axis[no_wear_index*window_points:end_window]) 
		if len(z_axis[no_wear_index*window_points:end_window])>0:
			z_axis_wear.extend(z_axis[no_wear_index*window_points:end_window]) 
	elif no_wear[no_wear_index]==0 and no_wear[min(no_wear_index+1,len(no_wear)-1)]!=1 and no_wear[max(0,no_wear_index-1)]!=1:
		x_axis_wear.extend(x_axis[no_wear_index*window_points:no_wear_index*window_points+window_points])
		y_axis_wear.extend(y_axis[no_wear_index*window_points:no_wear_index*window_points+window_points])
		z_axis_wear.extend(z_axis[no_wear_index*window_points:no_wear_index*window_points+window_points])
	elif no_wear[no_wear_index]==0 and ( ( (no_wear[min(no_wear_index+1,len(no_wear)-1)]==1 or no_wear[min(no_wear_index+2,len(no_wear)-1)]==1) and (no_wear[max(0,no_wear_index-1)]==1 or no_wear[max(0,no_wear_index-2)]==1) ) or ( (no_wear[1]==1 or no_wear[2]==1) and no_wear_index==0 ) or ( (no_wear_index==(len(no_wear)-1) or no_wear_index==(len(no_wear)-2)) and (no_wear[len(no_wear)-2]==1 or no_wear[len(no_wear)-3]==1) ) ): #up to three blocks of wear between two blocks of no-wear, are most probably no-wear, include beginning and end also
		no_wear[no_wear_index]=1		
		#plot red
		ploty.figure(1)
		ploty.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
		ploty.draw()
		ploty.figure(2)
		ploty.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
		ploty.draw()
		ploty.figure(3)
		ploty.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
		ploty.draw()
		#print "in between block removed"
		
print no_wear
print "DONE"

ploty.figure(1)
ploty.savefig(plot_filename+"_x.png")
ploty.figure(2)
ploty.savefig(plot_filename+"_y.png")
ploty.figure(3)
ploty.savefig(plot_filename+"_z.png")

#apply Savitzky-Golay smoothing
x_axis_wear=savgol_filter(x_axis_wear, 5, 2)
y_axis_wear=savgol_filter(y_axis_wear, 5, 2)
z_axis_wear=savgol_filter(z_axis_wear, 5, 2)

ploty.figure(4)
ploty.plot(range(0,len(x_axis_wear)),x_axis_wear,'g-')
ploty.figure(5)
ploty.plot(range(0,len(y_axis_wear)),y_axis_wear,'g-')
ploty.figure(6)
ploty.plot(range(0,len(z_axis_wear)),z_axis_wear,'g-')
