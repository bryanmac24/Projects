import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
import pandas as pd
my_data=pd.read_csv("/Users/bryanmac/Desktop/admission.csv")
X=my_data[['Normalized GPA', 'Normalized SAT']]
y=my_data['Accept']

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)
for my_C in [1,5,10,20,100,1000]:
    clf = svm.SVC(kernel='rbf', C=my_C)
    clf.fit(X_train, y_train)
    print("C=%f score=%f" %(my_C,clf.score(X_test, y_test)))                           

