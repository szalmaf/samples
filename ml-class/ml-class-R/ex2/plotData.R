library(ggplot2)
plot.data <- function(X,y) {


#PLOTDATA Plots the data points X and y into a new figure 
#   PLOTDATA(x,y) plots the data points with + for the positive examples
#   and o for the negative examples. X is assumed to be a Mx2 matrix.

# Create New Figure


# ====================== YOUR CODE HERE ======================
# Instructions: Plot the positive and negative examples on a
#               2D plot, using the option 'k+' for the positive
#               examples and 'ko' for the negative examples.
#
data <- as.data.frame(cbind(X,y))
data$y <- as.factor(y)

plot <- ggplot2::ggplot() + ggplot2::geom_point(data=data, mapping=aes(X[,1], X[,2], colour="red", shape=y))
plot



# =========================================================================




}
