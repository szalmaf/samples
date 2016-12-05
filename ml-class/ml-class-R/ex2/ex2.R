library(ggplot2)
## Machine Learning Online Class - Exercise 2: Logistic Regression
#
#  Instructions
#  ------------
# 
#  This file contains code that helps you get started on the logistic
#  regression exercise. You will need to complete the following functions 
#  in this exericse:
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
rm(list=ls())

## Load Data
#  The first two columns contains the exam scores and the third column
#  contains the label.

data <- as.matrix(read.csv('ex2data1.txt', sep=",", header=FALSE))

X <- data[,1:2]
y <- data[,3]


## ==================== Part 1: Plotting ====================
source("plotData.R")
#  We start the exercise by first plotting the data to understand the 
#  the problem we are working with.

cat('Plotting data with shape based on (y = 1) examples and (y = 0) examples.\n')

p <- plot.data(X, y)

# Put some labels 

# Labels and Legend

p <- p + labs(x="Exam 1 score", y='Exam 2 score')
p <- p + scale_shape_discrete(name ="Legend",
                           labels=c("Admitted", "Not Admitted")) + scale_color_discrete(breaks="false")

# Specified in plot order

print(p)

cat('\nProgram paused. Press enter to continue.\n');
line <- readLines(con=stdin(),1)



## ============ Part 2: Compute Cost and Gradient ============
source("costFunction.R")
source("sigmoid.R")
#  In this part of the exercise, you will implement the cost and gradient
#  for logistic regression. You neeed to complete the code in 
#  costFunction.m

#  Setup the data matrix appropriately, and add ones for the intercept term

m <- dim(X)[1]
n <- dim(X)[2]
# Add intercept term to x and X_test
X <- cbind(rep(1,m), X)

# Initialize fitting parameters
initial_theta <- rep(0, n+1)

# Compute and display initial cost and gradient

cost <- cost.function(X, y, initial_theta)
grad <- grad.function(X, y, initial_theta)

cat(sprintf('Cost at initial theta (zeros): %f\n', cost))
cat('Gradient at initial theta (zeros): \n')
#cat(sprintf(' %f \n', grad))

cat('\nProgram paused. Press enter to continue.\n');
line <- readLines(con=stdin(),1)


## ============= Part 3: Optimizing using fminunc  =============
source("plotDecisionBoundary.R")
#  In this exercise, you will use a built-in function (fminunc) to find the
#  optimal parameters theta.

#  Set options for fminunc


#  Run fminunc to obtain the optimal theta
#  This function will return theta and the cost 

options <- optim(par=initial_theta, 
                   fn=cost.function, 
                   gr=grad.function,
                   method='BFGS', 
                   control=list(maxit=400),
                   X=X,
                   y=y)


theta <- options$par
cost <- options$value

# Print theta to screen
cat(sprintf('Cost at theta found by fminunc: %f\n', cost))
cat('theta: \n')
cat(sprintf(' %f \n', theta))



# Plot Boundary
plot <- plot.decision.boundary(X,y,theta)
# Put some labels 

plot <- plot + xlab('Exam 1 score') + ylab('Exam 2 score')
# Labels and Legend
plot <- plot + ggplot2::scale_shape_discrete(name ="Legend",
                           labels=c("Admitted", "Not Admitted")) + scale_color_discrete(breaks="false")

# Specified in plot order

print(plot)

cat('\nProgram paused. Press enter to continue.\n')
line <- readLines(con=stdin(),1)

## ============== Part 4: Predict and Accuracies ==============
source("predict.R")
#  After learning the parameters, you'll like to use it to predict the outcomes
#  on unseen data. In this part, you will use the logistic regression model
#  to predict the probability that a student with score 45 on exam 1 and 
#  score 85 on exam 2 will be admitted.
#
#  Furthermore, you will compute the training and test set accuracies of 
#  our model.
#
#  Your task is to complete the code in predict.m

#  Predict probability for a student with score 45 on exam 1 
#  and score 85 on exam 2 


prob <- sigmoid(t(c(1,45,85))%*%theta)

cat(sprintf('For a student with scores 45 and 85, we predict an admission 
	probability of %f\n\n', prob))

# Compute accuracy on our training set

p <- predict.output(X, theta)

cat(sprintf('Train Accuracy: %f\n', length(which(p==y))/length(p==y) * 100))

cat('\nProgram paused. Press enter to continue.\n')


