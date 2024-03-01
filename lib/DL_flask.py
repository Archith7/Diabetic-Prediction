
from flask import Flask, request, jsonify
import cv2
import numpy as np
from tensorflow.keras.models import load_model

app = Flask(__name__)

# Load your deep learning model
loaded_model = load_model('C:/Users/archi/Desktop/ironman/lib/trained_model_003.h5')
@app.route('/predict', methods=['GET','POST'])
def predict():
    # Get the uploaded image from the request
    image = request.files['image']

    # Read and preprocess the image for deep learning prediction
    # img = cv2.imdecode(np.fromstring(image.read(), np.uint8), cv2.IMREAD_UNCHANGED)
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

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)