import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.naive_bayes import MultinomialNB
import pickle

df = pd.read_csv("spam.csv")

#### As I want to work with categorical data, I need to convert Spam and ham to 0 and 1.
df["Spam"] = df["Category"].map({"spam" : 1, "ham" : 0})
## make a copy of original dataframe as I do not need Category column.
df1 = df.copy()
df1.drop(labels = "Category", axis = 1, inplace =  True)

## Now, defining my X and y for model building.

X = df1["Message"]
y = df1["Spam"]

## split the data in train and test just to avoid overfitting

X_train, X_test, y_train, y_test = train_test_split(X,y, random_state = 42)

####CountVectorizer is used to transform a given text into a vector on the basis of the frequency of each word that occurs in the entire text.
vector = CountVectorizer()
X_train_vectorized = vector.fit_transform(X_train.values)
X_train_vectorized.toarray()
pickle.dump(vector,open("abc.pkl", "wb"))

## selecting Multinimial Na## selecting Multinimial Naive Bayes

clf = MultinomialNB()
clf.fit(X_train_vectorized,y_train)## selecting Multinimial Naive Bayes
pickle.dump(clf, open("model.pkl", "wb"))
