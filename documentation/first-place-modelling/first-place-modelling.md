# Formula 1 Modeling Process

This document outlines the steps taken during the modelling process for predicting first place finishes in Formula 1 races. The modelling process includes data preprocessing, feature engineering, model selection, evaluation, and visualization of results.

---

### Data Loading and Preprocessing

We begin by loading various datasets related to Formula 1, including constructors, drivers, races, and race results data. These datasets are merged using common keys such as `raceId`, `driverId`, and `constructorId` to create a consolidated dataframe.

The data is then cleaned by dropping irrelevant columns, handling missing values, and encoding categorical variables (such as circuitId, driverId, and constructorId) as dummy variables for model compatibility. This ensures that the data is in a usable format for machine learning models.

---

### Feature Engineering

A key part of the modelling process is feature engineering. Several new features are created to capture the performance trends for both drivers and constructors:

1. **First Place**: A new binary column indicating whether a driver finished in first place for a given race.
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

---

### Model Selection

Several machine learning models were selected for training and evaluation:

- **Logistic Regression**
- **K-Nearest Neighbors (KNN)**
- **Random Forest Classifier**
- **Decision Tree Classifier**
- **MLP Classifier**

---

### Hyperparameter Tuning
To enhance each model's performance, hyperparameter tuning was carried out using GridSearchCV. This approach enables the identification of the optimal parameter combinations that maximise the model's effectiveness based on a chosen metric, which in this case was the F1 Score.

For every model, a specific set of hyperparameters was defined, including key parameters such as regularisation strength for Logistic Regression, the number of neighbours for K-Nearest Neighbours, and the maximum depth and number of estimators for Random Forest and Decision Trees. GridSearchCV was employed to explore these hyperparameter grids systematically. Each combination of parameters was assessed by training and validating the model through 10-fold cross-validation, which helps mitigate the risk of overfitting.

### Model Evaluation

The performance of each model was evaluated using the following metrics:

- **Accuracy**: The percentage of correct predictions made by the model.
- **AUC-ROC**: The Area Under the Receiver Operating Characteristic Curve, measuring the model's ability to distinguish between the classes.
- **Precision**: The proportion of predicted positive cases that were actually positive.
- **Recall**: The proportion of actual positive cases that were correctly predicted.
- **F1-Score**: The harmonic mean of precision and recall, providing a balance between the two.

Below are the results for each model:

#### Logistic Regression
- **AUC-ROC**: Base: 0.9514 vs Hyperparameter tuning: 0.9493 (-0.22%)
- **Accuracy**: Base: 0.9477 vs Hyperparameter tuning: 0.9477 (+0.00%)
- **Precision**: Base: 0.6525 vs Hyperparameter tuning: 0.6579 (+0.83%)
- **Recall**: Base: 0.6525 vs Hyperparameter tuning: 0.6356 (-2.59%)
- **F1-Score**: Base: 0.6525 vs Hyperparameter tuning: 0.6466 (-0.90%)
#### K-Nearest Neighbors (KNN)
- **AUC-ROC**: Base: 0.8174 vs Hyperparameter tuning: 0.7782 (-4.80%)
- **Accuracy**: Base: 0.9324 vs Hyperparameter tuning: 0.9298 (-0.28%)
- **Precision**: Base: 0.5938 vs Hyperparameter tuning: 0.5541 (-6.69%)
- **Recall**: Base: 0.3220 vs Hyperparameter tuning: 0.3475 (+7.92%)
- **F1-Score**: Base: 0.4176 vs Hyperparameter tuning: 0.4271 (+2.27%)
#### Random Forest Classifier
- **AUC-ROC**: Base: 0.9458 vs Hyperparameter tuning: 0.9458 (+0.00%)
- **Accuracy**: Base: 0.9394 vs Hyperparameter tuning: 0.9394 (+0.00%)
- **Precision**: Base: 0.8485 vs Hyperparameter tuning: 0.8485 (+0.00%)
- **Recall**: Base: 0.2373 vs Hyperparameter tuning: 0.2373 (+0.00%)
- **F1-Score**: Base: 0.3709 vs Hyperparameter tuning: 0.3709 (+0.00%)
#### Decision Tree Classifier
- **AUC-ROC**: Base: 0.8174 vs Hyperparameter tuning: 0.7634 (-6.61%)
- **Accuracy**: Base: 0.9356 vs Hyperparameter tuning: 0.9222 (-1.43%)
- **Precision**: Base: 0.5842 vs Hyperparameter tuning: 0.4744 (-18.79%)
- **Recall**: Base: 0.5000 vs Hyperparameter tuning: 0.3136 (-37.28%)
- **F1-Score**: Base: 0.5388 vs Hyperparameter tuning: 0.3776 (-29.92%)
#### Stacked Logistic Regression/Random Forest Classifier
- **AUC-ROC**: Base: 0.9523 vs Hyperparameter tuning: 0.9523 (+0.00%)
- **Accuracy**: Base: 0.9509 vs Hyperparameter tuning: 0.9509 (+0.00%)
- **Precision**: Base: 0.6952 vs Hyperparameter tuning: 0.6952 (+0.00%)
- **Recall**: Base: 0.6186 vs Hyperparameter tuning: 0.6186 (+0.00%)
- **F1-Score**: Base: 0.6547 vs Hyperparameter tuning: 0.6547 (+0.00%)
#### MLP Classifier
- **AUC-ROC**: Base: 0.8263 vs Hyperparameter tuning: 0.8338 (+0.91%)
- **Accuracy**: Base: 0.9228 vs Hyperparameter tuning: 0.9235 (+0.08%)
- **Precision**: Base: 0.4615 vs Hyperparameter tuning: 0.4828 (+4.62%)
- **Recall**: Base: 0.1525 vs Hyperparameter tuning: 0.2373 (+55.61%)
- **F1-Score**: Base: 0.2293 vs Hyperparameter tuning: 0.3182 (+38.77%)


---

### Visualization

To visually assess the performance of the models, ROC curves and Precision-Recall curves as well as confusion matrices were generated for each model. The curve plots show the trade-offs between true positive rates and false positive rates, as well as precision and recall across different thresholds, while the confusion matrix shows the number of true positives, true negatives, false positives and false negatives for each model.

---

### Model Saving

Once evaluated, each trained model was saved for future use. This allows us to deploy the models and make predictions on new race data as it becomes available, ensuring that the predictions can be made without retraining the models from scratch.
