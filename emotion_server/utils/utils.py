import xml.etree.ElementTree as ET 
import sys
import datetime
import numpy as np
from tslearn.metrics import dtw
import json


sys.path.append("..")
from mts.classes.time_serie import MultivariateTimeSerie

def time_serie_from_eml(emotionMLPath, isCategorical = True):
    modelTypeName = ""
    if isCategorical:
        modelTypeName = "category"
    else:
        modelTypeName = "dimensional"
    
    tree = ET.parse(emotionMLPath)
    root = tree.getroot() 
    
    dimensions = []
    dimensionsDict = {}
    for dimension in root.find('vocabulary').findall('item'):
        name = dimension.get("name")
        dimensionsDict[name] = []
        dimensions.append(name)
        
    
    identifiersMetadata = []
    identifiersMetadataDict = {}
    for metadata in root.find('info').findall('identifier'):
        name = metadata.get("name")
        value = metadata.get("value")
        identifiersMetadata.append(name)
        identifiersMetadataDict[name] = value
    
    categoricalMetadata = []
    categoricalMetadataDict = {}
    
    for metadata in root.find('info').findall('categorical'):
        name = metadata.get("name")
        value = metadata.get("value")
        categoricalMetadata.append(name)
        categoricalMetadataDict[name] = value

    numericalMetadata = []
    numericalMetadataDict = {}
    
    
    for metadata in root.find('info').findall('numerical'):
        name = metadata.get("name")
        value = float(metadata.get("value"))
        numericalMetadata.append(name)
        numericalMetadataDict[name] = value
    
    
    
    for emotionItem in root.findall('emotion'):
        date = datetime.datetime.fromtimestamp(float(emotionItem.get("start"))/1000)
        for emotionDimention in emotionItem.findall(modelTypeName):
            value = float(emotionDimention.get("value"))
            name = emotionDimention.get("name")
            dimensionsDict[name] =  dimensionsDict[name] + [(value, date)]
    
    for name in dimensions:
        dimensionsDict[name].sort(key=lambda tup: tup[1])

    dateTimes = np.array(list(map(lambda e: e[1], dimensionsDict[dimensions[0]])))
    
    for name in dimensions:
        dimensionsDict[name] = np.array( list(map(lambda e: e[0], dimensionsDict[name])))
    
    
    numericalFeatures = [(k, v) for k, v in numericalMetadataDict.items()]
    numericalFeatures.sort()
    numericalFeatures = np.array([v for _, v in numericalFeatures])
    
    categoricalFeatures = [(k, v) for k, v in categoricalMetadataDict.items()]
    categoricalFeatures.sort()
    categoricalFeatures = np.array([v for _, v in categoricalFeatures])
    
    
    mtserie = MultivariateTimeSerie.fromDict(dimensionsDict, dates=dateTimes, numericalFeatures=numericalFeatures, categoricalFeatures=categoricalFeatures, metadata=identifiersMetadataDict, numericalLabels=numericalMetadata, categoricalLabels=categoricalMetadata)
    
    
    return mtserie


