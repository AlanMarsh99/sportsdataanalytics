# Formula 1 Modeling Process

This document outlines the steps taken during the modelling process for predicting top 3 finishes in Formula 1 races. The modelling process includes data preprocessing, feature engineering, model selection, evaluation, and visualization of results.

---

### Data Loading and Preprocessing

We begin by loading various datasets related to Formula 1, including constructors, drivers, races, and race results data. These datasets are merged using common keys such as `raceId`, `driverId`, and `constructorId` to create a consolidated DataFrame. 

The data is then cleaned by dropping irrelevant columns, handling missing values, and encoding categorical variables (such as circuitId, driverId, and constructorId) as dummy variables for model compatibility. This ensures that the data is in a usable format for machine learning models.

---

### Feature Engineering

A key part of the modelling process is feature engineering. Several new features are created to capture the performance trends for both drivers and constructors:

1. **Top 3 Finish**: A new binary column indicating whether a driver finished in the top 3 for a given race.
2. **Driver Top 3 Finish Percentage (Last Year)**: The percentage of top 3 finishes for each driver in the previous year.
3. **Constructor Top 3 Finish Percentage (Last Year)**: The average top 3 finish percentage of the two drivers in each constructor from the previous year.
4. **Driver Avg Position (Last Year)**: The average race finishing position for each driver during the previous year.
5. **Constructor Avg Position (Last Year)**: The average finishing position for the constructor’s drivers during the previous year.

Additional features such as the **driver’s average position till the current round** and the **constructor’s average position till the current round** are also calculated to capture race-by-race performance for the current year.

---

### Splitting the Data

- **Training Set**: Data from races between 1983 and 2009.
- **Validation Set**: Data from races between 2010 and 2017.
- **Test Set**: Data from races between 2018 and 2024.

These splits make sure that the models are trained on older data, validated on recent data, and evaluated on the most recent race seasons.

---

### Model Selection and Training

Several machine learning models were selected for training and evaluation:

- **Logistic Regression**
- **K-Nearest Neighbors (KNN)**
- **Random Forest Classifier**
- **Decision Tree Classifier**

---

### Model Evaluation

The performance of each model was evaluated using the following metrics:

- **Accuracy**: The percentage of correct predictions made by the model.
- **AUC-ROC**: The Area Under the Receiver Operating Characteristic Curve, measuring the model’s ability to distinguish between the classes.
- **Precision**: The proportion of predicted positive cases that were actually positive.
- **Recall**: The proportion of actual positive cases that were correctly predicted.
- **F1-Score**: The harmonic mean of precision and recall, providing a balance between the two.

Below are the results for each model:

#### Logistic Regression
- **Test AUC-ROC**: 0.9202
- **Accuracy**: 0.8774
- **Precision**: 0.6525
- **Recall**: 0.6390
- **F1-Score**: 0.6457

#### K-Nearest Neighbors (KNN) 
- **Test AUC-ROC**: 0.8116
- **Accuracy**: 0.8221
- **Precision**: 0.4906
- **Recall**: 0.4727
- **F1-Score**: 0.4815

#### Random Forest Classifier 
- **Test AUC-ROC**: 0.9148
- **Accuracy**: 0.8702
- **Precision**: 0.6827
- **Recall**: 0.4805
- **F1-Score**: 0.5640

#### Decision Tree Classifier
- **Test AUC-ROC**: 0.8799
- **Accuracy**: 0.8797
- **Precision**: 0.6471
- **Recall**: 0.6857
- **F1-Score**: 0.6658

---

### Visualization

To visually assess the performance of the models, ROC curves and Precision-Recall curves were generated. These curves show the trade-offs between true positive rates and false positive rates, as well as precision and recall across different thresholds. The visualizations help in comparing the performance of different models and identifying the best-performing model based on the area under the curve (AUC).

---

### Model Saving

Once evaluated, each trained model was saved for future use. This allows us to deploy the models and make predictions on new race data as it becomes available, ensuring that the predictions can be made without retraining the models from scratch.
