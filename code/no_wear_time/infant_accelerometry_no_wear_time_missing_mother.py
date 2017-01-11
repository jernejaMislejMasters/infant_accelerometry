import sys
import pandas
import numpy as np
from scipy.signal import medfilt
import matplotlib.pyplot as ploty
import matplotlib.lines as mlines
import datetime
from dateutil import parser

#read minutes for the window of no wear detection or set the default
if len(sys.argv)>1:
	no_wear_minutes=int(sys.argv[1])
else:
	no_wear_minutes=30

#read limit of std for no wear detection or set the default
if len(sys.argv)>2:
        no_wear_std=float(sys.argv[2])
else:
        no_wear_std=0.002

#read limit of span for no wear detection or set the default
if len(sys.argv)>3:
        no_wear_span=float(sys.argv[3])
else:
        no_wear_span=0.015

#read how much data to proccess
if len(sys.argv)>4:
        hours=int(sys.argv[4])
else:
        hours=48

#prepare window and how much data points to proccess according to hours
data_points=hours*60*60*40 # hours*minutes*seconds*samples per second #minimum 1h=144000 points
window_points=no_wear_minutes*60*40

for seq in range(29,31):
	infant_torso=pandas.read_csv(str(seq)+'_infant_torso_timed.csv', low_memory=False, header=None, nrows=data_points)
	infant_ankle=pandas.read_csv(str(seq)+'_infant_ankle_timed.csv', low_memory=False, header=None, nrows=data_points)

	x_axis_infant_torso_original=list(infant_torso[[1]].values.flatten())
	y_axis_infant_torso_original=list(infant_torso[[2]].values.flatten())
	z_axis_infant_torso_original=list(infant_torso[[3]].values.flatten())
	infant_torso_time=list(infant_torso[[0]].values.flatten())

	x_axis_infant_ankle_original=list(infant_ankle[[1]].values.flatten())
	y_axis_infant_ankle_original=list(infant_ankle[[2]].values.flatten())
	z_axis_infant_ankle_original=list(infant_ankle[[3]].values.flatten())
	infant_ankle_time=list(infant_ankle[[0]].values.flatten())
		

	x_axis_infant_torso=medfilt(x_axis_infant_torso_original,11)
	y_axis_infant_torso=medfilt(y_axis_infant_torso_original,11)
	z_axis_infant_torso=medfilt(z_axis_infant_torso_original,11)

	x_axis_infant_ankle=medfilt(x_axis_infant_ankle_original,11)
	y_axis_infant_ankle=medfilt(y_axis_infant_ankle_original,11)
	z_axis_infant_ankle=medfilt(z_axis_infant_ankle_original,11)


	#get the start time stamp and end time stamp
	start_timestamp=parser.parse(list(infant_torso[[0]].values.flatten())[0])
	end_timestamp_infant_torso=parser.parse(list(infant_torso[[0]].values.flatten())[len(x_axis_infant_torso_original)-1])
	end_timestamp_infant_ankle=parser.parse(list(infant_ankle[[0]].values.flatten())[len(x_axis_infant_ankle_original)-1])

	#prepare arrays of time-stamps for no-wear
	no_wear_timestamps_infant_torso=[[],[]]
	no_wear_timestamps_infant_ankle=[[],[]]

	#prepare arrays of no wear
	no_wear_infant_torso=[]
	no_wear_infant_ankle=[]

	#visualize
	fig, ((ax1, ax4), (ax2, ax5), (ax3, ax6)) = ploty.subplots( nrows=3, ncols=2, sharex='col', sharey='row', figsize=(50,25))
	ploty.ylabel('g')
	ploty.xlabel('samples')
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear infant ankle')
	yellow_mark = mlines.Line2D([], [], color='yellow', linewidth=1, linestyle='-', label='no wear infant torso')

	#infant torso
	ax1.set_title(str(seq)+' x axis infant torso')
	ax1.plot(range(0,len(x_axis_infant_torso)),x_axis_infant_torso,'b-')
	ax1.set_xticks(range(0,len(x_axis_infant_torso),288000))
	ax1.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	ax1.legend(handles=([red_mark, yellow_mark]))

	ax2.set_title(str(seq)+' y axis infant torso')
	ax2.plot(range(0,len(y_axis_infant_torso)),y_axis_infant_torso,'b-')
	ax2.set_xticks(range(0,len(y_axis_infant_torso),288000))
	ax2.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	ax2.legend(handles=([red_mark, yellow_mark]))

	ax3.set_title(str(seq)+' z axis infant torso')
	ax3.plot(range(0,len(z_axis_infant_torso)),z_axis_infant_torso,'b-')
	ax3.set_xticks(range(0,len(z_axis_infant_torso),288000))
	ax3.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	ax3.legend(handles=([red_mark, yellow_mark]))

	#infant ankle
	ax4.set_title(str(seq)+' x axis infant ankle')
	ax4.plot(range(0,len(x_axis_infant_ankle)),x_axis_infant_ankle,'b-')
	ax4.set_xticks(range(0,len(x_axis_infant_ankle),288000))
	ax4.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	ax4.legend(handles=([red_mark, yellow_mark]))

	ax5.set_title(str(seq)+' y axis infant ankle')
	ax5.plot(range(0,len(y_axis_infant_ankle)),y_axis_infant_ankle,'b-')
	ax5.set_xticks(range(0,len(y_axis_infant_ankle),288000))
	ax5.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	ax5.legend(handles=([red_mark, yellow_mark]))

	ax6.set_title(str(seq)+' z axis infant ankle')
	ax6.plot(range(0,len(z_axis_infant_ankle)),z_axis_infant_ankle,'b-')
	ax6.set_xticks(range(0,len(z_axis_infant_ankle),288000))
	ax6.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	ax6.legend(handles=([red_mark, yellow_mark]))
	
	#extract windowed statistics
	for window in range(0,max(len(x_axis_infant_torso), len(x_axis_infant_ankle)),window_points):

		#cumulative arrays
		cumulative_array_x_infant_torso=x_axis_infant_torso[window:window+window_points]
		cumulative_array_y_infant_torso=y_axis_infant_torso[window:window+window_points]
		cumulative_array_z_infant_torso=z_axis_infant_torso[window:window+window_points]


		if len(cumulative_array_x_infant_torso)>0:

			#avarages
			avg_x_infant_torso=sum(cumulative_array_x_infant_torso)/len(cumulative_array_x_infant_torso)
			avg_y_infant_torso=sum(cumulative_array_y_infant_torso)/len(cumulative_array_y_infant_torso)
			avg_z_infant_torso=sum(cumulative_array_z_infant_torso)/len(cumulative_array_z_infant_torso)

			#stds
			std_x_infant_torso=round((sum([(element-avg_x_infant_torso)**2 for element in cumulative_array_x_infant_torso])/len(cumulative_array_x_infant_torso))**(0.5),5)
			std_y_infant_torso=round((sum([(element-avg_y_infant_torso)**2 for element in cumulative_array_y_infant_torso])/len(cumulative_array_y_infant_torso))**(0.5),5)
			std_z_infant_torso=round((sum([(element-avg_z_infant_torso)**2 for element in cumulative_array_z_infant_torso])/len(cumulative_array_z_infant_torso))**(0.5),5)

			#spans

			span_x_infant_torso=abs(min(cumulative_array_x_infant_torso)-max(cumulative_array_x_infant_torso))
			span_y_infant_torso=abs(min(cumulative_array_y_infant_torso)-max(cumulative_array_y_infant_torso))
			span_z_infant_torso=abs(min(cumulative_array_z_infant_torso)-max(cumulative_array_z_infant_torso))

			#get a fitted line to estimate slop, no wear should have (close to) zero slope

			line_fit_x_infant_torso=np.polyfit(range(window,window+len(cumulative_array_x_infant_torso)), cumulative_array_x_infant_torso, 1)
			line_fit_y_infant_torso=np.polyfit(range(window,window+len(cumulative_array_y_infant_torso)), cumulative_array_y_infant_torso, 1)
			line_fit_z_infant_torso=np.polyfit(range(window,window+len(cumulative_array_z_infant_torso)), cumulative_array_z_infant_torso, 1)

			#check for conditions of wear time and save into arrays

			if (std_x_infant_torso<=no_wear_std and std_y_infant_torso<=no_wear_std and std_z_infant_torso<=no_wear_std) or (span_x_infant_torso<=no_wear_span and span_y_infant_torso<=no_wear_span and span_z_infant_torso<=no_wear_span):

				#add extra condition regarding baseline drift, in no-wear, there should be none, at least two of the axis need to have near to zero slope
				if ( abs(line_fit_x_infant_torso[0])<float('1e-07') and  abs(line_fit_y_infant_torso[0])<float('1e-07') and abs(line_fit_z_infant_torso[0])<float('1e-07')):
					no_wear_infant_torso.append(1)
				else:
					no_wear_infant_torso.append(0)
			else:
				no_wear_infant_torso.append(0)


	#go over the border blocks more thoroughly to get the best start and end of no wear block, check for in between blocks
	#wear indexes
	infant_torso_wear_indexes=[1]*len(x_axis_infant_torso)
	
	infant_ankle_wear_indexes=[1]*len(x_axis_infant_ankle)

	# infant torso
	for no_wear_index in range(0,len(no_wear_infant_torso)):
		#check for begin and end blocks
		if no_wear_index==0 and no_wear_infant_torso[no_wear_index]==1:
			#add start time-stamp to array
			no_wear_timestamps_infant_torso[0].append(start_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')[:-2])
		if no_wear_index==(len(no_wear_infant_torso)-1) and no_wear_infant_torso[no_wear_index]==1:
			#add end time-stamp to array
			no_wear_timestamps_infant_torso[1].append(end_timestamp_infant_torso.strftime('%Y-%m-%d %H:%M:%S.%f')[:-2])	
		if no_wear_index!=(len(no_wear_infant_torso)-1) and no_wear_infant_torso[no_wear_index]==0 and no_wear_infant_torso[max(0,no_wear_index-1)]==1 and no_wear_infant_torso[min(no_wear_index+1,len(no_wear_infant_torso)-1)]!=1 and no_wear_infant_torso[min(no_wear_index+2,len(no_wear_infant_torso)-1)]!=1: #end of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			window_end=min(no_wear_index*window_points+window_points,len(x_axis_infant_torso))
			for window in range(no_wear_index*window_points,no_wear_index*window_points+window_points,12000):
				cumulative_array_x=x_axis_infant_torso[window:window+12000]
				cumulative_array_y=y_axis_infant_torso[window:window+12000]
				cumulative_array_z=z_axis_infant_torso[window:window+12000]

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
					infant_torso_wear_indexes[window:window+12000]=[0]*len(infant_torso_wear_indexes[window:window+12000])

					infant_ankle_wear_indexes[window:window+12000]=[0]*len(infant_ankle_wear_indexes[window:window+12000])

					ax1.plot(range(window,window+len(x_axis_infant_torso[window:window+12000])),x_axis_infant_torso[window:window+12000],'y-')
					ax2.plot(range(window,window+len(y_axis_infant_torso[window:window+12000])),y_axis_infant_torso[window:window+12000],'y-')
					ax3.plot(range(window,window+len(z_axis_infant_torso[window:window+12000])),z_axis_infant_torso[window:window+12000],'y-')

					ax4.plot(range(window,window+len(x_axis_infant_ankle[window:window+12000])),x_axis_infant_ankle[window:window+12000],'y-')
					ax5.plot(range(window,window+len(y_axis_infant_ankle[window:window+12000])),y_axis_infant_ankle[window:window+12000],'y-')
					ax6.plot(range(window,window+len(z_axis_infant_ankle[window:window+12000])),z_axis_infant_ankle[window:window+12000],'y-')


				else:
					#add end time-stamp to array
					window_end=window
					break
			no_wear_timestamps_infant_torso[1].append((start_timestamp+datetime.timedelta(0,round(window_end/40))).strftime('%Y-%m-%d %H:%M:%S.%f')[:-2])
		
		elif no_wear_index!=0 and no_wear_infant_torso[no_wear_index]==0 and no_wear_infant_torso[min(no_wear_index+1,len(no_wear_infant_torso)-1)]==1 and no_wear_infant_torso[max(0,no_wear_index-1)]!=1 and no_wear_infant_torso[max(0,no_wear_index-2)]!=1:#beginning of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			begin_window=no_wear_index*window_points
			for window in range(no_wear_index*window_points+window_points,no_wear_index*window_points,-12000):#looking from the back
				cumulative_array_x=x_axis_infant_torso[window-12000:window]
				cumulative_array_y=y_axis_infant_torso[window-12000:window]
				cumulative_array_z=z_axis_infant_torso[window-12000:window]

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
					infant_torso_wear_indexes[window-12000:window]=[0]*len(infant_torso_wear_indexes[window-12000:window])

					infant_ankle_wear_indexes[window-12000:window]=[0]*len(infant_ankle_wear_indexes[window-12000:window])

					ax1.plot(range(window-len(x_axis_infant_torso[window-12000:window]),window),x_axis_infant_torso[window-12000:window],'y-')
					ax2.plot(range(window-len(y_axis_infant_torso[window-12000:window]),window),y_axis_infant_torso[window-12000:window],'y-')
					ax3.plot(range(window-len(z_axis_infant_torso[window-12000:window]),window),z_axis_infant_torso[window-12000:window],'y-')

					ax4.plot(range(window-len(x_axis_infant_ankle[window-12000:window]),window),x_axis_infant_ankle[window-12000:window],'y-')
					ax5.plot(range(window-len(y_axis_infant_ankle[window-12000:window]),window),y_axis_infant_ankle[window-12000:window],'y-')
					ax6.plot(range(window-len(z_axis_infant_ankle[window-12000:window]),window),z_axis_infant_ankle[window-12000:window],'y-')


				else:
					begin_window=window
					break
			no_wear_timestamps_infant_torso[0].append((start_timestamp+datetime.timedelta(0,round(begin_window/40))).strftime('%Y-%m-%d %H:%M:%S.%f')[:-2])

		elif no_wear_infant_torso[no_wear_index]==0 and ( ( (no_wear_infant_torso[min(no_wear_index+1,len(no_wear_infant_torso)-1)]==1 or no_wear_infant_torso[min(no_wear_index+2,len(no_wear_infant_torso)-1)]==1) and (no_wear_infant_torso[max(0,no_wear_index-1)]==1 or no_wear_infant_torso[max(0,no_wear_index-2)]==1) ) or ( (no_wear_infant_torso[1]==1 or no_wear_infant_torso[2]==1) and no_wear_index==0 ) or ( (no_wear_index==(len(no_wear_infant_torso)-1) or no_wear_index==(len(no_wear_infant_torso)-2)) and (no_wear_infant_torso[len(no_wear_infant_torso)-2]==1 or no_wear_infant_torso[len(no_wear_infant_torso)-3]==1) ) ): #up to three blocks of wear between two blocks of no-wear, are most probably no-wear, include beginning and end also

			#get the timestamp if end or begining
			if no_wear_index==0:
				no_wear_timestamps_infant_torso[0].append(start_timestamp.strftime('%Y-%m-%d %H:%M:%S.%f')[:-2])
			if no_wear_index==(len(no_wear_infant_torso)-1):
				no_wear_timestamps_infant_torso[1].append(end_timestamp_infant_torso.strftime('%Y-%m-%d %H:%M:%S.%f')[:-2])

			no_wear_infant_torso[no_wear_index]=1
			infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			
			infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			
			ax1.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax2.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax3.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')


			ax4.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax5.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax6.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')


		elif no_wear_infant_torso[no_wear_index]==1:
	
			infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			
			infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			ax1.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax2.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax3.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')


			ax4.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax5.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			ax6.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')


	#remove no wear from all

	#no wear torso
	x_axis_infant_torso_wear=list(np.array(x_axis_infant_torso)[np.array(infant_torso_wear_indexes)==1])
	y_axis_infant_torso_wear=list(np.array(y_axis_infant_torso)[np.array(infant_torso_wear_indexes)==1])
	z_axis_infant_torso_wear=list(np.array(z_axis_infant_torso)[np.array(infant_torso_wear_indexes)==1])
	infant_torso_time_wear=list(np.array(infant_torso_time)[np.array(infant_torso_wear_indexes)==1])

	x_axis_infant_ankle_wear=list(np.array(x_axis_infant_ankle)[np.array(infant_ankle_wear_indexes)==1])
	y_axis_infant_ankle_wear=list(np.array(y_axis_infant_ankle)[np.array(infant_ankle_wear_indexes)==1])
	z_axis_infant_ankle_wear=list(np.array(z_axis_infant_ankle)[np.array(infant_ankle_wear_indexes)==1])
	infant_ankle_time_wear=list(np.array(infant_ankle_time)[np.array(infant_ankle_wear_indexes)==1])
	
	#print procentage of removal
        len_infant_torso=float(len(x_axis_infant_torso))
        len_infant_torso_wear=float(len(x_axis_infant_torso_wear))
        len_infant_ankle=float(len(x_axis_infant_ankle))
        len_infant_ankle_wear=float(len(x_axis_infant_ankle_wear))

	print "subjects "+str(seq)
	print str(round(((len_infant_torso-len_infant_torso_wear)*100)/len_infant_torso,1))+"% of INFANT TORSO data points were removed as a consequence of either infant torso or ankle no wear time blocks"
	print str(round(((len_infant_ankle-len_infant_ankle_wear)*100)/len_infant_ankle,1))+"% of INFANT ANKLE data points were removed as a consequence of either infant torso or ankle no wear time blocks"

	print "number of no wear blocks in INFANT TORSO is "+str(len(no_wear_timestamps_infant_torso[0]))+"("+str(len(no_wear_timestamps_infant_torso[1]))+") at times:"
	print zip(*no_wear_timestamps_infant_torso)

	print "number of no wear blocks in INFANT ANKLE is "+str(len(no_wear_timestamps_infant_ankle[0]))+"("+str(len(no_wear_timestamps_infant_ankle[1]))+") at times:"	
	print zip(*no_wear_timestamps_infant_ankle)
	#create csv and save

	#infant torso
	csv_rows_infant_torso = zip(x_axis_infant_torso_wear,y_axis_infant_torso_wear,z_axis_infant_torso_wear)
	df_infant_torso = pandas.DataFrame(csv_rows_infant_torso)
	print df_infant_torso.to_csv(str(seq)+'_infant_torso_timed_wear.csv', index=False, header=False)
	df_infant_torso_time = pandas.DataFrame(infant_torso_time_wear)
	print df_infant_torso_time.to_csv(str(seq)+'_infant_torso_timed_wear_time.csv', index=False, header=False)

	#infant ankle
	csv_rows_infant_ankle = zip(x_axis_infant_ankle_wear,y_axis_infant_ankle_wear,z_axis_infant_ankle_wear)
	df_infant_ankle = pandas.DataFrame(csv_rows_infant_ankle)
	print df_infant_ankle.to_csv(str(seq)+'_infant_ankle_timed_wear.csv', index=False, header=False)	
	df_infant_ankle_time = pandas.DataFrame(infant_ankle_time_wear)
	print df_infant_ankle_time.to_csv(str(seq)+'_infant_ankle_timed_wear_time.csv', index=False, header=False)
	
	#infant torso no wear time stamps
	no_wear_timestamps_infant_torso[0].insert(0,"start")
	no_wear_timestamps_infant_torso[1].insert(0,"end")
	df_infant_torso_no_wear_timestamps = pandas.DataFrame(zip(*no_wear_timestamps_infant_torso))
	print df_infant_torso_no_wear_timestamps.to_csv(str(seq)+'_infant_torso_no_wear_timestamps.csv', index=False, header=False)

	#infant ankle no wear time stamps
	no_wear_timestamps_infant_ankle[0].insert(0,"start")
	no_wear_timestamps_infant_ankle[1].insert(0,"end")
	df_infant_ankle_no_wear_timestamps = pandas.DataFrame(zip(*no_wear_timestamps_infant_ankle))
	print df_infant_ankle_no_wear_timestamps.to_csv(str(seq)+'_infant_ankle_no_wear_timestamps.csv', index=False, header=False)

	#save plots to png
	fig.tight_layout()
	fig.savefig(str(seq)+'_no_wear_time_labeled.png')   # save the figure to file
	ploty.close(fig)
	
