# -*- coding: utf-8 -*-
"""

"""

import numpy as np

import pandas as pd


my_data=pd.read_csv("/Users/bryanmac/Desktop/classnote_8records_hw.csv")
X=my_data[['X1', 'X2']]
y=my_data['y']


Minimum=10000000
i=0
w1=0;w2=0;b=-10;d0=0;d1=0;d2=0;d3=0;d4=0;d5=0;d6=0;d7=0
w1_m=0;w2_m=0;b_m=0;d0_m=0;d1_m=0;d2_m=0;d3_m=0;d4_m=0;d5_m=0;d6_m=0;d7_m=0
for w1 in np.linspace(1,5,150):
    i=i+1
    print("round",i)
    for w2 in np.linspace(1,5,150):
        for b in np.linspace(-4,4,50):
            if (X.iloc[0,0]*w1+X.iloc[0,1]*w2+b-1+d0>=0
                and
                X.iloc[1,0]*w1+X.iloc[1,1]*w2+b-1+d1>=0
                and
                X.iloc[2,0]*w1+X.iloc[2,1]*w2+b-1+d2>=0
                and
                X.iloc[3,0]*w1+X.iloc[3,1]*w2+b-1+d3>=0
                and
                -(X.iloc[4,0]*w1+X.iloc[4,1]*w2+b)-1+d4>=0
                and
                -(X.iloc[5,0]*w1+X.iloc[5,1]*w2+b)-1+d5>=0
                and
                -(X.iloc[6,0]*w1+X.iloc[6,1]*w2+b)-1+d6>=0
                and
                -(X.iloc[7,0]*w1+X.iloc[7,1]*w2+b)-1+d7>=0
                ):
                F=(w1*w1+w2*w2)/2+20*(d0+d1+d2+d3+d4+d5+d6+d7)
                print(Minimum,w1,w2,b)
                F=np.round(F,3)
                w1=np.round(w1,3)
                w2=np.round(w2,3)
                b=np.round(b,3)
                print("Minumum=",Minimum,"Now=",F,w1,w2,b)
                if F<=Minimum:
                    Minimum=F
                    w1_m=w1;w2_m=w2;b_m=b;
                    print(Minimum,w1,w2,b)
print("Done! my answer is:")
print(w1_m,w2_m,b_m)
