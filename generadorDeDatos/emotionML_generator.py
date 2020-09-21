from datetime import *
import random
n = 1000

initialDate = datetime(1970, 1, 1)
today = datetime.now()

duration = today - initialDate


print("<emotionml>")

for i in range(n):
    date = int((today - initialDate + timedelta(days= i)).total_seconds() * 1000)
    
    print("<emotion category-set=\"http://www.w3.org/TR/emotion-voc/xml#big6\" start=\" "+ str(date)  +"\" >")
            
    print("<category name=\"Joy\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    print("<category name=\"Anger\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    print("<category name=\"Trust\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    print("<category name=\"Fear\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    print("<category name=\"Surprise\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    print("<category name=\"Sadness\" value=\""+ str(random.uniform(0, 5)) [:3] +"\"/>")
    print("</emotion>")

print("</emotionml>")