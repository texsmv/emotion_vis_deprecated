from models.time_serie import TimeSerie
from utils.time_series_utils import mtserieQueryToJsonStr
import numpy as np



a = TimeSerie.fromNumpy([np.array([1,2,3]), np.array([3,4,5]), np.array([6,7,8])], dimensions = ["temp", "prec", "cold"])

assert isinstance(a, TimeSerie)

query = a.queryByIndex(0, 2, toList=True)

# with open("sample.json", "w") as outfile:  
#     json.dump(query, outfile) 

print(mtserieQueryToJsonStr(query))

# print(query)