#!/usr/bin/env python

from sklearn import *
from sklearn.tree import DecisionTreeRegressor
import numpy as np
import csv
import warnings
import time
import matplotlib.pyplot as plt

np.set_printoptions(suppress=True)

start_time = time.time()

features = np.empty((0,5), float)
labels = np.empty((0,1), float)

with open('data/train/train_nooutlier.csv', 'r') as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
		zp = row['addr_zip']
		newrow = [float(zp), float(row['size_sqft']), float(row['bedrooms']), float(row['bathrooms']), float(row['prewar'])]
		features = np.vstack([features, newrow])
		labels = np.vstack([labels,float(row['price'])])
		
test_features = np.empty((0,5), float)
test_labels = np.empty((0,1), float)
		
with open('data/test/test_nooutlier.csv', 'r') as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
		zp = row['addr_zip']
		newrow = [float(zp), float(row['size_sqft']), float(row['bedrooms']), float(row['bathrooms']), float(row['prewar'])]
		test_features = np.vstack([test_features, newrow])
		test_labels = np.vstack([test_labels,float(row['price'])])

print(features.shape, labels.shape, test_features.shape, test_labels.shape)

max_price = np.amax(labels)
min_price = np.amin(labels)
max_test_price = np.amax(test_labels)

robust = preprocessing.StandardScaler()
f_r = robust.fit_transform(features[:,1:features.shape[1]])
features[:,1:features.shape[1]] = f_r
tf_r = robust.transform(test_features[:,1:features.shape[1]])
test_features[:,1:features.shape[1]] = tf_r

enc = preprocessing.OneHotEncoder(categorical_features=[0])
enc.fit(features)
fitted = enc.transform(features).toarray()
features = fitted
test_features = enc.transform(test_features).toarray()
min_error = 1
min_idx = 1

labels = labels * 1.32

tree = DecisionTreeRegressor(max_features='log2', min_samples_leaf=5, random_state=0)
tree.fit(features, labels)
guesses = tree.predict(test_features)
np.savetxt("tree_guesses.txt", guesses, '%9.2f', newline="\n")

guesses = np.array([guesses]).T

diff = np.subtract(guesses, test_labels)
diff = np.absolute(diff)
diff = np.divide(diff, test_labels)
avg_error = np.mean(diff)
print "decision tree regression, error: %s" % (avg_error)

print tree.feature_importances_
fig, ax = plt.subplots()
y = test_labels
ax.scatter(y, guesses)
ax.plot([y.min(), y.max()], [y.min(), y.max()], 'k--', lw=4)
ax.set_xlabel('Actual ($MM)')
ax.set_ylabel('Predicted ($MM)')
plt.title('Decision Tree Regression')
plt.show()

print "time taken: %s seconds" % (time.time() - start_time)
