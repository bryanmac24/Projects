import numpy as np
import matplotlib.pyplot as plt
from sklearn import svm
import pandas as pd
my_data=pd.read_csv("/Users/bryanmac/Desktop/admission.csv")
X=my_data[['Normalized GPA', 'Normalized SAT']]
y=my_data['Accept']

plt.axes().set_aspect('equal')
plt.scatter( X["Normalized GPA"], X["Normalized SAT"], c=y, s=30, cmap=plt.cm.Paired)
clf = svm.SVC(kernel='rbf', C=20)
clf.fit(X, y)
# plot the decision function
ax = plt.gca()
xlim = ax.get_xlim()
ylim = ax.get_ylim()
xx = np.linspace(xlim[0], xlim[1], 30)
yy = np.linspace(ylim[0], ylim[1], 30)
YY, XX = np.meshgrid(yy, xx)
xy = np.vstack([XX.ravel(), YY.ravel()]).T

# create grid to evaluate model
Z = clf.decision_function(xy).reshape(XX.shape)
# plot decision boundary and margins
ax.contourf(XX, YY, Z, colors='k', levels=[-1, 0, 1], alpha=0.5,linestyles=['--', '-', '--'])
# plot support vectors
ax.scatter(clf.support_vectors_[:, 0], clf.support_vectors_[:, 1], s=100,linewidth=1, facecolors='none')
plt.show()

