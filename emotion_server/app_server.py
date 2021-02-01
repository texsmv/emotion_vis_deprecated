from flask import Flask, jsonify, request
from flask_cors import CORS
from utils.utils import time_serie_from_eml_string
from mts.classes.time_series_dataset import TimeSeriesDataset
from models.emotion_dataset_controller import EmotionDatasetController
import json
import numpy as np
from flask import jsonify

app = Flask(__name__)
CORS(app)

dataController =  EmotionDatasetController()


@app.route("/openEml", methods=['POST'])
def openEml():
  eml = request.form.get('eml')
  isCategorical = request.form.get('isCategorical') == 'True'
  id = dataController.addEml(eml, isCategorical=isCategorical)
  return id

@app.route("/initialize", methods=['POST'])
def initialize():
  global dataController
  dataController =  EmotionDatasetController()
  return "success"

@app.route("/getIds", methods=['POST'])
def getIds():
  return jsonify(dataController.getIds())

@app.route("/calculateBounds", methods=['POST'])
def calculateBounds():
  dataController.calculateValuesBounds()
  return "success"

@app.route("/getBounds", methods=['POST'])
def getBounds():
  return jsonify(dataController.getValuesBounds())

@app.route("/setBounds", methods=['POST'])
def setBounds():
  minVal = float(request.form.get('min'))
  maxVal = float(request.form.get('max'))
  dataController.setValuesBounds(minVal, maxVal)
  return "succes"

@app.route("/getInstanceLength", methods=['POST'])
def getInstanceLength():
  return jsonify(dataController.getInstanceLength())

@app.route("/getTimeLength", methods=['POST'])
def getTimeLength():
  return jsonify(dataController.getTimeLength())

@app.route("/getDimensionsLabels", methods=['POST'])
def getDimensionsLabels():
  return jsonify(dataController.getVariablesNames())

@app.route("/getValuesInRange", methods=['POST'])
def getValuesInRange():
  begin = int(request.form.get('begin'))
  end = int(request.form.get('end'))
  return dataController.queryAllInRange(begin, end)

@app.route("/getAllMetadata", methods=['POST'])
def getAllMetadata():
  return jsonify(dataController.dataset.getAllMetadata())

@app.route("/getNumericalLabels", methods=['POST'])
def getNumericalLabels():
  print(dataController.getNumericalLabels())
  return jsonify(dataController.getNumericalLabels())

@app.route("/getCategoricalLabels", methods=['POST'])
def getCategoricalLabels():
  print(dataController.getCategoricalLabels())
  return jsonify(dataController.getCategoricalLabels())


@app.route("/getMDS", methods=['POST'])
def getMDS():
  return dataController.mdsProjection()

@app.route("/getSubsetsDimensionsRankings", methods=['POST'])
def getSubsetsDimensionsRankings():
  blueCluster = json.loads(request.form.get('blueCluster'))
  redCluster = json.loads(request.form.get('redCluster'))
  print(dataController.getSubsetsDimensionsRankings(blueCluster, redCluster))
  print(jsonify(dataController.getSubsetsDimensionsRankings(blueCluster, redCluster)))
  return jsonify(dataController.getSubsetsDimensionsRankings(blueCluster, redCluster))

@app.route("/setEmotionAlphas", methods=['POST'])
def setEmotionAlphas():
  alphas = json.loads(request.form.get('alphas'))
  dataController.alphas = np.array(alphas)
  return "success"

@app.route("/setCategoricalAlphas", methods=['POST'])
def setCategoricalAlphas():
  alphas = json.loads(request.form.get('alphas'))
  dataController.categoricalAlphas = np.array(alphas)
  return "success"

@app.route("/setNumericalAlphas", methods=['POST'])
def setNumericalAlphas():
  alphas = json.loads(request.form.get('alphas'))
  dataController.numericalAlphas = np.array(alphas)
  return "success"

@app.route("/removeVariables", methods=['POST'])
def removeVariables():
  names = json.loads(request.form.get('names'))
  dataController.removeVariables(names)
  return "success"


if __name__ == "__main__":
  app.run()