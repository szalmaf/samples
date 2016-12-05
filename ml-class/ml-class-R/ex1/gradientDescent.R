gradient.descent <- function(X, y, theta, alpha, num_iters){


#GRADIENTDESCENT Performs gradient descent to learn theta
#   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
#   taking num_iters gradient steps with learning rate alpha

# Initialize some useful values
m = nrow(y) # number of training examples
J.history <- rep(0, num_iters)


for (iter in 1:num_iters){

    # ====================== YOUR CODE HERE ======================
    # Instructions: Perform a single gradient step on the parameter vector
    #               theta. 
    #
    # Hint: While debugging, it can be useful to print out the values
    #       of the cost function (computeCost) and gradient here.
    #
    h_prime <- X%*%theta
    error <- h_prime-y
    gradient <- (1/m)*(t(X)%*%error)
    theta <- theta - alpha*gradient

     

    # ============================================================

    # Save the cost J in every iteration 
    J.history[iter] = compute.cost(X, y, theta) 
     
  }
list(theta=theta, J.history=J.history)

}
