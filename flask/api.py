from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

# Load the pre-trained model
model = joblib.load("C:/Users/archi/Desktop/model test/input_testing/flask/model.joblib")

# Define a route to handle the prediction request
@app.route('/predict', methods=['GET','POST'])
def predict():
    try:
        
        user_data = request.get_json()
        input_data = pd.DataFrame({
            'Glucose': [user_data['inputA']],
            'BloodPressure': [user_data['inputB']],
            'SkinThickness': [user_data['inputC']],
            'Insulin': [user_data['inputD']],
            'BMI': [user_data['inputE']],
            'DiabetesPedigreeFunction': [user_data['inputF']],
            'Age': [user_data['inputG']],
            'Pregnancies': [user_data['inputH']]
        })

        # Make prediction
        prediction = model.predict(input_data)

        # Return the prediction result
        return jsonify({"prediction": int(prediction[0])})

    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(debug=True)
