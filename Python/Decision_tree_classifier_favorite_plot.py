import numpy as np
import matplotlib.pyplot as plt
from sklearn import tree
import pandas as pd
my_data1=pd.read_csv("/Users/bryanmac/Desktop/admission2.csv")
clf = tree.DecisionTreeClassifier()
X=my_data1[['Age', 'Income', 'Year-of-Education']]
y=my_data1['Favorite']
clf.fit(X, y)
fig = plt.figure(figsize=(16,14))
tree.plot_tree(clf,feature_names=X.columns,fontsize=12,filled=True)

clf = tree.DecisionTreeClassifier(min_impurity_decrease =0.0672)
X=my_data1[['Age', 'Income', 'Year-of-Education']]
y=my_data1['Favorite']
clf.fit(X, y)
fig = plt.figure(figsize=(10,10))
tree.plot_tree(clf,feature_names=X.columns,fontsize=12,filled=True)


from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=0)


for decrease in np.arange(0, 0.1,0.01):
    clf = tree.DecisionTreeClassifier(min_impurity_decrease =decrease)
    clf.fit(X_train, y_train)
    print("min_impurity_decrease=%f score=%f" %(decrease,clf.score(X_test, y_test)))                           








