# Predictive Insights into Handwritten Digit Classification

## Table of Contents

1. [Problem Statement](#1-problem-statement)  
2. [Data Source](#2-data-source)  
3. [Data Cleaning & Preprocessing](#3-data-cleaning--preprocessing)  
4. [Exploratory Data Analysis (EDA)](#4-exploratory-data-analysis-eda)  
5. [Modeling Approach](#5-modeling-approach)  
6. [Evaluation Metrics](#6-evaluation-metrics)  
7. [Outcome](#7-outcome)  
8. [Tools Used](#8-tools-used)  
9. [Business Impact / Use Case](#9-business-impact--use-case)

---

## 1. Problem Statement

Accurately classifying handwritten digits is a foundational challenge in image recognition and optical character recognition systems. This project explores how machine learning can distinguish between visually similar digits, specifically '5' and '6', using pixel intensity data. The goal is to evaluate and compare the performance of simple and intuitive models such as Linear Regression and K-Nearest Neighbors (KNN), and to identify which provides the best accuracy with minimal variance. Beyond raw performance, the project emphasizes generalizability and model interpretability to support broader image classification tasks in real-world applications such as postal automation, check processing, and document digitization.

---

## 2. Data Source

The dataset contains grayscale images of handwritten digits '5' and '6', formatted in a 16x16 grid (flattened into 256 features). It includes:

- **Samples**: 1,220 total (556 labeled '5' and 664 labeled '6')  
- **Features**: 256 pixel intensity values ranging from -1 to 1  
- **Target Variable**: Digit label (either 5 or 6)

This nearly balanced dataset prevents bias and ensures reliable training and evaluation. The raw image data was provided as a CSV file, where each row represents one digit image.

---

## 3. Data Cleaning & Preprocessing

- Filtered the dataset to include only digits '5' and '6'
- Normalized the pixel values (originally ranging from -1 to 1) to maintain consistent input scale
- Verified class balance to ensure fair model evaluation
- Prepared data for modeling by separating features (pixels) from labels and applying multiple randomized train-test splits for cross-validation

---

## 4. Exploratory Data Analysis (EDA)

- **Pixel Distribution**: Border pixels typically have values near -1, indicating empty space, while central pixels capture digit strokes
- **Class Balance**: 556 samples of digit '5' and 664 of digit '6', nearly balanced, reducing risk of model bias
- **Informative Pixels**: Most classification signal lies in the central grid region; peripheral pixels are less helpful

EDA established a clear understanding of data structure and helped inform modeling expectations, especially around the potential for overfitting based on pixel location relevance.

---

## 5. Modeling Approach

Two models were evaluated:

- **Linear Regression** (used here as a classification proxy by thresholding predictions)
- **K-Nearest Neighbors (KNN)**, evaluated for k = 1 through 15

Key considerations:

- Multiple randomized train-test splits ensured robustness through cross-validation
- Model training was repeated to capture variation in performance
- For each model, both training and testing errors were recorded
- KNN performance was evaluated as a function of k to determine the most effective neighborhood size

---

## 6. Evaluation Metrics

The models were evaluated using:

- **Mean Testing Error**, which measures misclassification rate on unseen data
- **Variance of Testing Error**, which measures stability across random splits

### Mean Testing Error by Model

| Model             | Mean Testing Error |
|------------------|--------------------|
| Linear Regression | 0.02530           |
| KNN (k=1)         | 0.01039           |
| KNN (k=3)         | 0.00870           |
| KNN (k=5)         | 0.00991           |
| KNN (k=7)         | 0.01133           |
| KNN (k=9)         | 0.01270           |
| KNN (k=11)        | 0.01433           |
| KNN (k=13)        | 0.01597           |
| KNN (k=15)        | 0.01670           |

### Variance of Testing Error by Model

| Model             | Variance           |
|------------------|--------------------|
| Linear Regression | 5.68e-05          |
| KNN (k=1)         | 2.47e-05          |
| KNN (k=3)         | 1.89e-05          |
| KNN (k=5)         | 2.74e-05          |
| KNN (k=7)         | 3.07e-05          |
| KNN (k=9)         | 3.95e-05          |
| KNN (k=11)        | 4.28e-05          |
| KNN (k=13)        | 4.71e-05          |
| KNN (k=15)        | 5.24e-05          |

---

## 7. Outcome

The best-performing model was **K-Nearest Neighbors with k = 3**, achieving the lowest mean testing error (0.00870) and low variance. It provided the strongest balance between overfitting and underfitting, generalizing well to unseen data. Linear Regression also performed reasonably well, with a mean error of 0.02530, though it lacked the flexibility to capture the pixel-based patterns as effectively as KNN.

Linear Regression underperformed in part because it is not designed for binary classification tasks and assumes linear separability. It is less capable of modeling non-linear decision boundaries, which limits its effectiveness when applied to spatial pixel data.

Although Logistic Regression would have been a more theoretically appropriate choice for binary classification, this project used Linear Regression as a simple benchmark for comparison. Including Logistic Regression in future work could help establish a more robust baseline.

Further testing on a separate holdout dataset of 330 new observations confirmed the KNN model's robustness, with an even lower mean error of 0.0030.

---

## 8. Tools Used

- **Python**: Core implementation language  
- **Pandas, NumPy**: Data manipulation  
- **Scikit-learn**: Modeling and cross-validation  
- **Matplotlib, Seaborn**: Visual analysis

---

## 9. Business Impact / Use Case

The techniques explored in this project are foundational for a wide range of real-world applications, including:

- **Optical Character Recognition (OCR)**: Used in postal services, check scanning, and document digitization  
- **Financial Tech**: Automated digit extraction for processing forms  
- **Educational Tools**: Adaptive handwriting tutors or grading systems  
- **Computer Vision Research**: Provides a baseline approach before advancing to deep learning methods

This project demonstrates that even with relatively simple models, high classification accuracy can be achieved when using carefully prepared and structured image data. The methodology and insights are transferable to broader multi-class digit recognition problems and scalable to larger datasets and more complex image formats.
