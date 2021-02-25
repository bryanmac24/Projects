data<-coronavirus::coronavirus %>%
  filter(!type == "confirmed") %>%
  filter(country == "US") %>%
  filter(!is.na(type))

intrain <- createDataPartition(y = data$type, p= 0.8, list = FALSE)
training <- data[intrain,]
testing <- data[-intrain,]

training[["type"]] = factor(training[["type"]])

svmfit <- svm(type ~ cases, data=training, kernel="linear", cost=10, scale=FALSE)
svmfit

data$type<-as.factor(data$type)
modrf <- train(type~cases, data=training, method="rf")
modrf

modknn <- train(type~cases, data=training, method="kknn")
modknn

install.packages("rstan",dependencies =T)
library(rstan)
install.packages("prophet",dependencies =T)
library(prophet)

COVID<-COVID19::covid19()

data %>% 
  filter(type=="recovered") %>%
  select(date, cases)

data %>% 
  filter(type=="recovered") %>%
  select(ds=date, y=cases)

pmod <- data %>% 
  filter(type=="recovered") %>%
  select(ds=date, y=cases) %>% 
  prophet()

future <- make_future_dataframe(pmod, periods=365*5)
tail(future)

forecast <- predict(pmod, future)
tail(forecast)

plot(pmod, forecast) + ggtitle("Five year ILI forecast")

prophet_plot_components(pmod, forecast)

pmod <- data %>%
  filter(!is.na(pneumoniadeaths)) %>%
  select(ds=week_start, y=pneumoniadeaths) %>%
  prophet()
future <- make_future_dataframe(pmod, periods=365*5)
forecast <- predict(pmod, future)
plot(pmod, forecast) + ggtitle("Five year pneumonia death forecast")