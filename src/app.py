from flask import Flask, jsonify, request
from flasgger import Swagger
from flask_cors import CORS
from lib_ml_team11 import Preprocessing 
import numpy as np
import urllib.request
from keras.models import load_model
import os
import pickle

app = Flask(__name__)
swagger = Swagger(app)
CORS(app)

preprocessing = Preprocessing()
# MODEL_CLOUD = os.environ.get('MODEL_CLOUD')
MODEL_CLOUD = 'https://drive.google.com/uc?export=download&id=1V24-vhxGFixcUp8sVpOAVSUsYmxJFMWF'
TOKENIZER_CLOUD = 'https://drive.google.com/uc?export=download&id=1LYSJ6RgO4xQCNvwnm3sKN6m2NmzUp2jO'

def load_pkl(url):
    path, _ = urllib.request.urlretrieve(url)
    with open(path, 'rb') as f:
        return pickle.load(f)

def load_keras(url):
    models_path = 'models'
    file_name = 'model.keras'
    save_path = os.path.join(models_path, file_name)
    if not os.path.exists(models_path):
        os.makedirs(models_path)


    urllib.request.urlretrieve(url, save_path)
    return load_model(save_path)

model = load_keras(MODEL_CLOUD)
tokenizer = load_pkl(TOKENIZER_CLOUD)
      
@app.route('/predict', methods=['POST'])
def predict():
    try:
        preprocessing.set_tokenizer(tokenizer)
        data = preprocessing.transform_input(request.get_json()['url'], 200)
        data = data.reshape(-1, 1)
        # prediction = (model.predict(data)).astype(float)
        # prediction_binary = (np.array(prediction) > 0.5).astype(int)
        # print(prediction, prediction_binary)
        # return jsonify({'prediction': prediction, 
        # 'prediction_binary': prediction_binary}), 200
        return jsonify({'prediction': 'phishing'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
    

if __name__ == '__main__':
    app.run(debug=True)
