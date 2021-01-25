from flask import Flask, jsonify, request
from flask_cors import CORS
import json

from matplotlib.pyplot import ylim
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import manifold
from matplotlib import pyplot
from pandas import DataFrame


# engaging = pd.read_csv('engaging.csv', sep=',',header=None).values
# familiarity = pd.read_csv('familiarity.csv', sep=',',header=None).values
# valence = pd.read_csv('valence.csv', sep=',',header=None).values
# arousal = pd.read_csv('arousal.csv', sep=',',header=None).values
# liking = pd.read_csv('liking.csv', sep=',',header=None).values


# X = np.stack([valence,arousal, engaging, familiarity, liking], axis=2)
# # [58, 36, 5] => [Npersons, Nvideos, Ndimensions]
# X = X.transpose(0, 2, 1)

# N, K, T = X.shape

# def distance_k(x_1, x_2, k):
#     return np.power(x_1[k] - x_2[k], 2).sum()

# D_valence = np.zeros([N, N])
# D_arousal = np.zeros([N, N])
# D_engaging = np.zeros([N, N])
# D_familiarity = np.zeros([N, N])
# D_liking = np.zeros([N, N])


# D = np.zeros([N, N])

# for i in range(N):
#     for j in range(N):
#         D_valence[i][j] = distance_k(X[i], X[j], 0)
#         D_arousal[i][j] = distance_k(X[i], X[j], 1)
#         D_engaging[i][j] = distance_k(X[i], X[j], 2)
#         D_familiarity[i][j] = distance_k(X[i], X[j], 3)
#         D_liking[i][j] = distance_k(X[i], X[j], 4)
        
# D = np.stack([np.power(D_valence,2), np.power(D_arousal,2), np.power(D_engaging,2), np.power(D_familiarity,2), np.power(D_liking,2)], axis=2)
# D = np.sum(D, axis=2)
# D = np.power(D, 1/2)


app = Flask(__name__)
CORS(app)

@app.route("/", methods=[ 'POST' ] )
def hello():
    D = []
    for key, value in request.form.items():
        if(key == 'D'): 
            D = np.matrix(value)
        print(key)
        print(value)
    mds = manifold.MDS(n_components=2, dissimilarity="precomputed", random_state=6)
    results = mds.fit(D)
    coords = results.embedding_
    
    print(coords.shape)
    print(coords.flatten().shape)
    # print(json.]())
    print(jsonify(coords.flatten().tolist()))
    print(coords)
    
    coordsResponse = jsonify(coords.flatten().tolist())
    return coordsResponse
    # print(json.loads(coordsResponse))

    json_file = {}
    json_file['query'] = 'hello_world' + str(coords.shape[0])
    response = jsonify(json_file)
    # Enable Access-Control-Allow-Origin
    # response.headers.add("Access-Control-Allow-Origin", "*")
    return response

if __name__ == "__main__":
  app.run()