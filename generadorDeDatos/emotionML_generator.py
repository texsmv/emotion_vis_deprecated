from datetime import *
import random

# categoryModel = True
categoryModel = False


if categoryModel:
    emotionModel = 'category'
else:
    emotionModel = 'dimensional'

n = 1000

initialDate = datetime(1970, 1, 1)
today = datetime.now()

duration = today - initialDate


print("<emotionml>")

for i in range(n):
    date = int((today - initialDate + timedelta(days= i)).total_seconds() * 1000)
    
    print("<emotion "+emotionModel+"-set=\"http://www.w3.org/TR/emotion-voc/xml#big6\" start=\" "+ str(date)  +"\" >")
    
    if(categoryModel):
        print("<"+emotionModel+" name=\"Joy\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Anger\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Trust\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Fear\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Surprise\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Sadness\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    else:
        print("<"+emotionModel+" name=\"Arousal\" value=\""+ str(random.uniform(0, 1)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Pleasure\" value=\""+ str(random.uniform(0, 1)) [:3] +"\"/>")
        print("<"+emotionModel+" name=\"Dominance\" value=\""+ str(random.uniform(0, 1)) [:3] +"\"/>")
        
    print("</emotion>")

print("</emotionml>")