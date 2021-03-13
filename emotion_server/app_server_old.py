from flask import Flask, jsonify, request
from flask_cors import CORS
from sklearn import cluster
from mts.core.mtserie_dataset import MTSerieDataset
from models.emotion_dataset_controller import *

import json
import numpy as np
from flask import jsonify

app = Flask(__name__)
CORS(app)


dataController =  EmotionDatasetController()


# ! deprecated


# @app.route("/getIds", methods=['POST'])
# def getIds():
#   return jsonify(dataController.getIds())

# @app.route("/calculateBounds", methods=['POST'])
# def calculateBounds():
#   dataController.calculateValuesBounds()
#   return "success"

# @app.route("/getBounds", methods=['POST'])
# def getBounds():
#   return jsonify(dataController.getValuesBounds())

# @app.route("/setBounds", methods=['POST'])
# def setBounds():
#   minVal = float(request.form.get('min'))
#   maxVal = float(request.form.get('max'))
#   dataController.setValuesBounds(minVal, maxVal)
#   return "succes"

# @app.route("/getInstanceLength", methods=['POST'])
# def getInstanceLength():
#   return jsonify(dataController.getInstanceLength())

# @app.route("/getTimeLength", methods=['POST'])
# def getTimeLength():
#   return jsonify(dataController.getTimeLength())

# @app.route("/getDimensionsLabels", methods=['POST'])
# def getDimensionsLabels():
#   return jsonify(dataController.getVariablesNames())

# @app.route("/getValuesInRange", methods=['POST'])
# def getValuesInRange():
#   begin = int(request.form.get('begin'))
#   end = int(request.form.get('end'))
#   return dataController.queryAllInRange(begin, end)


# @app.route("/getAllMetadata", methods=['POST'])
# def getAllMetadata():
#   return jsonify(dataController.dataset.getAllMetadata())

# @app.route("/getNumericalLabels", methods=['POST'])
# def getNumericalLabels():
#   print(dataController.getNumericalLabels())
#   return jsonify(dataController.getNumericalLabels())

# @app.route("/getCategoricalLabels", methods=['POST'])
# def getCategoricalLabels():
#   print(dataController.getCategoricalLabels())
#   return (dataController.getCategoricalLabels())


# @app.route("/setEmotionAlphas", methods=['POST'])
# def setEmotionAlphas():
#   alphas = json.loads(request.form.get('alphas'))
#   dataController.alphas = np.array(alphas)
#   return "success"

@app.route("/openEml", methods=['POST'])
def openEml():
  eml = request.form.get('eml')
  id = dataController.addEml(eml)
  return id

@app.route("/initialize", methods=['POST'])
def initialize():
  global dataController
  dataController =  EmotionDatasetController()
  return "success"

@app.route("/getMTSeriesInRange", methods=['POST'])
def getMTSeriesInRange():
  begin = int(request.form.get('begin'))
  end = int(request.form.get('end'))
  return jsonify(dataController.queryAllInRange(begin, end))

@app.route("/getMDS", methods=['POST'])
def getMDS():
  labels = json.loads(request.form.get('labels'))
  return jsonify(dataController.mdsProjection(variables=labels))

@app.route("/getSubsetsDimensionsRankings", methods=['POST'])
def getSubsetsDimensionsRankings():
  blueCluster = json.loads(request.form.get('blueCluster'))
  redCluster = json.loads(request.form.get('redCluster'))
  print(dataController.getSubsetsDimensionsRankings(blueCluster, redCluster))
  print(jsonify(dataController.getSubsetsDimensionsRankings(blueCluster, redCluster)))
  return jsonify(dataController.getSubsetsDimensionsRankings(blueCluster, redCluster))

@app.route("/removeVariables", methods=['POST'])
def removeVariables():
  names = json.loads(request.form.get('names'))
  dataController.removeVariables(names)
  return "success"

@app.route("/computeDataInfo", methods=['POST'])
def computeDataInfo():
  dataController.computeDataInfo()
  return jsonify(dataController.dataInfo)

@app.route("/downsampleData", methods=['POST'])
def downsampleData():
  rule = json.loads(request.form.get('rule'))
  print(rule)
  dataController.downsampleData(rule)
  print(dataController.dataset.timeLen)
  return "success"

@app.route("/doClustering", methods=['POST'])
def doClustering():
  k = json.loads(request.form.get('k'))
  clusters= dataController.doClustering(k)
  return jsonify(clusters)

@app.route("/setSettings", methods=['POST'])
def setSettings():
  settings = {SETTINGS_ALPHAS:json.loads(request.form.get(SETTINGS_ALPHAS)),
              SETTINGS_EMOTIONS_LABELS:json.loads(request.form.get(SETTINGS_EMOTIONS_LABELS)),
              SETTINGS_LOWER_BOUNDS:json.loads(request.form.get(SETTINGS_LOWER_BOUNDS)),
              SETTINGS_UPPER_BOUNDS:json.loads(request.form.get(SETTINGS_UPPER_BOUNDS)),
              # "startPosition":json.loads(request.form.get('startPosition')),
              # "windowSize":json.loads(request.form.get('windowSize')),
              }
  dataController.setSettings(settings=settings)
  return "success"
if __name__ == "__main__":
  app.run()