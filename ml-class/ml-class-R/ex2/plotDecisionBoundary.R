library(ggplot2)
plot.decision.boundary <- function(X, y, theta) {


#PLOTDECISIONBOUNDARY Plots the data points X and y into a new figure with
#the decision boundary defined by theta
#   PLOTDECISIONBOUNDARY(theta, X,y) plots the data points with + for the 
#   positive examples and o for the negative examples. X is assumed to be 
#   a either 
#   1) Mx3 matrix, where the first column is an all-ones column for the 
#      intercept.
#   2) MxN, N>3 matrix, where the first column is all-ones

# Plot Data

slope <- theta[2] / -theta[3]
intercept <- theta[1] / -theta[3]
p <- ggplot2::qplot(X[, 2], X[, 3], colour=as.factor(y), shape=as.factor(y)) + 
      ggplot2::geom_abline(intercept = intercept, slope=slope, 
                  size=0.5, col='black')  
p


   


}
