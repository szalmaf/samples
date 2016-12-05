library(magrittr)
## Machine Learning Online Class - Exercise 1: Linear Regression

#  Instructions
#  ------------
# 
#  This file contains code that helps you get started on the
#  linear exercise. You will need to complete the following functions 
#  in this exericse:
#
#     warmUpExercise.m
#     plotData.m
#     gradientDescent.m
#     computeCost.m
#     gradientDescentMulti.m
#     computeCostMulti.m
#     featureNormalize.m
#     normalEqn.m
#
#  For this exercise, you will not need to change any code in this file,
#  or any other files other than those mentioned above.
#
# x refers to the population size in 10,000s
# y refers to the profit in $10,000s
#

## Initialization
rm(list=ls())


## ==================== Part 1: Basic Function ====================
# Complete warmUpExercise.m 
source("warmUpExercise.R")
cat('Running warmUpExercise ... \n')
cat('5x5 Identity Matrix: \n')
print(warmUpExercise())

cat('Program paused. Press enter to continue.\n')
line <- readLines(con = stdin(), 1)


## ======================= Part 2: Plotting =======================
source("plotData.R")
cat('Plotting Data ...\n')
df = read.csv("ex1data1.txt", sep=",")
X = df[1]
y = as.matrix(df[2])
m = nrow(y) # number of training examples

# Plot Data
# Note: You have to complete the code in plotData.m
plot.data(X, y)

cat('Program paused. Press enter to continue.\n')
line <- readLines(con=stdin(),1)

## =================== Part 3: Gradient descent ===================
source("computeCost.R")
source("gradientDescent.R")
cat('Running Gradient Descent ...\n')

X = cbind(rep(1,m),X)%>%as.matrix(X) # Add a column of ones to x

theta = rep(0, 2) # initialize fitting parameters

# Some gradient descent settings
iterations <- 1500
alpha <- 0.01

# compute and display initial cost
compute.cost(X, y, theta)

# run gradient descent
gradient.descent <- gradient.descent(X, y, theta, alpha, iterations)
theta <- gradient.descent$theta
J.hist <- gradient.descent$J.history
# print theta to screen
cat('Theta found by gradient descent: ')
cat(sprintf('%f %f \n', theta[1], theta[2]))

# Plot the linear fit
# keep previous plot visible
library(ggplot2)

####lines(X[,2], X%*%theta, col='blue')
####legend(c('Training data', 'Linear regression'))

# don't overlay any more plots on this figure

# Predict values for population sizes of 35,000 and 70,000
predict1 <- c(1, 3.5)%*%theta
cat(sprintf('For population = 35,000, we predict a profit of %f\n',
    predict1*10000))
predict2 <- c(1, 7) %*% theta
cat(sprintf('For population = 70,000, we predict a profit of %f\n',
    predict2*10000))

cat('Program paused. Press enter to continue.\n')
line <- readLines(con=stdin(),1)

## ============= Part 4: Visualizing J(theta_0, theta_1) =============
cat('Visualizing J(theta_0, theta_1) ...\n')

# Grid over which we will calculate J
theta0_vals = seq(-10, 10, length.out=100)
theta1_vals = seq(-1, 4, length.out=100)

# initialize J_vals to a matrix of 0's
J_vals = matrix(0, length(theta0_vals), length(theta1_vals))

# Fill out J_vals
for (i in 1:length(theta0_vals)){

    for (j in 1:length(theta1_vals)){
	  t <- c(theta0_vals[i], theta1_vals[j])  
	  J_vals[i, j] <- compute.cost(X, y, t)
   }
}

#interactive 3D plot
#install.packages("rgl")