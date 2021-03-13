import numpy as np
import pandas as pd
from sktime.utils.load_data import from_long_to_nested
from models.time_serie import MultivariateTimeSerie
from models.time_series_dataset import MTSerieDataset
from utils.time_series_utils import distance_matrix, time_serie_from_eml
from dimensionality_reduction.mds import mts_mds
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

PATH = "datasets/ASCERTAIN/EMLs/"

files = [
"sub_00.xml",
"sub_01.xml",
"sub_02.xml",
"sub_03.xml",
"sub_04.xml",
"sub_05.xml",
"sub_06.xml",
"sub_07.xml",
"sub_08.xml",
"sub_09.xml",
"sub_10.xml",
"sub_11.xml",
"sub_12.xml",
"sub_13.xml",
"sub_14.xml",
"sub_15.xml",
"sub_16.xml",
"sub_17.xml",
"sub_18.xml",
"sub_19.xml",
"sub_20.xml",
"sub_21.xml",
"sub_22.xml",
"sub_23.xml",
"sub_24.xml",
"sub_25.xml",
"sub_26.xml",
"sub_27.xml",
"sub_28.xml",
"sub_29.xml",
"sub_30.xml",
"sub_31.xml",
"sub_32.xml",
"sub_33.xml",
"sub_34.xml",
"sub_35.xml",
"sub_36.xml",
"sub_37.xml",
"sub_38.xml",
"sub_39.xml",
"sub_40.xml",
"sub_41.xml",
"sub_42.xml",
"sub_43.xml",
"sub_44.xml",
"sub_45.xml",
"sub_46.xml",
"sub_47.xml",
"sub_48.xml",
"sub_49.xml",
"sub_50.xml",
"sub_51.xml",
"sub_52.xml",
"sub_53.xml",
"sub_54.xml",
"sub_55.xml",
"sub_56.xml",
"sub_57.xml",
]


dataset =  MTSerieDataset() 

for file in files:
    mtserie = time_serie_from_eml(PATH + file)
    dataset.add(mtserie, mtserie.getId())


X = dataset.getValues()

Mnum = dataset.getNumericalMetadataValues()

Mcat = dataset.getCategoricalMetadataValues()


alphas = np.ones(X.shape[1])
numAlphas = np.zeros(Mnum.shape[1])

print(X.shape)
X = X.reshape([58, -1])

X_embedded = TSNE(n_components=2).fit_transform(X)

coords = X_embedded


print(coords.shape)


plt.subplots_adjust(bottom = 0.1)
plt.scatter(
    coords[:, 0], coords[:, 1], marker = 'o'
    )
for label, x, y in zip(np.arange(coords.shape[0]), coords[:, 0], coords[:, 1]):
    plt.annotate(
        str(label),
        xy = (x, y), xytext = (-20, 20),
        textcoords = 'offset points', ha = 'right', va = 'bottom',
        bbox = dict(boxstyle = 'round,pad=0.5', fc = 'yellow', alpha = 0.5),
        arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))

plt.show()