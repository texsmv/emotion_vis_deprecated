import torch
import torch.nn.functional as F
import torch.nn as nn
import torch.optim as optim
from torch.optim import optimizer
from dimensionality_reduction.fcae import TimeSeriesAE, DatasetMTS
from models.time_series_dataset import TimeSeriesDataset
from utils.time_series_utils import distance_matrix, time_serie_from_eml
from torch.utils.data import DataLoader
import numpy as np
import pandas as pd
from matplotlib import pyplot

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

# def slice_data(X, w, s):
#     n = X.shape[0]
    
    

def weights_init(m):
    classname = m.__class__.__name__
    if type(m) == nn.Linear:
        torch.nn.init.xavier_uniform_(m.weight)
        m.bias.data.fill_(0.01)
    if classname.find('Conv') != -1 and classname.find('Conv2d') == -1:
        m.weight.data.normal_(0.0, 0.02)
    elif classname.find('BatchNorm') != -1 and classname.find('BatchNorm2d') == -1:
        m.weight.data.normal_(1.0, 0.02)
        m.bias.data.fill_(0)

dataset =  TimeSeriesDataset() 

for file in files:
    mtserie = time_serie_from_eml(PATH + file)
    dataset.add(mtserie, mtserie.getId())


X = dataset.getValues()

w = 30
s = 1

n = X.shape[0]
t = X.shape[2]

slides = []

for i in range(n):
    for k in range(t - w):
        slides.append(X[i][:, k : k + w])
        # print(X[i][:, k : k + w].shape)

slides = np.array(slides).astype(np.double)
print(X.shape)
print(slides.shape)

# Mnum = dataset.getNumericalMetadataValues()

# Mcat = dataset.getCategoricalMetadataValues()


# X =  torch.zeros([10, 5, 30])

device = torch.device("cuda:0"  if torch.cuda.is_available() else "cpu")
if torch.cuda.is_available():
    print("Using cuda device")
    torch.cuda.set_device(device)

network = TimeSeriesAE().to(device)
network.apply(weights_init)
network.cuda()

dataset = DatasetMTS(slides, w, s)
dataloader = DataLoader(dataset, batch_size=30, shuffle=True, num_workers=2)


model_optimizer = optim.Adam(network.parameters(), lr = 0.0001)

# network(X)

for epoch in range(200):
    network.train()
    for i, data in enumerate(dataloader, 0):
        model_optimizer.zero_grad()
        x = data
        x = x.float().to(device)
        xp = network(x)
        
        
        loss = (x - xp).pow(2).sum()
        loss.backward()
        
        model_optimizer.step() 
        
        print(loss)
       

test = torch.tensor([slides[0]])
test = test.float().to(device)

test_out = network(test).detach().cpu().numpy()[0]

test = test.detach().cpu().numpy()[0]

print(test_out.shape)

data = pd.DataFrame()
data["0"] = test_out[0]
data["1"] = test_out[1]
data["2"] = test_out[2]
data["3"] = test_out[3]
data["4"] = test_out[4]

dataO = pd.DataFrame()
dataO["0"] = test[0]
dataO["1"] = test[1]
dataO["2"] = test[2]
dataO["3"] = test[3]
dataO["4"] = test[4]

dataO.plot(subplots=True, legend=False)
data.plot(subplots=True, legend=False)
pyplot.show()

 
# print(mtsDataset.__len__())
# print(mtsDataset.__getitem__(0).shape)
# print(mtsDataset.__getitem__(5).shape)

# y = model(X)

# print(y)
# print(y.shape)

# print(X.shape)

# conv1 = torch.nn.Conv1d(3, 64, 9, padding = 4)
# conv2 = torch.nn.Conv1d(64, 32, 5, padding = 2)
# conv3 = torch.nn.Conv1d(12, 12, 5, padding = 2)
# conv4 = torch.nn.Conv1d(12, 32, 5, padding = 2)
# conv5 = torch.nn.Conv1d(32, 64, 9, padding = 4)
# conv6 = torch.nn.Conv1d(64, 3, 9, padding = 4)
# maxPool1 = torch.nn.MaxPool1d(2)
# maxPool2 = torch.nn.MaxPool1d(3)

# upSample1 = torch.nn.Upsample(scale_factor=3)
# upSample2 = torch.nn.Upsample(scale_factor=2)
# # maxPool3 = torch.nn.MaxPool1d(3)
# linear = torch.nn.Linear(160, 60)
# linearOut = torch.nn.Linear(90, 90)

# X = F.relu(conv1(X))
# print(X.shape)
# X = maxPool1(X)
# print(X.shape)
# X = F.relu(conv2(X))
# print(X.shape)
# X = maxPool2(X)
# print(X.shape)
# # X = torch.flatten(X)
# X = X.view(-1, 160)
# print(X.shape)
# X = linear(X)
# X = X.view(-1, 12, 5)
# print(X.shape)
# X = F.relu(conv3(X))
# print(X.shape)
# X = upSample1(X)
# print(X.shape)
# X = F.relu(conv4(X))
# print(X.shape)
# X = upSample2(X)
# print(X.shape)
# X = F.relu(conv5(X))
# print(X.shape)
# X = conv6(X)
# print(X.shape)
# X = X.view(-1, 90)
# X = linearOut(X)
# print(X.shape)
# print(X)