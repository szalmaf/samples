## Machine Learning Online Class - Exercise 2: Logistic Regression
#
#  Instructions
#  ------------
# 
#  This file contains code that helps you get started on the second part
#  of the exercise which covers regularization with logistic regression.
#
#  You will need to complete the following functions in this exericse:
#
#     sigmoid.m
#     costFunction.m
#     predict.m
#     costFunctionReg.m
#
#  For this exercise, you will not need to change any code in this file,
#  or any other files other than those mentioned above.
#

## Initialization
source("plotData.R")

## Load Data
#  The first two columns contains the X values and the third column
#  contains the label (y).

data <- as.matrix(read.csv('ex2data2.txt', sep=",", header=FALSE))
X = data[,1:2]
y = data[,3]

p <- plot.data(X, y)

# Put some labels 


# Labels and Legend
p <- p + labs(x='Microchip Test 1', y='Microchip Test 2')


# Specified in plot order

p <- p + scale_shape_discrete(name ="Legend",
                           labels=c("y=1", "y=0")) + scale_color_discrete(breaks="false")


print(p)

## =========== Part 1: Regularized Logistic Regression ============
source("sigmoid.R")
source("mapFeature.R")
source("costFunctionReg.R")
#  In this part, you are given a dataset with data points that are not
#  linearly separable. However, you would still like to use logistic 
#  regression to classify the data points. 
#
#  To do so, you introduce more features to use -- in particular, you add
#  polynomial features to our data matrix (similar to polynomial
#  regression).
#

# Add Polynomial Features

# Note that mapFeature also adds a column of ones for us, so the intercept
# term is handled
#X <- map.feature(X[,1], X[,2])

# Initialize fitting parameters
m <- dim(X)[1]
n <- dim(X)[2]
X <- cbind(rep(1,m), X)
initial_theta <- rep(0,dim(X)[2])

# Set regularization parameter lambda to 1
#lambda <- 1

# Compute and display initial cost and gradient for regularized logistic
# regression
cost <- cost.function.reg(X, y, initial_theta, lambda)
grad <- grad.function.reg(X, y, initial_theta, lambda)

cat(sprintf('Cost at initial theta (zeros): %f\n', cost))

cat('\nProgram paused. Press enter to continue.\n');
line <- readLines(con=stdin(),1)

## ============= Part 2: Regularization and Accuracies =============
#  Optional Exercise:
#  In this part, you will get to try different values of lambda and 
#  see how regularization affects the decision coundart
#
#  Try the following values of lambda (0, 1, 10, 100).
#
#  How does the decision boundary change when you vary lambda? How does
#  the training set accuracy vary?
#

# Initialize fitting parameters
initial_theta = rep(0, dim(X)[2])

# Set regularization parameter lambda to 1 (you should vary this)
lambda <- 0.02

# Set Options
options <- optim(par=initial_theta, 
		fn = cost.function.reg, 
		gr = grad.function.reg,
		method="CG",
		control= list(maxit=400),
		X=X,
		y=y,
		lambda=lambda)

# Optimize
theta <- options$par
J <- options$value

# Plot Boundary
source("plotDecisionBoundary.R")
plot <- plot.decision.boundary(X, y, theta)


# Labels and Legend
plot <- plot + labs(x='Microchip Test 1', y='Microchip Test 2')


plot <- plot + scale_shape_discrete(name ="Legend",
                           labels=c("y=1", "y=0")) + scale_color_discrete(breaks="false")


print(plot)

# Compute accuracy on our training set
source("predict.R")
preds <- predict.output(X, theta)

cat(sprintf('Train Accuracy: %f\n', length(which(preds==y))/length(preds==y) * 100))

cat('\nProgram paused. Press enter to continue.\n')


