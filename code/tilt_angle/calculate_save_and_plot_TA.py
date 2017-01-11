import sys
import pandas
import matplotlib.pyplot as ploty
#from scipy.signal import medfilt
#from scipy.signal import savgol_filter
import math

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
GENEA_csv=pandas.read_csv(sys.argv[1], low_memory=False, nrows=data_points)

x_axis=list(GENEA_csv[[0]].values.flatten())
y_axis=list(GENEA_csv[[1]].values.flatten())
z_axis=list(GENEA_csv[[2]].values.flatten())

#angle
angle=[math.atan2(float(z),math.sqrt(float(x)**2+float(y)**2)) for x,y,z in zip(x_axis, y_axis, z_axis)]

#save both to files
#csv_rows = ["pitch","roll"].extend(zip(pitch,roll))

df = pandas.DataFrame(angle)
print df.to_csv("angle.csv", index=False, header=True)

#plot

#plot entire signal
ploty.figure(10)
ploty.plot(range(0,len(x_axis)),x_axis,'b-')
ploty.show(block=False)
ploty.plot(range(0,len(angle)),angle,'r-')
ploty.draw()
ploty.show(block=False)

ploty.figure(20)
ploty.plot(range(0,len(y_axis)),y_axis,'b-')
ploty.show(block=False)
ploty.plot(range(0,len(angle)),angle,'r-')
ploty.draw()
ploty.show(block=False)

ploty.figure(30)
ploty.plot(range(0,len(z_axis)),z_axis,'b-')
ploty.show(block=False)
ploty.plot(range(0,len(angle)),angle,'r-')
ploty.draw()
ploty.show(block=False)

ploty.show(block=True)

