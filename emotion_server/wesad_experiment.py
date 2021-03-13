import json
import numpy as np
from numpy.lib.utils import info
from scipy.sparse import data
from mts.core.mtserie import MTSerie
from mts.core.mtserie_dataset import DistanceType, MTSerieDataset
from random import seed
from dateutil import parser
import matplotlib.pyplot as plt
seed(1)



def mtserie_from_json(jsonString):
    data = json.loads(jsonString)
    variablesNames = data["vocabulary"]
    identifiers = data["info"]["identifiers"]
    
    categoricalDict = data["info"].get("categoricalMetadata", {})
    numericalDict = data["info"].get("numericalMetadata", {})
    dateTimesStr = data.get("dates", [])
    dateTimes = [ parser.parse(e) for e in dateTimesStr]
    dateTimes = np.array(dateTimes)

    
    variablesDataDict = {} 
    for variable in variablesNames:
        variablesDataDict[variable] = np.array(data[variable])
    
    mtserie = MTSerie.fromDict(X=variablesDataDict, index=dateTimes, 
                               info= identifiers, numericalFeatures=numericalDict,
                               categoricalFeatures=categoricalDict)
    return mtserie
    

dataset =  MTSerieDataset()
assert isinstance(dataset, MTSerieDataset)

PATH = "datasets/WESAD/"
for i in range(2, 18):
    if i != 12:
        with open(PATH + 's{}.json'.format(str(i)), 'r') as file:
            jsonStr = file.read()
            mtserie = mtserie_from_json(jsonStr)
            dataset.add(mtserie, identifier= mtserie.info["id"])




dataset.compute_distance_matrix(variables=["Valence", "Arousal"], distanceType=DistanceType.DTW)
# dataset.compute_distance_matrix(variables=["PANAS-Active", "PANAS-Distressed"])
# dataset.compute_distance_matrix()
dataset.compute_projection()
dataset.cluster_projections(4)
labels = np.array([dataset._clusterById[id] for id in dataset.ids])
# print(labels)
# print(type(labels))


# for i in range(len(labels)):
#     dataset.get_mtserie(dataset.ids[i]).plot()
#     plt.savefig("us_plots/cluter:{} id:{}".format(labels[i], dataset.ids[i]))
#     plt.close()

print(labels)

print(dataset.minTemporalValues)
print(dataset.maxTemporalValues)

# coords = np.array(list(dataset._projections.values())) 
# plt.subplots_adjust(bottom = 0.1)
# plt.scatter(
#     coords[:, 0], coords[:, 1], marker = 'o', c= labels
#     )

# for label, x, y in zip(np.arange(coords.shape[0]), coords[:, 0], coords[:, 1]):
#     plt.annotate(
#         str(label),
#         xy = (x, y), xytext = (-20, 20),
#         textcoords = 'offset points', ha = 'right', va = 'bottom',
#         bbox = dict(boxstyle = 'round,pad=0.5', fc = 'yellow', alpha = 0.5),
#         arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))
# plt.show()
