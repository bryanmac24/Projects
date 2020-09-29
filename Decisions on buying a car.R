library(rpart)
library(rattle)
library(rpart.plot)
### Build the training/validate/test...
iris<-readxl::read_xlsx("/Users/bryanmac/Desktop/CarBuying.xlsx")

nobs <- nrow(iris) 
train <- sample(nrow(iris), 0.7*nobs)
test <- setdiff(seq_len(nrow(iris)), train)

colnames(iris)

### The following variable selections have been noted.
input <- c("Model","Price","Intrest_rate","Transmission","Fueltype","Maintanence","mpg")
numeric <- c("Model","Price","Intrest_rate","Transmission","Fueltype","Maintanence","mpg")
categoric <- NULL
target  <-"Purchase_Intent"
risk    <- NULL
ident   <- NULL
ignore  <- NULL
weights <- NULL

#set.seed(500)
# Build the Decision Tree model.
rpart <- rpart(Purchase_Intent~.,
               data=iris[train, ],
               method="class",
               parms=list(split="information"),
               control=rpart.control(minsplit=5,
                                     usesurrogate=0, 
                                     maxsurrogate=0))

# Generate a textual view of the Decision Tree model.
print(rpart)
printcp(rpart)

# Decision Tree Plot...
rpart.plot(rpart, nn=TRUE)
pdf("/Users/bryanmac/Desktop/plot.pdf")
dev.off()
fancyRpartPlot(rpart)
t_pred = predict(rpart,iris[test, ],type="class")
test_car=iris[test, ]
confMat <- table(test_car$Purchase_Intent,t_pred)
accuracy <- sum(diag(confMat))/sum(confMat)
accuracy

dev.off()
