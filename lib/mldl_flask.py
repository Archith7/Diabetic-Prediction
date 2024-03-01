# from flask import Flask, request, jsonify
# import pandas as pd
# from sklearn.preprocessing import LabelEncoder
# import joblib
# import cv2
# import numpy as np
# # from tensorflow.keras.models import load_model

# app = Flask(__name__)

# # Load the trained models for Flask app1
# clf = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/model.joblib')
# clf_rfc = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/diabetes_model_rfc.joblib')
# clf_xgb = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/diabetes_model_xgb.joblib')
# clf_svm = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/diabetes_model_svm.joblib')

# # Load your deep learning model for Flask app2
# loaded_model = joblib.load('C:/Users/archi/Desktop/diabetic app final/model.joblib')

# # Define models dictionary for Flask app1
# models = {
#     'Decision Tree': clf,
#     'Random Forest': clf_rfc,
#     'XGBoost': clf_xgb,
#     'SVM': clf_svm,
# }

# @app.route('/predict_diabetes', methods=['POST'])
# def predict_diabetes():
#     try:
#         print("Received request for /predict_diabetes")
#         data = request.get_json(force=True)

#         # Access input values from data dictionary
#         pregnancies = data['Pregnancies']
#         glucose = data['Glucose']
#         blood_pressure = data['BloodPressure']
#         skin_thickness = data['SkinThickness']
#         insulin = data['Insulin']
#         bmi = data['BMI']
#         diabetes_pedigree_function = data['DiabetesPedigreeFunction']
#         age = data['Age']
#         selected_models = data['SelectedModels']

#         # Build DataFrame with a single row
#         user_input_df = pd.DataFrame({
#             'Pregnancies': [pregnancies],
#             'Glucose': [glucose],
#             'BloodPressure': [blood_pressure],
#             'SkinThickness': [skin_thickness],
#             'Insulin': [insulin],
#             'BMI': [bmi],
#             'DiabetesPedigreeFunction': [diabetes_pedigree_function],
#             'Age': [age],
#         })

#         # Initialize an empty dictionary to store predictions
#         predictions_dict = {}

#         # Iterate through selected models and make predictions
#         for model_name in selected_models:
#             model = models[model_name]
#             predictions = make_prediction(model, user_input_df, model_name)
#             predictions_dict[model_name] = predictions

#         # Return all predictions in JSON response
#         return jsonify({predictions_dict})

#     except Exception as e:
#         print(f"Error: {str(e)}")
#         return jsonify({'error': str(e)})

# @app.route('/predict', methods=['POST'])
# def predict():
#     try:
#         print("Received request for /predict")
#         # Get the uploaded image from the request
#         image = request.files['image']

#         # Read and preprocess the image for deep learning prediction
#         img = cv2.imdecode(np.frombuffer(image.read(), np.uint8), cv2.IMREAD_UNCHANGED)
#         img = cv2.resize(img, (640, 480))
#         img_array = np.array([img])

#         # Make the prediction
#         prediction = loaded_model.predict(img_array)
#         predicted_label = np.argmax(prediction, axis=1)

#         # Return the prediction result as JSON
#         if predicted_label == 0:
#             result = {'Non-Diabetic'}
#         else:
#             result = {'Diabetic'}

#         return jsonify(result)

#     except Exception as e:
#         print(f"Error: {str(e)}")
#         return jsonify({'error': str(e)})

# def make_prediction(model, user_input_df, model_name):
#     try:
#         # Convert categorical features using LabelEncoder for Decision Tree
#         if model_name == 'Decision Tree':
#             label_encoder = LabelEncoder()
#             categorical_columns = user_input_df.select_dtypes(include=['object']).columns
#             for col in categorical_columns:
#                 user_input_df[col] = label_encoder.fit_transform(user_input_df[col])

#         # Ensure the input data is a 2D array
#         user_input_reshaped = user_input_df.to_numpy().reshape(1, -1)

#         # Make predictions using the specified model
#         predictions = model.predict(user_input_reshaped)

#         # Return outcome messages based on the prediction
#         return 'Diabetic' if predictions[0] == 1 else 'Non-Diabetic'

