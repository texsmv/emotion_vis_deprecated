import json
from utils.utils import time_serie_from_json, time_serie_from_eml_string

PATH = "datasets/WESAD/"

for i in range(2, 18):
    if i != 12:
        name = 's{}.xml'.format(i)
        with open(PATH + name, 'r') as file:
            fileData = file.read()
            mtserie = time_serie_from_eml_string(fileData)
            data = {}
            with open(name[:-3] + "json", 'w') as jsonFile:
                data["vocabulary"] = mtserie.variablesNames
                catDict = {}
                for i in range(len(mtserie.categoricalLabels)):
                    catDict[mtserie.categoricalLabels[i]] = mtserie.categoricalFeatures[i]
                numDict = {}
                for i in range(len(mtserie.numericalLabels)):
                    numDict[mtserie.numericalLabels[i]] = mtserie.numericalFeatures[i]
                data["info"] = {
                    "identifiers": mtserie.metadata,
                    "categoricalMetadata": catDict,
                    "numericalMetadata": numDict
                }
                for varName in mtserie.variablesNames:
                    data[varName] = mtserie.getSerie(varName).tolist()
            # print(data)
                json.dump(data, jsonFile)
