##  Predicting Subscriber Churn with Machine Learning

This document outlines the process of creating a machine learning model to predict subscribers' churn in a subscription service.

**Objective:**

* Develop a model to predict users who will cancel their subscription before their 6th renewal (considered churners).
* Utilize data on user activity for the first 3 months to train the model.

**Methodology:**

* **Data Preprocessing:**
    * Extract relevant features from `sales.csv` and `user_activity.csv` datasets.
    * Combine data based on user ID, focusing on activity within the first 3 months.
    * Define churners as users with less than 7 orders of payment.
    * Split data into training and testing sets.
* **Model Development:**
    * Evaluate and choose suitable machine learning algorithms for classification.
    * Train the model on the training set, optimizing hyperparameters.
* **Evaluation:**
    * Evaluate model performance on the testing set using metrics like accuracy, sensitivity, specificity, precision, and recall.
    * Assess the model's effectiveness in predicting churn.


**Additional Analysis**

* Using the trained model to predict churn for users with known data but unknown churn status.
* Evaluation of the model's performance in this scenario.
