cost.function.reg <- function(X, y, theta, lambda) {


#COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
#   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
#   theta as the parameter for regularized logistic regression and the
#   gradient of the cost w.r.t. to the parameters. 

# Initialize some useful values
m <- length(y) # number of training examples
n <- length(theta)

# You need to return the following variables correctly 
J <- 0


# ====================== YOUR CODE HERE ======================
# Instructions: Compute the cost of a particular choice of theta.
#               You should set J to the cost.
#               Compute the partial derivatives and set grad to the partial
#               derivatives of the cost w.r.t. each parameter in theta

predictions <- sigmoid(X%*%theta)
cost <- 1/m * ((t(-y) %*% log(predictions)) - t((1-y)) %*% log(1-predictions)) +
          lambda / (2*m) * sum(theta^2)






# =============================================================

}

grad.function.reg <- function(X,y, theta,lambda) {
	m <- length(y)
	n <- length(theta)
	predictions <- sigmoid(X%*%theta)
	grad <-  rep(0, length(theta))
	grad <- 1/m*t(predictions-y) %*% X + lambda/m*theta
	return(grad)

}