
OTHER


#Tests of normality
shapiro.test(data)

#plot the normality test, Make Q-Q plot
qqnorm(data)
qqline(data)

#read data
GUD34 <- read.csv("GUD34.csv", header = TRUE, sep = ";", row.names = NULL) 

rm(list=ls()) # remove everything in the workspace
rm(list=c('m', 'y')) #remove a list of things

#get and set workspace
setwd()
getwd()

save(x, y, file='OnlyXY.Rdata') #save stuff and load them
load('OnlyXY.Rdata')

set.seed(1234) #set a seed to the random generator

Score <- runif(8, 5, 20) # 8 random scores from a uniform distribution in the interval 5 to 20

Height <- rnorm(8, ifelse(Gender=='Male', 1.815, 1.668), 0.06)
# 8 random numbers from a normal distribution with
# mean for males of 1.815 and a mean for females  of 1.668 and a standard
# deviation of 0.06

rbinom(n, size, prob)#binomial distribution

binom <- rbinom(900, 1, 0.2) #vector of bdist
dim(binom) <- c(30, 30) #make it into a 30x30 matrix
binom <- as.data.frame(binom)
#Take mean and stdev for each column
mean.binom <- sapply(binom, mean, na.rm=TRUE) 
sd.binom <- sapply(binom, sd, na.rm=TRUE)
#Calculate SE
var.binom <- sapply(binom, var, na.rm=TRUE)
se.binom <- sqrt(var.binom/30)

str(var) #shows some info

head(dat)      # Shows the first 6 (default) cases in the dataframe, we can show
               # the first n rows of the dataframe by using
               # head(dataframename, n)...and we can see the last rows by using
               # tail(dataframename) in a similar manner

summary(var)  # the summary function on a list
class(obj)       # the class of an object tells functions how to treat the
            
mode(dat)  # what type, how it is stored

names(dat)    # gets the names
dim(dat)      # gets the dimensions of dat. The result is a vector with first
              # element is the number of rows and the second is the number
              # of columns and so on       
length(x) 

aveGUD <-aggregate(GUD36$gud, by=list(GUD36$pid), mean) #group the first data by the second data and calculate the third thing

colnames(av.succ) <- c("year", "succ") #rename columns
----------------------------------

VECTORS

# c() means combine
x <- c(2, 1, 7, 4, 34) 
x <- c(1:5, x, 56)

(y <- 1:100) #assign a list to y and print it

l <- x > 4   # a vector of logicals

# If the elements you try to put in a vetcor is not of the same type, everything
# will be "forced" to be of the "lowest" type
z <- c(1:5, TRUE, 'atextstring')   # lowest type here is character so everything
                                   # is forced into that
u <- c(1:5, TRUE)                  # here numeric is the lowest type

n <- c(a=1, b=4, c=56)             # named elements

x<-seq(from=1, to=10, by=0.1)   # If we want shorter steps
x<-seq(from=1, to=10, length.out=9) #If we want a specific length of the result, chop the interval into 9 peaces 1.000  2.125  3.250  4.375  5.500  6.625  7.750  8.875 10.000

x<-seq(along=x)	       #like 1:length(x))

#some repetitions
rep(1:10, times=2)
rep(1:10, times=10:1)
rep(1:4, each=3)
rep(1:4, each = 2, length.out = 10) 	# 8 integers plus two recycled 1's.
rep(1:4, each = 2, times = 3) 	     # length 24, 3 complete replications


----------------------------------

MATRICES

X <- matrix(c(4, 7, 3, 8, 9, 2), nrow = 3)      # data entered column-wise
Y <- matrix(c(4, 7, 3, 8, 9, 2), nrow = 3, byrow = TRUE) # data entered row-wise
Z <- matrix(c(4, 7, 3, 8, 9, 2), ncol = 3)
TY <- t(Y) #transpose
t(Z) == Y               #logical matrix

