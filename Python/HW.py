import pandas as pd
import numpy as np
import math

data=pd.read_csv("/Users/bryanmac/Desktop/MISM6212/Week 2/assignment1_data.csv")
print(data)
sLength = len(data['Favorite'])

for x in range(sLength):
    print(type(data.iloc[x,5]))
for x in range(sLength):
    print(pd.isnull(data.iloc[x,5]))
  
## find max freq and index    

Freq=pd.DataFrame({'YES': [0], 'Not_Fav':0, 'More_Than_Fav':0})   
for x in range(sLength):
    if not pd.isnull(data.iloc[x,5]):
        if data.iloc[x,5]=="YES":
            Freq.iloc[0,0] =Freq.iloc[0,0]+1
        if data.iloc[x,5]=="Not_Fav":
            Freq.iloc[0,1] =Freq.iloc[0,1]+1
        if data.iloc[x,5]=="More_Than_Fav":
            Freq.iloc[0,2] =Freq.iloc[0,2]+1
maxfreq=0
maxindex=0
for x in range(3):
    if Freq.iloc[0,x]>maxfreq:
        maxfreq=Freq.iloc[0,x]
        maxindex=x
Imputed_value= Freq.columns[maxindex]       
####################imputation

for x in range(sLength):
    if pd.isnull(data.iloc[x,5]):
        data.iloc[x,5]=Imputed_value 
##Age    
sum=0
count=0
idx=1
for x in range(sLength):
    if not pd.isnull(data.iloc[x,idx]):
        sum=sum+ data.iloc[x,idx]
        count=count+1
average=sum/count
##imputation Age
for x in range(sLength):
    if pd.isnull(data.iloc[x,idx]):
        data.iloc[x,idx]=average 
pd.set_option('max_columns', None)
# data["Age"]=round(data["Age"])
print(data)

##Year-of-Education        
sum=0
count=0
idx=3
for x in range(sLength):
    if not pd.isnull(data.iloc[x,idx]):
        sum=sum+ data.iloc[x,idx]
        count=count+1
average=sum/count
##imputation Year-of-Education
for x in range(sLength):
    if pd.isnull(data.iloc[x,idx]):
        data.iloc[x,idx]=average 
pd.set_option('max_columns', None)
print(data)

##categorical to numerical
for x in range(sLength):
    if data.iloc[x,5]=="YES":
        data.iloc[x,5] =1
    if data.iloc[x,5]=="Not_Fav":
        data.iloc[x,5] =0
    if data.iloc[x,5]=="More_Than_Fav":
        data.iloc[x,5] =2
print(data)

##maximum Age
max_age=0
for x in range(sLength):
    if data.iloc[x,1]>max_age:
        max_age=data.iloc[x,1]
print(max_age)

##minimum Age
min_age=10000000
for x in range(sLength):
    if data.iloc[x,1]<min_age:
        min_age=data.iloc[x,1]
print(min_age)

#create age Normalization
data['Age_Normalized']=np.repeat(0,sLength)
for x in range(sLength):
    data.iloc[x,6]=(data.iloc[x,1]-min_age)/(max_age-min_age)
print(data)


##maximum Income
max_income=0
for x in range(sLength):
    if data.iloc[x,2]>max_income:
        max_income=data.iloc[x,2]
print(max_income)

##minimum Income
min_income=10000000
for x in range(sLength):
    if data.iloc[x,2]<min_income:
        min_income=data.iloc[x,2]
print(min_income)

#create income Normalization
data['Income_Normalized']=np.repeat(0,sLength)
for x in range(sLength):
    data.iloc[x,7]=(data.iloc[x,2]-min_age)/(max_age-min_age)
print(data)

#Transfornation
data['SquareRoot_Income']= np.sqrt(data['Income'])
data['Combined_Age_Income']= data['Age']*0.5+data['Income']*0.6

print(data)

data.to_csv("/Users/bryanmac/Desktop/MISM6212/Week 2/assignment1_result.csv",index=False)
