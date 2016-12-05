library(magrittr)
## Machine Learning Online Class
#  Exercise 1: Linear regression with multiple variables
#
#  Instructions
#  ------------
# 
#  This file contains code that helps you get started on the
#  linear regression exercise. 
#
#  You will need to complete the following functions in this 
#  exericse:
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
#  For this part of the exercise, you will need to change some
#  parts of the code below for various experiments (e.g., changing
#  learning rates).
#

## Initialization

## ================ Part 1: Feature Normalization ================

## Clear and Close Figures
rm(list=ls())

cat('Loading data ...\n')

## Load Data
df <- as.matrix(read.csv('ex1data2.txt', sep=",", header=FALSE))
X <- df[,1:2]
y <- df[,3]
m <- length(y)

# Print out some data points
cat('First 10 examples from the dataset: \n')
print(cbind(X[1:10,],y[1:10,]))

cat('Program paused. Press enter to continue.\n')
line <- readLines(con=stdin(),1)

# Scale features and set them to zero mean
source("featureNormalize.R")
cat('Normalizing Features ...\n')

normalized.matrix = feature.normalize(X)


# Add intercept term to X
cat('First 10 examples from the normalized dataset: \n')
X = normalized.matrix$X_norm
print(X[1:10,])
mu <- normalized.matrix$mu
sigma <- normalized.matrix$sigma
X <- cbind(rep(1,m),X)%>%as.matrix(X)

cat('Program paused. Press enter to continue.\n')
line <- readLines(con=stdin(),1)

## ================ Part 2: Gradient Descent ================
source("gradientDescentMulti.R")
source("computeCostMulti.R")

# ====================== YOUR CODE HERE ======================
# Instructions: We have provided you with the following starter
#               code that runs gradient descent with a particular
#               learning rate (alpha). 
#
#               Your task is to first make sure that your functions - 
#               computeCost and gradientDescent already work with 
#               this starter code and support multiple variables.
#
#               After that, try running gradient descent with 
#               different values of alpha and see which one gives
#               you the best result.
#
#               Finally, you should complete the code at the end
#               to predict the price of a 1650 sq-ft, 3 br house.
#
# Hint: By using the 'hold on' command, you can plot multiple
#       graphs on the same figure.
#
# Hint: At prediction, make sure you do the same feature normalization.
#

cat('Running gradient descent ...\n')

# Choose some alpha value
alpha <- 0.02
num_iters <- 400

# Init Theta and Run Gradient Descent 
theta <- rep(0, 3)
gradient <- gradient.descent.multi(X, y, theta, alpha, num_iters)
optim(par=theta,
	fn = gradient.descent.multi,
	X=x,
	y=y,
	alpha=alpha,
	num_iters=num_iters
	)
theta <- gradient$theta
J.hist <- gradient$J.history

# Plot the convergence graph

plot(1:length(J.hist), J.hist, type="l", col='blue', lwd=2,
xlab='Number of iterations', ylab='Cost J')

# Display gradient descent's result
cat('Theta computed from gradient descent: \n')
cat(sprintf(' %f \n', theta))

# Estimate the price of a 1650 sq-ft, 3 br house
# ====================== YOUR CODE HERE ======================
# Recall that the first column of X is all-ones. Thus, it does
# not need to be normalized.


normalized.sq.ft <-  (1650-mu[1])/sigma[1]
normalized.rooms <- (3 - mu[2])/sigma[2]
price <- cbind(1, normalized.sq.ft,normalized.rooms)%*%theta # You should change this


# ============================================================

cat(sprintf('Predicted price of a 1650 sq-ft, 3 br house using gradient descent):\n %f\n', price))

#cat(sprintf('Program paused. Press enter to continue.\n'))

#line <- readLines(con=stdin(),1)


