from models.time_serie import MultivariateTimeSerie
from models.time_series_dataset import TimeSeriesDataset
from sklearn import manifold

def mts_mds(D):
    mds = manifold.MDS(n_components=2, dissimilarity="precomputed", random_state=6)
    results = mds.fit(D)
    return results.embedding_ 