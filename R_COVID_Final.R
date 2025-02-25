library(lme4)
#library(lme4)
library(MASS)
library(car)
library(stargazer)
library(splines)
library(dplyr)
library(lmtest)
library(performance)
library(xtable)

set.seed(0)
data <- read.csv('data_deID.csv')


#data$Age_At_Covid_Date <- scale(data$Age_At_Covid_Date)
#data$Centered_Episodes <- data$Episodes / max(data$Episodes)

data$Time_01 <- data$Time/ 360
# Add an autoregressive term - the residuals look strange otherwise
# data <- data %>%
#   group_by(Person_ID) %>%
#   arrange(Time) %>%
#   mutate(Lagged_Behavior = lag(Behavior))
data$Logit_Transformed_Behavior <- log(data$Behavior / (1 - data$Behavior))
data$Numeric_Behavior <- data$Behavior
data$Behavior <- as.factor(data$Behavior)
data$Person_ID <- as.factor(data$Person_ID)
data$Weekend <- as.factor(data$Weekend)
data$Unexpected_Closure <- as.factor(data$Unexpected_Closure)
data$School <- as.factor(data$School)
data$Covid <- as.factor(data$Covid)
#data$Sex <- as.factor(data$Sex)
#data$LogTime <- log(data$Time + 1)
#data$Time <- as.factor(data$Time)

data <- na.omit(data)

data$Centered_Time <- scale(data$Time, center = TRUE, scale = TRUE)

library(glmmTMB)
fit <- glmmTMB(Behavior ~ Centered_Time *  Covid + School + Weekend + Unexpected_Closure + (1 | Person_ID),
               family='binomial',
               data= data)
check_model(fit)
b <- summary(fit)
tab <- xtable(round(b$coefficients$cond,3))
print(tab)
summary(fit)
fit2 <- glmmTMB(Episodes ~  Centered_Time * Covid +  School + Weekend + Unexpected_Closure + (1 | Person_ID),
                data= data,
                family =nbinom2)
summary(fit2)
b2 <- summary(fit2)
tab2 <- xtable(round(b2$coefficients$cond,3))
print(tab2)