# matrix with dimnames
Z2 <- matrix(c(4, 7, 3, 8, 9, 2), ncol = 3,
      dimnames=list(c('row1', 'row2'), c('col1', 'col2', 'col3')))

----------------------------------

ARRAYS

A <- array(1:60, dim = c(3, 5, 4))    # gives a 3-dimensional array with 3 rows,
                                      # 5 columns and 4 "sheets"
A2 <- array(1:60, dim = c(3, 5, 2, 2)) # gives a 4-dimensional array

----------------------------------

INDEXING

x[3]    # gets the 3rd element of vector x
x[c(1, 5, 6)] # indexing by a vector, gets element number 1 5 and 6 in vector x
x[x > 3]  x[x==1]     # indexing by a logical vector
x[-3]   # gets everything in x BUT the third element
X[2, 1] # gets the element in row 2 column 1 of matrix X
X[, 2]  # gets all elements in column 2 of matrix X
X[2, ]  # gets all elements of row 2 of matrix X
X[5]    # indexing MULTI-DIMENSIONAL structures with a SINGLE index, X[i] or
        # A[i] will return the ith sequential element (counted column-wise)
        # of matrix X  or A respectively
n['b']  # indexing by name, gets the element named 'b' in vector n


L$a     # gets element a in the list L
L['a']  # gets element a AS A LIST object
L[1]    # does the same since a is the first element in the list L
L[['a']] #(or L[[1]]); does the same as L$a
L['c']        # extracts c as a list element
L[['c']] # ...class(L[['c']]); L[['c']] extracts c as it is (i.e. as a matrix in
         # this case) and, again, L$c does the same
         
L[['c']][1, 2] # gets the element of row 1, column 2 in the matrix c
               # which is in list L!!!

# Similar things work for dataframes
dat$Score
dat['Score']
dat[['Score']]
dat[,'Score'] # This may seem wierd but this is how indexing on dataframes work
              # apparently and make indexing of a dataframe similar to indexing
              # of a matrix
dat[3, 4]     # Indexing as in a matrix, gets 3rd case of 4th variable
dat[3, 'Score']
dat[dat$Sex=='Female', ]  # Logical indexing based on the values of one of the
                          # variables in a dataframe is often very useful

----------------------------------

LISTS

L <- list(a=1, b=1:3, c=matrix(1:4, 2), d=x > 4, e=y)  # various types in the same list


----------------------------------

DATAFRAMES

#make dataframe
dat <- data.frame(name=value, name=value,...) 

#convert a list to dataframe
dat.list <- as.data.frame(d.list)

dat <- cbind(dat, Food) #combine column wise
dat <- rbind(dat, newcase) #combine row wise

#sort increasing and decreasing
sort(dat$Score)                   
sort(dat$Score, decreasing=TRUE)

rev(dat$Score)#reverses vector

order(dat$Score) #indexes of ordered vector

dat[order(dat$Sex, dat$Height),] #order by several variables, - for decreased order

rank(vector)#place

## Subsetting
# Subsetting via indexing
dat.Females <- dat[dat$Sex=='Female',]
# Subsetting via subset()
dat.Males <- subset(dat, Sex=='Male') 

# We can choose not to include all variables
dat.Males.red <- subset(dat, Sex=='Male', select=c(Firstname, Score, Height))
# We only want the variables Firstname, Score and Height

# With indexing this would be...
dat[dat$Sex=='Male', c('Firstname', 'Score', 'Height')]

# To remove unused levels we can use droplevels
dat.Females <- droplevels(dat.Females)

match(vector,vector/dataset)
merge(dataset,dataset)
merge(ftimes, lforms, all=T)        # merge and keep all
#keep only first
merge(ftimes, lforms, all.x=T)
# And vice versa
merge(ftimes, lforms, all.y=T)
#merge by name
merge(all.flowers, seeds, by.x=c('Genus', 'species'), by.y=c('name1', 'name2'))

