gradient.descent.multi <- function(X, y, theta, alpha, num_iters){
#GRADIENTDESCENTMULTI Performs gradient descent to learn theta
#   theta = GRADIENTDESCENTMULTI(x, y, theta, alpha, num_iters) updates theta by
#   taking num_iters gradient steps with learning rate alpha

# Initialize some useful values
m <- length(y) # number of training examples



J.history <- rep(0,num_iters)

for (i in 1:num_iters){

    # ====================== YOUR CODE HERE ======================
    # Instructions: Perform a single gradient step on the parameter vector
    #               theta. 
    #
    # Hint: While debugging, it can be useful to print out the values
    #       of the cost function (computeCostMulti) and gradient here.
    #

    h_prime <- X%*%theta
    error <- h_prime-y
    gradient <- t(X)%*%error
    theta <- theta - alpha*(1/m)*gradient



    # ============================================================

    # Save the cost J in every iteration    
    J.history[i] <- compute.cost.multi(X, y, theta)

}
list(theta=theta, J.history=J.history)
}