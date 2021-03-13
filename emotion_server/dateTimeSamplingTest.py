from mts.core.mtserie import MTSerie
from numpy.lib.arraysetops import isin
from utils.utils import time_serie_from_json, time_serie_from_eml_string

mtserie = None
with open('datasets/CASE_dataset/sub_1.json', 'r') as file:
    data = file.read()
    mtserie = time_serie_from_json(data)

assert isinstance(mtserie, MTSerie)

mtserieCopy = mtserie.clone()
resampledMtserie =  mtserie.resample("S")