colMeans() #colum means
colSums()  # colum sums
rowMeans()  #row means

table(dat$Sex, dat$Group) # see how many observations

#Make subsets of the data
TX <- subset(tits, tits$spe == "TX")


-------------------------------------------------

PLOTS


#scatterplot matrix one way

pairs(~var1+var2+var3+var4,data=dataframeName,main="Name")


hist(succ$succ) 

abline(reg.all, col = "red") #line

plot(trees$Girth, trees$Volume)   # A graphics window appears with a scatterplot
                                  # with Girth on the x-axis and Volume on
                                  # the y-axis
plot(trees)                   # the plot-function applied to a data.frame
                              # object invokes the plot.data.frame() function
                              # that produces pairwise scatterplots
                              # of all variables in the dataframe
                              # (see ?plot.data.frame)
                              
tree.lm <- lm(trees$Volume ~ trees$Girth) # This is a statistical model
                                          # i.e. we are doing a linear
                                          # regression of Volume on Girth.
                                          # Don't bother to much about it now,
                                          # this is just to illustrate how plot
                                          # works on a model object
                                          
plot(tree.lm)                             # Now, we can see that the plot-
                                          # function applied on a model object
                                          # of class 'lm' yields a number
                                          # of diagnostic plots of the model.
                                          # Press ENTER or click on the graph
                                          # to get the next figure
                                          
plot(Volume ~ Girth, data=trees)        # We can use the formula representation
                                        # (as in the linear model) to specify x
                                        # and y values (note the reversed order)
                                        # Here plot.formula() is invoked as the
                                        # plotting function

plot(dat$Sex, dat$Height)    # Here we see what happens if we plot with a factor
                             # (plot.factor() is invoked which in turn invoke
                             # the boxplot() function)

#boxplots
                                        
boxplot(trees)    
                      
boxplot(dat[, -7]) 

barplot(m.fruit, ylim=c(0, 100))    # we can specify limits

op <- par(mfrow=c(2, 1))    # we want two figures in the same window organised
                            # in two rows (and one column)
                            # We assign par() to an object. By doing so the
                            # "old" setting is saved as object op and thereby we
                            # can restore the plotting frame to normal
                            # afterwards
plot(Fruit~Root, data=comp.dat,
      xlab=list('Root biomass', cex=1.5),
      ylab=list('Fruit production', cex=1.5),
      cex=2, pch=21, bg='grey')

text(b.pl, 3, paste('n = ', n.fruit))

plot(Fruit~Root, data=comp.dat,
      xlab=list('Root biomass', cex=1.5),      # the call to xlab is a list with
                                               # the text and then a
                                               # specification of cex (character
                                               # expansion) saying that the
                                               # labels should be written 1.5
                                               # times larger than the default
      ylab=list('Fruit production', cex=1.5),
      cex=2, pch=21, bg=bg.col[Grazing])       # I decided to use the cool way!
                                               # We only need to specify Grazing
                                               # (instead of comp.dat$Grazing)
                                               # since we have specified the
                                               # data set already in the plot
                                               # function

legend('topleft', legend=c('Grazed', 'Ungrazed'),
       pch=21, pt.bg=c('green', 'red'), pt.cex=2)

# Let's send this beatiful figure to a pdf-file
pdf('Beautiful_figure.pdf', paper='a4') # We start the device (i.e. a pdf-file)
plot(Fruit~Root, data=comp.dat,              # We plot the figure
      xlab=list('Root biomass', cex=1.5),
      ylab=list('Fruit production', cex=1.5),
      cex=2, pch=21, bg=bg.col[Grazing])
legend('topleft', legend=c('Grazed', 'Ungrazed'),
       pch=21, pt.bg=c('green', 'red'), pt.cex=2) # and add a legend
dev.off() 

#Calculate regression line for full dataset and add to plot
reg.all <- lm(tits$egg~tits$wei)
plot(tits$wei, tits$egg)
abline(reg.all)
