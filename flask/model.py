import seaborn as sns
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn import metrics
import numpy as np
import joblib
import csv
diabetes_df = pd.read_csv('C:/Users/archi/Desktop/model test/input_testing/flask/diabetes.csv')
diabetes_df_copy = diabetes_df.copy(deep=True)
columns_to_replace = ['Glucose', 'BloodPressure', 'SkinThickness', 'Insulin', 'BMI']
diabetes_df_copy[columns_to_replace] = diabetes_df_copy[columns_to_replace].replace(0, np.NaN)
diabetes_df_copy['Glucose'].fillna(diabetes_df_copy['Glucose'].mean(), inplace=True)
diabetes_df_copy['BloodPressure'].fillna(diabetes_df_copy['BloodPressure'].mean(), inplace=True)
diabetes_df_copy['SkinThickness'].fillna(diabetes_df_copy['SkinThickness'].median(), inplace=True)
diabetes_df_copy['Insulin'].fillna(diabetes_df_copy['Insulin'].median(), inplace=True)
diabetes_df_copy['BMI'].fillna(diabetes_df_copy['BMI'].median(), inplace=True)
X = diabetes_df_copy.drop(["Outcome"], axis=1)
y = diabetes_df_copy['Outcome']
clf = DecisionTreeClassifier()
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=101)
clf.fit(X_train, y_train)
joblib.dump(clf, "C:/Users/archi/Desktop/model test/input_testing/flask/model.joblib")