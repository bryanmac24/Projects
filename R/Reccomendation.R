##Demo: How to build a recommendation engine in R
## setwd("C:/Users/User/Desktop/Data-Mania Blog Coding Demos/Recommendation Engine in R")
#Read all the datasets
movies=read.csv("/Users/bryanmac/Desktop/ml-latest-small/movies.csv")
links=read.csv("/Users/bryanmac/Desktop/ml-latest-small/links.csv")
ratings=read.csv("/Users/bryanmac/Desktop/ml-latest-small/ratings.csv")
tags=read.csv("/Users/bryanmac/Desktop/ml-latest-small/tags.csv")
#Import the reshape2 library. Use the file install.packages(“reshape2”) if the package is not already installed
library(stringi)
library(reshape2)

#Create ratings matrix with rows as users and columns as movies. We don't need timestamp
ratingmat = dcast(ratings, userId~movieId, value.var = "rating", na.rm=FALSE)

#We can now remove user ids
ratingmat = as.matrix(ratingmat[,-1])

#Uncomment the following line if the package is not installed
library(recommenderlab)

#Convert ratings matrix to real rating matrx which makes it dense
ratingmat = as(ratingmat, "realRatingMatrix")

#Normalize the ratings matrix
ratingmat = normalize(ratingmat) 

#Create Recommender Model. The parameters are UBCF and Cosine similarity. We take 10 nearest neighbours
rec_mod = Recommender(ratingmat, method = "UBCF", param=list(method="Cosine",nn=10)) 

#Obtain top 5 recommendations for 1st user entry in dataset
Top_5_pred = predict(rec_mod, ratingmat[1], n=5)

#Convert the recommendations to a list
Top_5_List = as(Top_5_pred, "list")
Top_5_List

#Uncomment the following line if the package is not installed
#install.packages("dplyr")
library(dplyr)

#We convert the list to a dataframe and change the column name to movieId
Top_5_df=data.frame(Top_5_List)
colnames(Top_5_df)="movieId"

#Since movieId is of type integer in Movies data, we typecast id in our recommendations as well
Top_5_df$movieId=as.numeric(levels(Top_5_df$movieId))

#Merge the movie ids with names to get titles and genres
names=left_join(Top_5_df, movies, by="movieId")

#Print the titles and genres
names