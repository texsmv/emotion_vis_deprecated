from matplotlib.pyplot import ylim
import pandas as pd
import numpy as np
from datetime import *
import matplotlib.pyplot as plt
from sklearn import manifold
from matplotlib import pyplot
from pandas import DataFrame



def classById(id):
    if id % 2 == 0:
        return "A"
    else:
        return "B"


PATH ="ASCERTAIN/"

engaging = pd.read_csv(PATH + 'engaging.csv', sep=',',header=None).values
familiarity = pd.read_csv(PATH + 'familiarity.csv', sep=',',header=None).values
valence = pd.read_csv(PATH + 'valence.csv', sep=',',header=None).values
arousal = pd.read_csv(PATH + 'arousal.csv', sep=',',header=None).values
liking = pd.read_csv(PATH + 'liking.csv', sep=',',header=None).values

personality = pd.read_csv(PATH + 'personality.csv', sep=',',header=None).values

extrovertion, agreeableness, conscientiousness, emotionalStability, openness = personality[:, 0], personality[:, 1], personality[:, 2], personality[:, 3], personality[:, 4]

X = np.stack([valence,arousal, engaging, familiarity, liking], axis=2)
# [58, 36, 5] => [Npersons, Nvideos, Ndimensions]
X = X.transpose(0, 2, 1)

N, K, T = X.shape




categoryModel = True


if categoryModel:
    emotionModel = 'category'
else:
    emotionModel = 'dimensional'

initialDate = datetime(1970, 1, 1)
today = datetime.now()

duration = today - initialDate

personID = 57

print("<emotionml>")

print("<vocabulary type=\"category\" id=\"big6\">")
print("<item name=\"Valence\"/>")
print("<item name=\"Arousal\"/>")
print("<item name=\"Engaging\"/>")
print("<item name=\"Familiarity\"/>")
print("<item name=\"Liking\"/>")
print("</vocabulary>")


print("<info>")
print("<identifier name=\"id\" value=\""+ str(personID) +"\"/>")
print("<categorical name=\"class\" value=\""+ classById(personID) +"\"/>")
print("<numerical name=\"extrovertion\" value=\""+ str(extrovertion[personID]) +"\"/>")
print("<numerical name=\"agreeableness\" value=\""+ str(agreeableness[personID]) +"\"/>")
print("<numerical name=\"conscientiousness\" value=\""+ str(conscientiousness[personID]) +"\"/>")
print("<numerical name=\"emotionalStability\" value=\""+ str(emotionalStability[personID]) +"\"/>")
print("<numerical name=\"openness\" value=\""+ str(openness[personID]) +"\"/>")
print("</info>")



for i in range(T):
    date = int((today - initialDate + timedelta(days= i)).total_seconds() * 1000)
    
    print("<emotion "+emotionModel+"-set=\"http://www.w3.org/TR/emotion-voc/xml#big6\" start=\" "+ str(date)  +"\" >")
    
    
    print("<"+emotionModel+" name=\"Valence\" value=\""+ str(X[personID][0][i]) +"\"/>")
    print("<"+emotionModel+" name=\"Arousal\" value=\""+ str(X[personID][1][i]) +"\"/>")
    print("<"+emotionModel+" name=\"Engaging\" value=\""+ str(X[personID][2][i]) +"\"/>")
    print("<"+emotionModel+" name=\"Familiarity\" value=\""+ str(X[personID][3][i]) +"\"/>")
    print("<"+emotionModel+" name=\"Liking\" value=\""+ str(X[personID][4][i]) +"\"/>")

        
    print("</emotion>")

print("</emotionml>")