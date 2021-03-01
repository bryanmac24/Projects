options(scipen = 999)

library(dplyr)
library(caret)
library(mlbench)
library(MLeval)

data<-coronavirus::coronavirus %>%
  filter(!type == "confirmed") %>%
  filter(!is.na(type))

intrain <- createDataPartition(y = data$type, p= 0.8, list = FALSE)
training <- data[intrain,]
testing <- data[-intrain,]

training[["type"]] = factor(training[["type"]])

# prepare training scheme
control <- trainControl(method = "cv", 
                        number = 10, 
                        savePredictions = TRUE, 
                        classProbs = TRUE, 
                        verboseIter = TRUE)
# CART
set.seed(7)
fit.cart <- train(type ~ cases, data=training, method="rpart", trControl=control, preProc=c("center", "scale"))
fit.cart
# LDA
set.seed(7)
fit.lda <- train(type ~ cases, data=training, method="lda", trControl=control, preProc=c("center", "scale"))
fit.lda
# SVM
set.seed(7)
fit.svm <- train(type ~ cases, data=training, method="svmRadial", trControl=control, preProc=c("center", "scale"))
it.svm
# kNN
set.seed(7)
fit.knn <- train(type ~ cases, data=training, method="knn", trControl=control, preProc=c("center", "scale"))
fit.knn
# Random Forest
set.seed(7)
fit.rf <- train(type ~ cases, data=training, method="rf", trControl=control, preProc=c("center", "scale"))
fit.rf
# Logistic Regression
set.seed(7)
fit.log <- train(type ~ cases, data=training, method="glm", trControl=control,family=binomial, preProc=c("center", "scale"))
fit.log
# Neural Net
set.seed(7)
fit.nn <- train(type ~ cases, data=training, method="nnet", trControl=control, preProc=c("center", "scale"))
fit.nn
# collect resample
set.seed(7)
results <- resamples(list(CART=fit.cart, LDA=fit.lda, SVM=fit.svm, KNN=fit.knn, RF=fit.rf,Log.Regression=fit.log,NN=fit.nn))

# summarize differences between modes
summary(results)

#box and whisker plots to compare models
scales <- list(x=list(relation="free"), y=list(relation="free"))
bwplot(results, scales=scales)

res <- evalm(list(fit.cart,fit.lda,fit.svm,fit.knn,fit.rf,fit.log,fit.nn),gnames=c('CART','LDA','SVM','KNN','RF','LOG.REGRESSION','NN'), rlinethick=0.8, fsize=8, plots='r')

# Cox Survival
library(survival)
cox <- coxph(Surv(date, deaths) ~ workplace_closing + testing_policy + information_campaigns + international_movement_restrictions
             + internal_movement_restrictions + school_closing + cancel_events + gatherings_restrictions + transport_closing + stay_home_restrictions +
               contact_tracing, data = covid)
summary(cox)

covid <-COVID19::covid19()

covid$date <- as.numeric(as.POSIXct(covid$date, format="%m-%d-%Y"))

str(covid)

covid <- covid %>% filter(id == "USA")

covid[is.na(covid)] <- 0

library(survival)
cox <- lm(deaths ~ workplace_closing + testing_policy + information_campaigns + international_movement_restrictions
          + internal_movement_restrictions + school_closing + cancel_events + gatherings_restrictions + transport_closing + stay_home_restrictions +
            contact_tracing, data = covid)
summary(cox)
