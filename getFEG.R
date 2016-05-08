csvtodf<-function(){
	library(readr)
	myf <- "feg_vehicules.csv"
	df <- read_csv(myf)
	df$cylinders<-as.factor(df$cylinders)
	df$drive<-as.factor(df$drive)
	df$feScore<-as.factor(df$feScore)
	df$fuelType<-as.factor(df$fuelType)
	df$make<-as.factor(df$make)
	df$VClass<-as.factor(df$VClass)
	df$year<-as.factor(df$year)
	df$startStop<-as.factor(df$startStop)
	df
}

buildExploratory <- function(ydata, fac_row, fac_col, col){
	library(ggplot2)
	g <- ggplot(df, aes_string(x="feScore", y=ydata))
	g <- g + geom_point()
	g <- g + xlab("EPA Score[1~10]")
	g <- g + ggtitle(paste("Scatterplot of", ydata, "against EPA score" ))
	ylabel <- switch(ydata, 
		"UCity"				= "Unadjusted City Consumption Miles/Gallon",
		"UHighway" 			= "Unadjusted Highway Consumption Miles/Gallon",
		"co2TailpipeGpm"	= "Tailpipe CO2 emission Grams/Mile" 
	)
	g <- g + ylab(ylabel)
		
	if (col != "None") 
		g <- g + aes_string(color=col)
			
	fac <- paste(fac_row, "~", fac_col)	
	if (fac != ". ~ .")	
		g <- g + facet_grid(fac)
		
	print(g)
}



getFromFEG<-function(){
	library(readr)
	
	#variables
	archive.rem<-"http://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip"
	archive.loc<-"veh.csv.zip"
	myf <- "feg_vehicules.csv"
	#download.file(archive.rem, archive.loc)
	#myf<-unzip(archive.loc)
	df1<-read_csv(myf, na=c("", "NA","-1",-1))
	#colnames(df)<-make.names(colnames(df), unique=T)
	df1<-df1[,c("co2TailpipeGpm", "cylinders", "displ", "drive", "feScore", "fuelType", "make", "trany", "UCity", "UHighway", "VClass", "year", "startStop", "lv4", "pv4")]
	#df1[df1==-1]<-NA
	#df1[df1==""]<-NA
	df1<-na.omit(df1)
	#df1<-df1[df1$feScore>2,]
	#df1<-df1[df1$year<2017,]
	df1$am<-as.factor(substr(df1$trany, 1,1))
	df1<-df1[,-which(names(df1)=="trany")]
	df1<-df1[grep("Cars", df1$VClass),]
	df1[df1$drive=="4-Wheel Drive",]$drive <- "All-Wheel Drive"
	df1[df1$drive=="Part-time 4-Wheel Drive",]$drive <- "All-Wheel Drive"
	df1$cylinders<-as.factor(df1$cylinders)
	df1$drive<-as.factor(df1$drive)
	df1$feScore<-as.factor(df1$feScore)
	df1$fuelType<-as.factor(df1$fuelType)
	df1$make<-as.factor(df1$make)
	df1$VClass<-as.factor(df1$VClass)
	df1$year<-as.factor(df1$year)
	df1$startStop<-as.factor(df1$startStop)
	df1<-df1[df1$lv4!=0 & df1$pv4!=0,]
	df1
}