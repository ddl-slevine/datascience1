# This is a sample R model
# You can publish a model API by clicking on "Publish" and selecting
# "Model APIs" in your quick-start project.

# Load dependencies
library(jsonlite)

# Define a function to create an API
# To call model use: {"data": {"min": 1, "max": 100}}
my_model <- function(min, max) {
  random_number <- runif(1, min, max)
  return(list(number=random_number))
}
