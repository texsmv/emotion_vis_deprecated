import numpy as np
import sys
import json

sys.path.append("..")

from mts.classes.time_series_dataset import TimeSeriesDataset
from utils.utils import time_serie_from_eml_string
from mts.utils.time_series_utils import distance_matrix
from mts.utils.time_series_utils import mtserieQueryToJsonStr, subsetSeparationRanking
from mts.projection.mds import mts_mds

class EmotionDatasetController:
    def __init__(self):
        self.dataset =  TimeSeriesDataset()
        self.isCategorical = None
        self.minValue = None
        self.maxValue = None
        self.alphas = None
        self.oldCoords = None
        self.D_k = None
        super().__init__()
        
    def addEml(self, eml, isCategorical = True):
        if self.isCategorical is None:
            self.isCategorical = isCategorical
        else:
            assert self.isCategorical == isCategorical
            
        mtserie = time_serie_from_eml_string(eml, isCategorical= isCategorical)
        
        if self.alphas is None:
            self.alphas = np.ones(self.getVariablesNames())
        
        
        id = mtserie.metadata["id"]
        self.dataset.add(mtserie, id)
        return id
        
    def getIds(self):
        return self.dataset.ids()
    
    def removeVariables(self, names):
        for name in names:
            self.dataset.removeVariable(name)
        
    
    def calculateValuesBounds(self):
        X = self.dataset.getValues()
        assert isinstance(X, np.ndarray)
        self.minValue = X.min()
        self.maxValue = X.max()
        
    def getValuesBounds(self):
        if self.minValue != None and self.maxValue != None:
            return [self.minValue, self.maxValue]
        return [-1 ,-1]
    
    def setValuesBounds(self, minVal, maxVal):
        self.minValue = minVal
        self.maxValue = maxVal
    
    def getAllValuesInRange(self, begin, end):
        return self.dataset.queryAllByIndex(beginIndex=begin, endIndex=end, toList=True)
    
    def getTimeLength(self):
        return self.dataset.getTimeLength()
    
    def getInstanceLength(self):
        return self.dataset.getInstanceLength()
    
    def getVariablesNames(self):
        return self.dataset.getVariablesNames()
    
    def getNumericalLabels(self):
        return self.dataset.getNumericalLabels()

    def getCategoricalLabels(self):
        return self.dataset.getCategoricalLabels()
    
    def queryAllInRange(self, begin, end):
        return mtserieQueryToJsonStr(self.dataset.queryAllByIndex(begin, end, toList=True))
    
    def getSubsetsDimensionsRankings(self, blueCluster, redCluster):
        ids = self.getIds()
        
        blueIndexes = [ids.index(e) for e in blueCluster]
        redIndexes = [ids.index(e) for e in redCluster]
        
        j_s = subsetSeparationRanking(self.D_k, blueIndexes, redIndexes)
        print("Js")
        print(j_s)
        variablesRanks = {}
        vnames = self.getVariablesNames()
        for i in range(len(vnames)):
            variablesRanks[vnames[i]] = j_s[i]
        return variablesRanks
    
    def mdsProjection(self):
        X = self.dataset.getValues()
        alphas = self.alphas

        D, self.D_k = distance_matrix(X, alphas)
        self.D_k = np.power(self.D_k, 2)
        
        coords = mts_mds(D)
        
            
        if isinstance(self.oldCoords, np.ndarray): 
            P = coords
            Q = self.oldCoords
            A = P.transpose().dot(Q)
            u, s, vt = np.linalg.svd(A, full_matrices=True)
            v = vt.transpose()
            ut = u.transpose()
            r = np.sign(np.linalg.det(v.dot(ut)))
            R = v.dot(np.array([[1, 0], [0, r]])).dot(ut)

            print("sign: " + str(r))

            # print(u)
            # print(s)
            # print(vt)
            # print(r)
            # print(R)

            coords = R.dot(P.transpose()).transpose()
        
        coordsDict = {}
        ids = self.getIds()
        for i in range(len(ids)):
            id = ids[i]
            coord = coords[i]
            coordsDict[id] = coord.tolist()
        
        self.oldCoords = coords
        
        return json.dumps(coordsDict)