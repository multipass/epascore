library(readr)
library(shiny)
library(caret)
library(randomForest)
library(e1071)
library(pROC)

#Reproductible results
set.seed(99)
#Local copy of vehicules data
#Source http://www.fueleconomy.gov/feg/download.shtml 
archive.loc	<-"feg_vehicules.csv"
df			<-read_csv(archive.loc)
df$cylinders<-as.factor(df$cylinders)
df$drive	<-as.factor(df$drive)
df$feScore	<-as.factor(df$feScore)
df$fuelType	<-as.factor(df$fuelType)
df$make		<-as.factor(df$make)
df$VClass	<-as.factor(df$VClass)
df$year		<-as.factor(df$year)
df$startStop<-as.factor(df$startStop)

#Run a CART classification algorithm on the vehicules dataset
#Arguments
#year: Selected year to run the classification
#percent: Percentage of the dataset to use to calibrate the algorithm
#Output
#Confusion matrix and statistics
runClassification1 <- function(year, percent){
	dfw 		<- df[df$year==year,]
	iTrain 		<- createDataPartition(y=dfw$feScore, p=percent, list=FALSE)
	training 	<- dfw[iTrain, ]
	testing 	<- dfw[-iTrain, ]
	mf 			<- train(feScore~., data=training, model= "rpart")
	pred 		<- predict(mf, newdata=testing)
	confusionMatrix(pred, testing$feScore)
}

#Run a CART classification algorithm on the vehicules dataset
#Arguments
#yearCalib: Selected year to run the classification
#yearTest: Selected year to apply the classification
#Output
#Confusion matrix and statistics
runClassification2 <- function(yearCalib, yearTest){
	dfw 	<- df[df$year==yearCalib,]
	dft 	<- df[df$year==yearTest,]
	mf 		<- suppressWarnings(train(feScore~., data=dfw, model= "rpart"))
	pred 	<- predict(mf, newdata=dft)
	confusionMatrix(pred, dft$feScore)
}


#Build a scatterplot from the vehicules dataset
#Arguments
#ydata: y axis data to be shown
#fac_row: factor to be used as the grid facet row
#fac_col: factor to be used as the grid facet column
#col: factor to be used as color 
#Output
#Scatterplot
buildExploratory <- function(ydata, fac_row, fac_col, col){
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


shinyServer(
function(input, output){

	c1 <- eventReactive(input$runSameYr, {
		runClassification1(input$yr1, input$pct/100)
	})
	c2 <- eventReactive(input$runAllYr, {
		runClassification2(input$yr2_train, input$yr2_test)
	})
	
	
	output$cmatrix1 <- renderPrint({
		c1()
	})
	output$cmatrix2 <- renderPrint({
		c2()
	})
	
	output$explot <-renderPlot({
		buildExploratory(input$datay, input$facet_row, input$facet_col, input$color)
	})
})