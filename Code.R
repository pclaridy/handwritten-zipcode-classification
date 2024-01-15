# Import the training data and filter for digits 5 and 6
trainData <- read.table("zip.train.csv", sep = ",")
filteredTrain <- subset(trainData, trainData[,1] == 5 | trainData[,1] == 6)

# Display initial data insights
cat("Dimensions: ", dim(filteredTrain), "\n")
cat("Count of 5s: ", sum(filteredTrain[,1] == 5), "\n")
cat("Count of 6s: ", sum(filteredTrain[,1] == 6), "\n")
print(head(filteredTrain))
print(summary(filteredTrain))
print(round(cor(filteredTrain), 2))

# Data visualization setup
visualizationRow <- 37
cat("Digit at row", visualizationRow, ": ", filteredTrain[visualizationRow, 1], "\n")
visualMatrix <- t(matrix(as.matrix(filteredTrain[visualizationRow, -1]), nrow = 16, ncol = 16, byrow = TRUE)[16:1, ])
png("digit_image_grayscale.png")
image(1:16, 1:16, z = visualMatrix, col = gray(0:1), xlab = "", ylab = "", axes = FALSE)
dev.off()

png("digit_image_colored.png")
image(1:16, 1:16, z = visualMatrix, col = gray(0:32/32), xlab = "", ylab = "", axes = FALSE)
dev.off()

# Linear Regression Model Prediction
lrModel <- lm(V1 ~ ., data = filteredTrain)
y1pred.train <- predict(lrModel, filteredTrain[,-1])
y1pred.train <- 5 + (y1pred.train >= 5.5)

# KNN Model Prediction (k=3)
library(class)
kk <- 3
ypred2.train <- knn(train = filteredTrain[,-1], test = filteredTrain[,-1], cl = filteredTrain[,1], k = kk)


# Calculating mean error rates
meanErrorLinearRegression <- mean(y1pred.train != filteredTrain[,1])
meanErrorKNN3 <- mean(ypred2.train != filteredTrain[,1])

# Displaying the performance summary
cat("Linear Regression Mean Error Rate: ", meanErrorLinearRegression, "\n")
cat("KNN (k=3) Mean Error Rate: ", meanErrorKNN3, "\n")

# Preparing for cross-validation
set.seed(7406)
testData <- read.table("zip.test.csv", sep = ",")
filteredTest <- subset(testData, testData[,1] == 5 | testData[,1] == 6)
combinedData <- rbind(filteredTrain, filteredTest)
trainingSize <- dim(filteredTrain)[1]
totalSize <- dim(combinedData)[1]
cvResults <- matrix(nrow = 100, ncol = 9)
columnNames <- c("LinearReg", paste0("KNN", c(1, 3, 5, 7, 9, 11, 13, 15)))
colnames(cvResults) <- columnNames

# Conducting cross-validation
for (i in 1:100) {
  trainIndices <- sort(sample(totalSize, trainingSize))
  trainingSubset <- combinedData[trainIndices, ]
  testSubset <- combinedData[-trainIndices, ]
  
  # Linear Regression Model
  lrModel <- lm(V1 ~ ., data = trainingSubset)
  lrPredictions <- predict(lrModel, testSubset[,-1])
  lrPredictedClasses <- ifelse(lrPredictions >= 5.5, 6, 5)
  cvResults[i, "LinearReg"] <- mean(lrPredictedClasses != testSubset[,1])
  
  # KNN Models
  for (k in c(1, 3, 5, 7, 9, 11, 13, 15)) {
    knnPredictions <- knn(train = trainingSubset[,-1], test = testSubset[,-1], cl = trainingSubset[,1], k = k)
    cvResults[i, paste0("KNN", k)] <- mean(knnPredictions != testSubset[,1])
  }
}

# Analyzing Cross-Validation Results
meanTestErrors <- colMeans(cvResults)
varTestErrors <- apply(cvResults, 2, var)
print(meanTestErrors)
print(varTestErrors)
