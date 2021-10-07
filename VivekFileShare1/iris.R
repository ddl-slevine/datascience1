set.seed(12345)

library(caret)
library(ggplot2)

method <- "svmRadial"
dataset <- "iris"
target <- "Species"

my_data <- get(dataset)


inTrain <- createDataPartition(my_data[, target], list=FALSE, p=0.6)

training <- my_data[inTrain,]
testing <- my_data[-inTrain,]

formula <- paste0(target, " ~ .")
model <- train(as.formula(formula), data=training, method=method)
confusion_matrix <- confusionMatrix(predict(model, testing), testing[, target])

print(model)

#save plot as image
png(filename = "plot.png")
plot(model)
dev.off()

#display plot
plot(model)



#create a confusion matrix
cf_df <- as.data.frame(confusion_matrix$table)
conf_plot <- ggplot(cf_df, aes(x=Prediction, y=Reference, fill=Freq)) +
  geom_tile() +
  ggtitle(paste("Confusion Matrix for", model$modelInfo$label))


#save the confusion matrix to a file
png(filename = "confusionMatrix.png")
conf_plot
dev.off()

#display the confusion matrix
conf_plot



save(model, file="model.RData")

metric <- model$metric
index_of_best_model <- which(max(model$results[, metric]) == model$results[, metric])

diagnostics = list("Train Accuracy"=model$results[index_of_best_model, "Accuracy"],
                   "Test Accuracy"=confusion_matrix$overall[["Accuracy"]])

for (my_name in names(model$bestTune)) {
  diagnostics[[paste0("Param(",my_name, ")")]] = model$bestTune[[my_name]]
}

library(jsonlite)
fileConn<-file("dominostats.json")
writeLines(toJSON(diagnostics), fileConn)
close(fileConn)
