from flask import Flask, jsonify
from lib_ml_team11 import Preprocessing 
import numpy as np
import requests
import os

app = Flask(__name__)
preprocessing = Preprocessing()
MODEL_OUTPUT_FILEPATH = 'models/model.pkl'
MODEL_CLOUD = os.environ.get('MODEL_CLOUD')


def load_model(url, destination):
    response = requests.get(url, stream=True)
    with open(destination, "wb") as f:
        for chunk in response.iter_content(chunk_size=1024):
            if chunk:
                f.write(chunk)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Load the model
        model = load_model(MODEL_CLOUD, MODEL_OUTPUT_FILEPATH)
        
        data = preprocessing.transform_input(request.url, 200)

        prediction = (model.predict(data, batch_size=1000)).astype(float)
        prediction_binary = (np.array(prediction) > 0.5).astype(int)
        
        return jsonify({'prediction': prediction, 'prediction_binary': prediction_binary}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500