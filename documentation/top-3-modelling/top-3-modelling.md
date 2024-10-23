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
2. **Driver Top 3 Finish Percentage Last Year**: The percentage of top 3 finishes for each driver in the previous year.
3. **Constructor Top 3 Finish Percentage Last Year**: The average top 3 finish percentage of the two drivers in each constructor from the previous year.
4. **Driver Avg Position Last Year**: The average race finishing position for each driver during the previous year.
5. **Constructor Avg Position Last Year**: The average finishing position for the constructor’s drivers during the previous year.
6. **Driver Win Percentage Last Year**: The driver's win percentage for all races during the previous year.
7. **Constructor Win Percentage Last Year**: The constructor's win percentage for all reaces during the previous year.
8. **Driver Win Percentage Current Year**: The driver's win percentage for all races during the current year.
9. **Constructor Win Percentage Current Year**: The constructor's win percentage for all races during the current year.

Additional features such as the **Driver Average Position Current Year** and the **Constructor Average Position Current Year** are also calculated to capture race-by-race performance for the current year.

---

### Splitting the Data

- **Training Set**: Data from races between 1983 and 2009.
- **Validation Set**: Data from races between 2010 and 2017.
- **Test Set**: Data from races between 2018 and 2024.

These splits make sure that the models are trained on older data, validated on recent data, and evaluated on the most recent race seasons.

---

### Model Selection

Several machine learning models were selected for training and evaluation:

- **Logistic Regression**
- **K-Nearest Neighbors (KNN)**
- **Random Forest Classifier**
- **Decision Tree Classifier**

---

### Hyperparameter Tuning
To further improve the performance of each model, hyperparameter tuning was performed using GridSearchCV. Hyperparameter tuning allows us to search for the best combination of parameters that optimizes the model's performance based on a specified metric, in this case, F1 Score.

For each model, a grid of hyperparameters was defined. These grids included ranges of values for key parameters such as the regularization strength in Logistic Regression, the number of neighbours in K-Nearest Neighbours, and the maximum depth and number of estimators in Random Forest and Decision Trees. We used GridSearchCV to perform a search over the hyperparameter grids. For each combination of hyperparameters, the model was trained and evaluated using 10-fold cross-validation to prevent overfitting.

### Model Evaluation

The performance of each model was evaluated using the following metrics:

- **Accuracy**: The percentage of correct predictions made by the model.
- **AUC-ROC**: The Area Under the Receiver Operating Characteristic Curve, measuring the model’s ability to distinguish between the classes.
- **Precision**: The proportion of predicted positive cases that were actually positive.
- **Recall**: The proportion of actual positive cases that were correctly predicted.
- **F1-Score**: The harmonic mean of precision and recall, providing a balance between the two.

Below are the results for each model:

#### Logistic Regression
- **AUC-ROC**: Base: 0.9202 vs Hyperparameter tuning: 0.9205 (+0.03%)
- **Accuracy**: Base: 0.8774 vs Hyperparameter tuning: 0.8610 (-1.87%)
- **Precision**: Base: 0.6525 vs Hyperparameter tuning: 0.7627 (+16.89%)
- **Recall**: Base: 0.6390 vs Hyperparameter tuning: 0.5263 (-17.64%)
- **F1-Score:**: Base: 0.6457 vs Hyperparameter tuning: 0.6228 (+3.55%)
#### K-Nearest Neighbors (KNN)
- **AUC-ROC**: Base: 0.8116 vs Hyperparameter tuning: 0.8645 (+6.52%)
- **Accuracy**: Base: 0.8221 vs Hyperparameter tuning: 0.8476 (+3.10%)
- **Precision**: Base: 0.4906 vs Hyperparameter tuning: 0.6656 (+35.66%)
- **Recall**: Base: 0.4727 vs Hyperparameter tuning: 0.6053 (+28.04%)
- **F1-Score:**: Base: 0.4815 vs Hyperparameter tuning: 0.6340 (+31.69%)
#### Random Forest Classifier
- **AUC-ROC**: Base: 0.9148 vs Hyperparameter tuning: 0.9188 (+0.44%)
- **Accuracy**: Base: 0.8702 vs Hyperparameter tuning: 0.8635 (-0.77%)
- **Precision**: Base: 0.6827 vs Hyperparameter tuning: 0.8441 (+23.64%)
- **Recall**: Base: 0.4805 vs Hyperparameter tuning: 0.4591 (-4.45%)
- **F1-Score**: Base: 0.5640 vs Hyperparameter tuning: 0.5947 (+5.45%)
#### Decision Tree Classifier
- **AUC-ROC**: Base: 0.8799 vs Hyperparameter tuning: 0.9081 (+3.21%)
- **Accuracy**: Base: 0.8797 vs Hyperparameter tuning: 0.8603 (-2.20%)
- **Precision**: Base: 0.6471 vs Hyperparameter tuning: 0.8596 (+32.84%)
- **Recall**: Base: 0.6857 vs Hyperparameter tuning: 0.4298 (-37.34%)
- **F1-Score**: Base: 0.6658 vs Hyperparameter tuning: 0.5731 (-13.93%)
#### Stacked Logistic Regression/Random Forest Classifier
- **AUC-ROC**: Base: 0.9125 vs Hyperparameter tuning: 0.9147 (+0.24%)
- **Accuracy**: Base: 0.8797 vs Hyperparameter tuning: 0.8546 (-2.86%)
- **Precision**: Base: 0.6604 vs Hyperparameter tuning: 0.7280 (+10.23%)
- **Recall**: Base: 0.6416 vs Hyperparameter tuning: 0.5322 (-17.06%)
- **F1-Score**: Base: 0.6509 vs Hyperparameter tuning: 0.6149 (-5.53%)

---

### Visualization

To visually assess the performance of the models, ROC curves and Precision-Recall curves as well as confusion matrices were generated for each model. The curve plots show the trade-offs between true positive rates and false positive rates, as well as precision and recall across different thresholds, while the confusion matrix shows the number of true positives, true negatives, false positives and false negatives for each model.

---

### Model Saving

Once evaluated, each trained model was saved for future use. This allows us to deploy the models and make predictions on new race data as it becomes available, ensuring that the predictions can be made without retraining the models from scratch.
