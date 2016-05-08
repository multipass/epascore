library(shiny)
library(readr)

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


shinyUI(pageWithSidebar(
	headerPanel(
		"Fuel Economy Vehicules Dataset (EPA)"
	),
	sidebarPanel(
		h4("1. Data Exploration"),
		selectInput("facet_row", 
			label=h5("Grid (Row)"), 
			choices=c(None=".", names(df[sapply(df, is.factor)]))
		),
		selectInput("facet_col", 
			label=h5("Grid (Column)"), 
			choices=c(None=".", names(df[sapply(df, is.factor)]))
		),
		selectInput("datay", 
			label=h5("Measurement"), 
			choices=list("UCity","UHighway","co2TailpipeGpm")
		),
		selectInput("color", 
			label=h5("Color"), 
			choices=c("None", names(df[sapply(df, is.factor)]))
		),
		hr(),
		h4("2. EPA Score Prediction (Same Year)"),
		tags$p("Run a rpart (CART) classification algorithm from the caret package on the data from the selected year. The dataset will be divided into a training and a prediction subsets using the selected percentage of data to be used. A prediction tree will be built using the training data subset, and the resulting classification tree will be run on the prediction data subset. The prediction statistics and confusion matrix will be displayed in the main panel."),
		selectInput("yr1", 
			label=h5("Year"), 
			choices=levels(df$year)
		),
		sliderInput("pct",
			label=h5("Dataset % for model calibration"),
			min=10, 
			max=90, 
			value=60,
			step=5
		),
		actionButton("runSameYr", "Show Results"),	
		hr(),
		h4("3. EPA Score Prediction (Across Years)"),
		tags$p("Is the EPA score formula consistent over the year?. The idea is to calibrate a classification tree using the rpart (CART) algorithm from the caret package in R on a selected year, and apply it on another year. The prediction statistics and confusion matrix are displayed in the main panel."),
		selectInput("yr2_train", 
			label=h5("Year for model calibration"), 
			choices=levels(df$year) 
		),
		selectInput("yr2_test", 
			label=h5("Year for prediction application"), 
			choices=levels(df$year)
		),
		actionButton("runAllYr", "Show Results"),
		tags$p("Note: The prediction statistics are not very good across years, but a more thorough anaylsis is needed before drawing any conclusion on the consistancy of the EPA score over the years."),
		hr(),
		h4("Variables"),
		tags$div(
			tags$ul(
				tags$li("co2TailpipeGpm - tailpipe CO2 in grams/mile"),
				tags$li("cylinders - engine cylinders"),
				tags$li("displ - engine displacement in liters"),
				tags$li("drive - drive axle type"),
				tags$li("feScore - EPA Fuel economy score"),
				tags$li("fuelType - fuel type"),
				tags$li("make - manufacturer (division)"),
				tags$li("UCity - Unadjusted city MPG"),
				tags$li("UHighway - Unadjusted highway MPG"),
				tags$li("VClass - EPA vehicle size class"),
				tags$li("year - Model year"),
				tags$li("startStop - Vehicule has start/stop technology (Y/N)"),
				tags$li("lv4 - 4 door luggage volume (cubic feet)"),
				tags$li("pv4 - 4 door passenger volume (cubic feet)"),
				tags$li("am - Transmission (Automatic/Manual)")
			)
		),
		h4("References"),
		tags$div(
			tags$ul(
				tags$li(a(href="http://www.fueleconomy.gov/feg/ws/index.shtml","Fuel Economy EPA dataset")),
				tags$li(a(href="http://caret.r-forge.r-project.org/","Caret Package R")),
				tags$li(a(href="https://en.wikipedia.org/wiki/Decision_tree_learning","CART (Classification and Regression Tree)")),
				tags$li(a(href="https://www.coursera.org/learn/data-products/home/welcome", "Coursera Data Science (Product Development) Homepage"))			
				)
		)
	),
	mainPanel(
		h4("1. EPA Score Dataset Exploration"),
		plotOutput("explot"),
		hr(),
		h4("2. EPA Score Prediction (Within Year) Statistics"),
		verbatimTextOutput("cmatrix1"),
		hr(),
		h4("3. EPA Score Prediction (Across years) Statistics"),
		verbatimTextOutput("cmatrix2"),
		hr()
	)	
))