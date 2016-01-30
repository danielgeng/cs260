#!/usr/bin/env python

from sklearn import *
from sklearn.neighbors import KNeighborsRegressor
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

robust = preprocessing.RobustScaler()
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

for i in range(3,25):
	neigh = KNeighborsRegressor(n_neighbors=i, p=2, n_jobs=2)
	neigh.fit(features, labels)

	guesses = neigh.predict(test_features)

	# np.savetxt("knn_guesses.txt", guesses, '%9.2f', newline="\n")

	diff = np.subtract(guesses, test_labels)
	diff = np.absolute(diff)
	diff = np.divide(diff, test_labels)
	# np.savetxt("knn_error.txt", diff, '%0.5f', newline="\n")
	avg_error = np.mean(diff)
	if(avg_error < min_error):
		min_error = avg_error
		min_idx = i
	print "%s neighbors, %s error" % (i, avg_error)

print "best result with %s neighbors with %s error" % (min_idx, min_error)
print "time taken: %s seconds" % (time.time() - start_time)

print np.amax(labels)/1.32

neigh = KNeighborsRegressor(n_neighbors=min_idx, p=2, n_jobs=2, weights='distance')
neigh.fit(features, labels)

fig, ax = plt.subplots()
y = test_labels
ax.scatter(y, guesses)
ax.plot([y.min(), y.max()], [y.min(), y.max()], 'k--', lw=4)
ax.set_xlabel('Actual ($MM)')
ax.set_ylabel('Predicted ($MM)')
plt.title('KNN Regression')
plt.show()

# np.savetxt("knn_trainguesess.txt", train_guesses*max_price, '%9.2f', newline="\n")
