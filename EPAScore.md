---
title: "EPA Fuel Economy Score Exploration"
output: pdf_document
---
##Coursera Developing Data Product/ Assignment Project 
###Yann Kayode, May 2016

##Background
The US Environmental Protection Agency(EPA) publishes regularly fuel economy data on all the vehicules authorised in the US. The agency inroduced a change in the way they generate the EPA score in order to take into account various addtitional [factors](http://www.fueleconomy.gov/feg/ratings2008.shtml). The goal of this project is:

 - Explore the fuel economy data for the cars that can be used by the general public
 - Run a machine learning prediction algorithm to predict the EPA score of vehicles for a given year. The dataset of the given year will be divided into a training dataset and a validation dataset for this purpose
 - Run a machine learning prediction algorithm to predict the EPA score of vehicules for a given year using the EPA scores from another year

##Data Quick Exploration
Quick scatterplot to show the CO2 emissions from variable `co2TailpipeGpm` for different vehicules classes `VClass`, year `year`, and fuel type `fuelType` 

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)


##EPA Score predictions

###Same Year Prediction
Run a rpart (CART) classification algorithm from the caret package on the data from the selected year. The dataset will be divided into a training and a prediction subsets using the selected percentage of data to be used. A prediction tree will be built using the training data subset, and the resulting classification tree will be run on the prediction data subset. The prediction statistics and confusion matrix are displayed in the main panel.

###Across Year Prediction
Is the EPA score formula consistent over the year?. The idea is to calibrate a classification tree using the rpart (CART) algorithm from the caret package in R on a selected year, and apply it on another year. The prediction statistics and confusion matrix are displayed in the main panel.



##References
 - [US Environmental Protection Agency](https://www.epa.gov/aboutepa) 
 - [EPA Score Shiny Application](https://multipass.shinyapps.io/EPAScoreApp/)
 - [Coursera John Hopkins Data Science - Developing Data Products](https://www.coursera.org/learn/data-products/home/welcome)
 - [Caret R Package] (http://caret.r-forge.r-project.org/)
 - [CART Machine learning] (https://en.wikipedia.org/wiki/Decision_tree_learning)
