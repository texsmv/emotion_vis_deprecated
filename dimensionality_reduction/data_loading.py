from matplotlib.pyplot import ylim
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn import manifold
from matplotlib import pyplot
from pandas import DataFrame


engaging = pd.read_csv('ASCERTAIN/engaging.csv', sep=',',header=None).values
familiarity = pd.read_csv('ASCERTAIN/familiarity.csv', sep=',',header=None).values
valence = pd.read_csv('ASCERTAIN/valence.csv', sep=',',header=None).values
arousal = pd.read_csv('ASCERTAIN/arousal.csv', sep=',',header=None).values
liking = pd.read_csv('ASCERTAIN/liking.csv', sep=',',header=None).values

personality = pd.read_csv('ASCERTAIN/personality.csv', sep=',',header=None).values

personality = (personality - 1) / 6.0

extrovertion, agreeableness, conscientiousness, emotionalStability, openness = personality[:, 0], personality[:, 1], personality[:, 2], personality[:, 3], personality[:, 4], 



X = np.stack([valence,arousal, engaging, familiarity, liking], axis=2)
# [58, 5, 36] => [Npersons, Nvideos, Ndimensions]
X = X.transpose(0, 2, 1)

# X = X / 5.0


N, K, T = X.shape

def distance_k(x_1, x_2, k):
    return (np.power(np.power(x_1[k] - x_2[k], 2).sum(), 1/2)) / x_1.shape[1]

def distance_m(m_1, m_2):
    return (m_1 - m_2) ** 2

D_valence = np.zeros([N, N])
D_arousal = np.zeros([N, N])
D_engaging = np.zeros([N, N])
D_familiarity = np.zeros([N, N])
D_liking = np.zeros([N, N])

D_extrovertion = np.zeros([N, N])
D_agreeableness = np.zeros([N, N])
D_conscientiousness = np.zeros([N, N])
D_emotionalStability = np.zeros([N, N])
D_openness = np.zeros([N, N])

alpha_valence = 1
alpha_arousal = 1
alpha_engaging = 1
alpha_familiarity = 1
alpha_liking = 1

alpha_extrovertion = 1
alpha_agreeableness = 1
alpha_conscientiousness = 1
alpha_emotionalStability = 1
alpha_openness = 1

D = np.zeros([N, N])

for i in range(N):
    for j in range(N):
        D_valence[i][j] = distance_k(X[i], X[j], 0)
        D_arousal[i][j] = distance_k(X[i], X[j], 1)
        D_engaging[i][j] = distance_k(X[i], X[j], 2)
        D_familiarity[i][j] = distance_k(X[i], X[j], 3)
        D_liking[i][j] = distance_k(X[i], X[j], 4)
        
        D_extrovertion[i][j] = distance_m(extrovertion[i], extrovertion[j])
        D_agreeableness[i][j] = distance_m(agreeableness[i], agreeableness[j])
        D_conscientiousness[i][j] = distance_m(conscientiousness[i], conscientiousness[j])
        D_emotionalStability[i][j] = distance_m(emotionalStability[i], emotionalStability[j])
        D_openness[i][j] = distance_m(openness[i], openness[j])

# print(D_extrovertion)
# print(D_valence)
        
D = np.stack([np.power(D_valence, 2) * (alpha_valence ** 2), np.power(D_arousal,2) * (alpha_arousal ** 2), np.power(D_engaging, 2) * (alpha_engaging ** 2) , np.power(D_familiarity, 2) * (alpha_familiarity ** 2), np.power(D_liking, 2) * (alpha_liking ** 2), np.power(D_extrovertion, 2) * (alpha_extrovertion ** 2), np.power(D_agreeableness, 2) * (alpha_agreeableness ** 2), np.power(D_conscientiousness, 2) * (alpha_conscientiousness ** 2), np.power(D_emotionalStability, 2) * (alpha_emotionalStability ** 2), np.power(D_openness, 2) * (alpha_openness ** 2)], axis=2)
D = np.sum(D, axis=2)
D = np.power(D, 1/2)





mds = manifold.MDS(n_components=2, dissimilarity="precomputed", random_state=6)
# mds = manifold.MDS(n_components=2, dissimilarity="precomputed")
results = mds.fit(D)
coords = results.embedding_

alpha_valence = 0.2

D_2 = np.stack([np.power(D_valence , 2) * (alpha_valence ** 2), np.power(D_arousal,2) * (alpha_arousal ** 2), np.power(D_engaging, 2) * (alpha_engaging ** 2) , np.power(D_familiarity, 2) * (alpha_familiarity ** 2), np.power(D_liking, 2) * (alpha_liking ** 2), np.power(D_extrovertion, 2) * (alpha_extrovertion ** 2), np.power(D_agreeableness, 2) * (alpha_agreeableness ** 2), np.power(D_conscientiousness, 2) * (alpha_conscientiousness ** 2), np.power(D_emotionalStability, 2) * (alpha_emotionalStability ** 2), np.power(D_openness, 2) * (alpha_openness ** 2)], axis=2)
D_2 = np.sum(D_2, axis=2)
D_2 = np.power(D_2, 1/2)

mds_2 = manifold.MDS(n_components=2, dissimilarity="precomputed", random_state=6)
# mds = manifold.MDS(n_components=2, dissimilarity="precomputed")
results_2 = mds_2.fit(D_2)
coords_2 = results_2.embedding_



print(coords.shape)
print(coords_2.shape)

P = coords
Q = coords_2


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
# coords = R.dot(Q.transpose()).transpose()



# coords = coords_2










def plot_mts(X, i):
    years = DataFrame()
    years[0] = X[i][0]
    years[1] = X[i][1]
    years[2] = X[i][2]
    years[3] = X[i][3]
    years[4] = X[i][4]
    years.plot(subplots=True, legend=False,xlim=(0,40), ylim=(0, 31))


# plot_mts(X, 57)
# plot_mts(X, 55)
# plot_mts(X, 43)

# pyplot.show()

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
# print(distance_k(X[0], X[1],4))


# a = np.array([0,1,2,3,4])
# b = np.array([1,2,3,4,6])

# print(distance_k(a, b))