#     except Exception as e:
#         print(f"Error in make_prediction: {str(e)}")
#         return 'Error in make_prediction'

# if __name__ == '__main__':
#     app.run(host='0.0.0.0', port=5000)


from flask import Flask, request, jsonify
import pandas as pd
from sklearn.preprocessing import LabelEncoder
import joblib
import cv2
import numpy as np
from tensorflow.keras.models import load_model

app = Flask(__name__)

# Load the trained models for Flask app1
clf = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/model.joblib')
clf_rfc = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/diabetes_model_rfc.joblib')
clf_xgb = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/diabetes_model_xgb.joblib')
clf_svm = joblib.load('C:/Users/archi/Desktop/diabetic app final/ironman/flask/diabetes_model_svm.joblib')

# Define models dictionary for Flask app1
models = {
    'Decision Tree': clf,
    'Random Forest': clf_rfc,
    'XGBoost': clf_xgb,
    'SVM': clf_svm,
}

# Load your deep learning model for Flask app2
loaded_model = load_model('C:/Users/archi/Desktop/diabetic app final/ironman/lib/trained_model_003.h5')

@app.route('/predict_diabetes', methods=['GET', 'POST'])
def predict_diabetes():
    try:
        data = request.get_json(force=True)

        # Access input values from data dictionary
        pregnancies = data['Pregnancies']
        glucose = data['Glucose']
        blood_pressure = data['BloodPressure']
        skin_thickness = data['SkinThickness']
        insulin = data['Insulin']
        bmi = data['BMI']
        diabetes_pedigree_function = data['DiabetesPedigreeFunction']
        age = data['Age']
        selected_models = data['SelectedModels']

        # Build DataFrame with a single row
        user_input_df = pd.DataFrame({
            'Pregnancies': [pregnancies],
            'Glucose': [glucose],
            'BloodPressure': [blood_pressure],
            'SkinThickness': [skin_thickness],
            'Insulin': [insulin],
            'BMI': [bmi],
            'DiabetesPedigreeFunction': [diabetes_pedigree_function],
            'Age': [age],
        })

        # Initialize an empty dictionary to store predictions
        predictions_dict = {}

        # Iterate through selected models and make predictions
        for model_name in selected_models:
            model = models[model_name]
            predictions = make_prediction(model, user_input_df, model_name)
            predictions_dict[model_name] = predictions

        # Return all predictions in JSON response
        return jsonify({'predictions': predictions_dict})

    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({'error': str(e)})


@app.route('/predict', methods=['GET', 'POST'])
def predict():
    try:
        # Get the uploaded image from the request
        image = request.files['image']

        # Read and preprocess the image for deep learning prediction
        img = cv2.imdecode(np.frombuffer(image.read(), np.uint8), cv2.IMREAD_UNCHANGED)
        img = cv2.resize(img, (640, 480))
        img_array = np.array([img])

        # Make the prediction
        prediction = loaded_model.predict(img_array)
        predicted_label = np.argmax(prediction, axis=1)

        # Return the prediction result as JSON
        if predicted_label == 0:
            result = {'prediction': 'No Diabetes'}
        else:
            result = {'prediction': 'Diabetes'}

        return jsonify(result)

    except Exception as e:
        print(f"Error in prediction: {str(e)}")
        return jsonify({'error': str(e)})


def make_prediction(model, user_input_df, model_name):
    try:
        # Convert categorical features using LabelEncoder for Decision Tree
        if model_name == 'Decision Tree':
            label_encoder = LabelEncoder()
            categorical_columns = user_input_df.select_dtypes(include=['object']).columns
            for col in categorical_columns:
                user_input_df[col] = label_encoder.fit_transform(user_input_df[col])

        # Ensure the input data is a 2D array
        user_input_reshaped = user_input_df.to_numpy().reshape(1, -1)

        # Make predictions using the specified model
        predictions = model.predict(user_input_reshaped)

        # Return outcome messages based on the prediction
        return 'Diabetic' if predictions[0] == 1 else 'Non-Diabetic'

    except Exception as e:
        print(f"Error in make_prediction: {str(e)}")
        return 'Error in make_prediction'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
