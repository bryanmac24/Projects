#pipeline
import pandas as pd
import numpy as np

from sklearn.model_selection import train_test_split, KFold, cross_val_predict, cross_val_score
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score

from tqdm import tqdm
import xlrd
import pickle
from joblib import dump, load
import os

class ClassificationPipeline(object):
    def __init__(self, 
                 path, 
                 num_emotions, 
                 nan_perc = 0.2, 
                 verbose = 1,
                 save_dir='result',
                 model_path='saved_model.joblib',
                 filtered=None,
                 sheet_name=None):
        
        self.path = path
        self.num_emotions = int(num_emotions)
        self.nan_perc = float(nan_perc)
        self.verbose = verbose
        self.filtered = filtered
        self.sheet_name = sheet_name
        self.save_dir = save_dir
        self.model_path = model_path

    
    def prepare(self):        
        emotions = ["Confused", "Disgusted", "Sad", "Scared", "Surprised",
          "Happy", "Negative", "Engagement"]
        new_map = {
            'Confused': [],
            'Disgusted': [],
            'Sad': [],
            'Scared': [],
            'Surprised': [],
            'Happy':[],
            'Negative':[],
            'Engagement':[]
        }
        if (self.sheet_name):
            # case when it's an xlsx file.
            df = pd.read_excel(self.path, sheet_name=self.sheet_name)
        else :
            df = pd.read_csv(self.path)
        
        ## drop rows that are all NaNs and reset the index
        df = df.dropna(how="all").reset_index(drop=True)
        
        ## find actual lengths of ads. The Length_RE and Length_RE_plus1
        ## columns are both off for some ads. Also,
        ## because our emotion columns are 0 indexed ("Happy_0" is the 1st 
        ## happy second), Length_RE is always 1 second longer than the
        ## actual ad length (e.g. Length_RE = 15 means there is data
        ## in "Happy_15", which means that this ad is actually a 16
        ## second ad due to the 0-indexing). NOTE: In determining
        ## actual ad length, we use only one of the emotion column
        ## subsets (e.g. Happy_0 - Happy_60), with the assumption
        ## that this should be enough to determine real ad length (as
        ## oppposed to going through all the emotions, which seems
        ## unnecessary and time consuming).
        print("Finding actual lengths of ads...")
        ## get all unique ad id #s
        med_id = df["SourceMediaID"].unique()

        ## choose the 1st emotion as our test case
        test_emotion = emotions[0]

        ## loop through each ad id
        for x in med_id:
            temp = df.loc[df["SourceMediaID"] == x]
            if np.isnan(temp["Length_RE_plus1"].values).all():
                ## 62 is the highest number attached to any
                ## emotion column (e.g. "Happy_62"). Possibly change
                ## this later to do some kind of substring
                ## manipulation so that this isn't so
                ## hard coded in future.
                first_valid = 62
            else:
                first_valid = int(temp["Length_RE_plus1"]
                                  .loc[temp["Length_RE_plus1"]
                                  .first_valid_index()])
            test_col = test_emotion + "_" + str(first_valid)
            while temp[test_col].isnull().all() and first_valid > 0:
                first_valid = int(first_valid - 1)
                test_col = test_emotion + "_" + str(first_valid)
            ## adding + 1 because of 0-indexing
            df.loc[temp.index, "Length_Verified"] = first_valid + 1
        
        print("Starting with {} Respondents to be clustered".format(df.shape[0]))
        # Generate emotion aggregate data 
        print("Starting to aggregate data emotion level...")
        for index, row in tqdm(df.iterrows()):
            for emo in emotions:
                target = df.iloc[index]
                emo_count = (target.filter(regex=(emo))==1).sum() + (target.filter(regex=(emo))==0.5).sum()
                new_map[emo].append(emo_count)
        aggregate_df = pd.DataFrame(new_map)
        # Have to check what they call the "SessionID" column because they keep
        # changing it! Pick one!
        if "SessionID" in df.columns:
            sess_id = "SessionID"
        else:
            sess_id = "RealEyesSessionID"
        aggregate_df["Length_Verified"] = df["Length_Verified"]
        aggregate_df['SessionID'] = df[sess_id]
        aggregate_df['SourceMediaID'] = df['SourceMediaID']
        
        # Calculate nan_perc 
        print("Calculating NaN percentage per respondents...")
        target_columns = df.filter(regex=('_\d')).columns
        nan_perc = []
        for index, row in tqdm(df.iterrows()):
            target = df.iloc[index]
            length = row['Length_Verified']
            nan_counts = []
            for emo in emotions:
                nan_counts.append((target.filter(regex=(emo))[:int(length)].isnull().sum()/(length+1)))
            nan_perc.append(np.sum(nan_counts)/self.num_emotions)
        
        aggregate_df['nan_perc'] = nan_perc
        filtered = aggregate_df[aggregate_df['nan_perc'] <= self.nan_perc].copy() 
        self.filtered = filtered
        print('Done, filtered now has {} respondents after dropping respondents with more than {} nans'.format(filtered.shape[0], self.nan_perc))
        return self.filtered
    
    def predict(self):
        xTest = self.filtered[['Confused', 'Disgusted', 'Sad', 'Scared', 'Surprised', 'Happy', 'Negative', 'Engagement']].values
        model = load(self.model_path)
        yTest = model.predict(xTest)
        self.filtered['predicted_cluster'] = yTest
        print("Result saved in the path")
        if not os.path.exists('./'+self.save_dir+'/'):
            os.makedirs('./'+self.save_dir+'/')
        self.filtered[['SessionID', 'predicted_cluster']].to_csv(self.save_dir+'/result.csv', index=False)
        #print('Check if you have the model in correct model path')
        
        return self.filtered[['SessionID', 'predicted_cluster']]
    
    def model_accuracy(self, x, y): 
        print('For KNN method')

        xTrain, xHoldout, yTrain, yHoldout = train_test_split(x, y, test_size=0.3, random_state=42)
        model = load(self.model_path)
        model.fit(xTrain, yTrain)
        pred = model.predict(xHoldout)
        print('Holdout accuracy...')
        print(accuracy_score(yHoldout, pred) * 100)
        return pred

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='data', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--data_file')
    parser.add_argument('--num_emotions', default='8')
    parser.add_argument('--save_dir', default='result')
    parser.add_argument('--model_path', default='saved_model.joblib')
    args = parser.parse_args()
    pipeline = ClassificationPipeline(args.data_file, num_emotions = args.num_emotions, save_dir=args.save_dir)
    pipeline.prepare()

    pipeline.predict()