def time_serie_from_eml_string(emotionMLString, isCategorical = True):
    isAnyDateMissing = False
    modelTypeName = ""
    if isCategorical:
        modelTypeName = "category"
    else:
        modelTypeName = "dimensional"
    
    root = ET.fromstring(emotionMLString)
    
    dimensions = []
    dimensionsDict = {}
    for dimension in root.find('vocabulary').findall('item'):
        name = dimension.get("name")
        dimensionsDict[name] = []
        dimensions.append(name)
        
    
    identifiersMetadata = []
    identifiersMetadataDict = {}
    for metadata in root.find('info').findall('identifier'):
        name = metadata.get("name")
        value = metadata.get("value")
        identifiersMetadata.append(name)
        identifiersMetadataDict[name] = value
    print(identifiersMetadataDict)
    categoricalMetadata = []
    categoricalMetadataDict = {}
    
    for metadata in root.find('info').findall('categorical'):
        name = metadata.get("name")
        value = metadata.get("value")
        categoricalMetadata.append(name)
        categoricalMetadataDict[name] = value

    numericalMetadata = []
    numericalMetadataDict = {}
    
    
    for metadata in root.find('info').findall('numerical'):
        name = metadata.get("name")
        value = float(metadata.get("value"))
        numericalMetadata.append(name)
        numericalMetadataDict[name] = value
    
    
    
    for emotionItem in root.findall('emotion'):
        dateField = emotionItem.get("start")
        date = 0
        if dateField != None:
            date = datetime.datetime.fromtimestamp(float(emotionItem.get("start"))/1000)
            isAnyDateMissing = True
        
        for emotionDimention in emotionItem.getchildren():
            value = float(emotionDimention.get("value"))
            name = emotionDimention.get("name")
            if isAnyDateMissing:
                dimensionsDict[name] =  dimensionsDict[name] + [value]
            else:
                dimensionsDict[name] =  dimensionsDict[name] + [(value, date)]
    
    dateTimes = 0
    if not isAnyDateMissing:
        for name in dimensions:
            dimensionsDict[name].sort(key=lambda tup: tup[1])
        dateTimes = np.array(list(map(lambda e: e[1], dimensionsDict[dimensions[0]])))
    
    for name in dimensions:
        if not isAnyDateMissing:
            dimensionsDict[name] = np.array( list(map(lambda e: e[0], dimensionsDict[name])))
        else:
            dimensionsDict[name] = np.array(dimensionsDict[name])
    
    numericalFeatures = [(k, v) for k, v in numericalMetadataDict.items()]
    numericalFeatures.sort()
    numericalFeatures = np.array([v for _, v in numericalFeatures])
    
    categoricalFeatures = [(k, v) for k, v in categoricalMetadataDict.items()]
    categoricalFeatures.sort()
    categoricalFeatures = np.array([v for _, v in categoricalFeatures])
    
    mtserie = 0
    if not isAnyDateMissing:    
        mtserie =  MultivariateTimeSerie.fromDict(dimensionsDict, dates=dateTimes, numericalFeatures=numericalFeatures, categoricalFeatures=categoricalFeatures, metadata=identifiersMetadataDict, numericalLabels=numericalMetadata, categoricalLabels=categoricalMetadata)
    else:
        mtserie =  MultivariateTimeSerie.fromDict(dimensionsDict, numericalFeatures=numericalFeatures, categoricalFeatures=categoricalFeatures, metadata=identifiersMetadataDict, numericalLabels=numericalMetadata, categoricalLabels=categoricalMetadata)
    return mtserie

def distance_matrix(X, alphas, metadata = np.array([]), metadataAlphas = []):
    assert isinstance(X, np.ndarray)
    assert isinstance(metadata, np.ndarray)
    
    md = 0
    n, d, t = X.shape
    
    includeMetadata = False
    
    if len(metadata) != 0:
        includeMetadata = True
        md = metadata.shape[1]
        assert metadata.shape[0] == n
    
    D_k = np.zeros([d, n, n])
    
    for k in range(d):
        for i in range(n):
            for j in range(n):
                # D_k[k][i][j] = tserieDtwDistance(X[i][k], X[j][k])
                D_k[k][i][j] = tserieEuclideanDistance(X[i][k], X[j][k])
    
    for k in range(d):
        D_k[k] = np.power(D_k[k], 2) * (alphas[k] ** 2)
        
    D = np.sum(D_k, axis=0)
    
    
    
    
    MD_k = []
    MD = []
    if(includeMetadata):
        MD_k = np.zeros([md, n, n])
        for k in range(md):
            for i in range(n):
                for j in range(n):
                    MD_k[k][i][j] = euclideanDistance(metadata[i][k], metadata[j][k])
    
        for k in range(md):
            MD_k[k] = np.power(MD_k[k], 2) * (metadataAlphas[k] ** 2)
            
        MD = np.sum(MD_k, axis=0)
        
        D = D.__add__(MD)
    
    D = np.power(D, 1/2)
    
    return D
    
    
    
def tserieEuclideanDistance(x_1, x_2):
    # return (np.power(np.power(x_1 - x_2, 2).sum(), 1/2))
    return (np.power(np.power(x_1 - x_2, 2).sum(), 1/2)) / float(len(x_1))

def tserieDtwDistance(x_1, x_2):
    return dtw(x_1, x_2)


def euclideanDistance(m_1, m_2):
    return pow((m_1 - m_2) ** 2, 1/2.0)


def mtserieQueryToJsonStr(query):
    assert isinstance(query, dict)
    if isinstance(next(iter(query.values())), np.ndarray):
        newQuery = {}
        for id, series in query.items():
            newQuery[id] = series.tolist()
        return json.dumps(newQuery)
    return json.dumps(query)