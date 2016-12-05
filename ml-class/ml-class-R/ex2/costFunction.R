

cost.function <- function(X, y, theta){

#COSTFUNCTION Compute cost and gradient for logistic regression
#   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
#   parameter for logistic regression and the gradient of the cost
#   w.r.t. to the parameters.

# Initialize some useful values

m <- length(y) # number of training examples
# You need to return the following variables correctly 
J <- 0

n <- length(theta)

# ====================== YOUR CODE HERE ======================
# Instructions: Compute the cost of a particular choice of theta.
#               You should set J to the cost.
#               Compute the partial derivatives and set grad to the partial
#               derivatives of the cost w.r.t. each parameter in theta
#
# Note: grad should have the same dimensions as theta
#



preds <- sigmoid(X%*%theta)

J <- 1/m * ((t(-y)%*%log(preds)) - ((1-t(y))%*%log(1-preds)) )


# =============================================================

return(J)

}

grad.function <- function(X,y, theta) {
  m <- length(y)
  J <- 0
  predictions <- sigmoid(X%*%theta)
  grad <-  rep(0, length(theta))
  grad <- 1/m*t(predictions-y) %*% X
  return(grad)

}