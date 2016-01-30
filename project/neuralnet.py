#!/usr/bin/env python

# taken primarily from stephencwelch's "Neural Networks Demystified"

from sklearn import *
# from scipy.special import expit
import scipy.optimize as optimize
import numpy as np
import csv
import warnings
import matplotlib.pyplot as plt

np.set_printoptions(suppress=True)

class neural_network(object):
	def __init__(self, l=0.0001):        
		self.n_input = 21
		self.n_hidden = 15
		self.n_output = 1
		
		#Weights (parameters)
		self.w1 = np.random.randn(self.n_input,self.n_hidden)
		self.w2 = np.random.randn(self.n_hidden,self.n_output)
		
		self.l = l

	def forward(self, x):
		#Propogate inputs though network
		self.z2 = np.dot(x, self.w1)
		self.a2 = np.tanh(self.z2)
		self.z3 = np.dot(self.a2, self.w2)
		y_hat = np.tanh(self.z3)
		return y_hat
		
	def sigmoid(self, z):
		#Apply sigmoid activation function to scalar, vector, or matrix
		return 1 / (1+np.exp(-z))
	
	def sigmoidPrime(self,z):
		#Gradient of sigmoid
		return np.exp(-z) / ((1+np.exp(-z))**2)
	
	def costFunction(self, x, y):
		#Compute cost for given x,y, use weights already stored in class.
		self.y_hat = self.forward(x)
		J = 0.5*sum((y-self.y_hat)**2)/x.shape[0] + (self.l/2)*(sum(self.w1**2)+sum(self.w2**2))
		return J
	
	#Helper functions for interacting with other methods/classes
	def getParams(self):
		#Get w1 and w2 Rolled into vector:
		params = np.concatenate((self.w1.ravel(), self.w2.ravel()))
		return params
	
	def setParams(self, params):
		#Set w1 and w2 using single parameter vector:
		w1_start = 0
		w1_end = self.n_hidden*self.n_input
		self.w1 = np.reshape(params[w1_start:w1_end], (self.n_input, self.n_hidden))
		w2_end = w1_end + self.n_hidden*self.n_output
		self.w2 = np.reshape(params[w1_end:w2_end], (self.n_hidden, self.n_output))
		
	def computeGradients(self, x, y):
		self.y_hat = self.forward(x)
		
		delta3 = np.multiply(-(y-self.y_hat), self.sigmoidPrime(self.z3))
		#Add gradient of regularization term:
		dJdw2 = np.dot(self.a2.T, delta3)/x.shape[0] + self.l*self.w2
		
		delta2 = np.dot(delta3, self.w2.T)*self.sigmoidPrime(self.z2)
		#Add gradient of regularization term:
		dJdw1 = np.dot(x.T, delta2)/x.shape[0] + self.l*self.w1

		return np.concatenate((dJdw1.ravel(), dJdw2.ravel()))

	def unpack_thetas(self, thetas):
		t1_start = 0
		t1_end = self.n_hidden * self.n_input
		t1 = thetas[t1_start:t1_end].reshape(self.n_hidden, self.n_input)
		t2 = thetas[t1_end:].reshape(self.n_hidden, self.n_output)
		
		return t1, t2

	def callbackF(self, params):
		self.setParams(params)
		self.J.append(self.costFunction(self.x, self.y))
		self.testJ.append(self.costFunction(self.testx, self.testy))
		
	def costFunctionWrapper(self, params, x, y):
		self.setParams(params)
		cost = self.costFunction(x, y)
		grad = self.computeGradients(x, y)
		
		return cost, grad
		
	def train(self, trainx, trainy, testx, testy):
		#Make an internal variable for the callback function:
		self.x = trainx
		self.y = trainy
		
		self.testx = testx
		self.testy = testy

		num_labels = trainy.shape[0]

		#Make empty list to store training costs:
		self.J = []
		self.testJ = []
		
		params0 = self.getParams()

		options = {'maxiter': 500, 'disp' : True}
		_res = optimize.minimize(self.costFunctionWrapper, params0, jac=True, method='SLSQP', \
								 args=(trainx, trainy), options=options)

		self.setParams(_res.x)
		self.optimizationResults = _res

		self.t1, self.t2 = self.unpack_thetas(_res.x)

		np.save("w1", self.t1)
		np.save("w2", self.t2)

	def predict(self, x, t1, t2):
		guesses = []
		# num_test = x.shape[0]
		# for i in range(num_test):
		self.z2 = np.dot(x, self.w1)
		self.a2 = np.tanh(self.z2)
		self.z3 = np.dot(self.a2, self.w2)
		y_hat = np.tanh(self.z3)
		return y_hat
			# guesses.append(np.argmax(y_hat))
		# return guesses

map2 = {}
arr = np.array([])

sqfts = np.empty((0,1), float)
beds = np.empty((0,1), float)
baths = np.empty((0,1), float)
prices = np.empty((0,1), float)

with open('data/train/train.csv', 'r') as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
		zp = row['addr_zip']
		if not map2.has_key(zp):
			map2[zp] = arr
		map2[zp] = np.append(map2[zp], int(row['price']))
		sqfts = np.vstack([sqfts, float(row['size_sqft'])])
		beds = np.vstack([beds, float(row['bedrooms'])])
		baths = np.vstack([baths, float(row['bathrooms'])])
		prices = np.vstack([prices, float(row['price'])])

sqft_mean = np.mean(sqfts)
sqft_sdev = np.std(sqfts)
beds_mean = np.mean(beds)
beds_sdev = np.std(beds)
baths_mean = np.mean(baths)
baths_sdev = np.std(baths)
prices_mean = np.mean(prices)
prices_sdev = np.std(prices)

print(sqft_mean, sqft_sdev, beds_mean, beds_sdev, baths_mean, baths_sdev, prices_mean, prices_sdev)

map3 = {}

for key, value in map2.items():
	sdev = np.std(value)
	mean = np.mean(value)
	mx = np.amax(value)
	value = value - mean
	value = value / sdev
	med = np.median(value)
	map3[key] = med
	# print(key, med, sdev, mean, mx)

features = np.empty((0,5), float)
labels = np.empty((0,1), float)

with open('data/train/train_nooutlier.csv', 'r') as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
		zp = row['addr_zip']
		zval = map3[zp]
		newrow = [float(zp), float(row['size_sqft']), float(row['bedrooms']), float(row['bathrooms']), float(row['prewar'])]
		features = np.vstack([features, newrow])
		labels = np.vstack([labels,float(row['price'])])
		
test_features = np.empty((0,5), float)
test_labels = np.empty((0,1), float)
		
with open('data/test/test_nooutlier.csv', 'r') as csvfile:
	reader = csv.DictReader(csvfile)
	for row in reader:
		zp = row['addr_zip']
		zval = map3[zp]
		newrow = [float(zp), float(row['size_sqft']), float(row['bedrooms']), float(row['bathrooms']), float(row['prewar'])]
		test_features = np.vstack([test_features, newrow])
		test_labels = np.vstack([test_labels,float(row['price'])])

print(features.shape, labels.shape, test_features.shape, test_labels.shape)

max_price = np.amax(labels)
min_price = np.amin(labels)
max_test_price = np.amax(test_labels)
test_features[:,1] = test_features[:,1]/np.amax(features[:,1])
test_features[:,2] = test_features[:,2]/np.amax(features[:,2])
test_features[:,3] = test_features[:,3]/np.amax(features[:,3])
features[:,1] = features[:,1]/np.amax(features[:,1])
features[:,2] = features[:,2]/np.amax(features[:,2])
features[:,3] = features[:,3]/np.amax(features[:,3])
# test_labels = test_labels/np.amax(labels)
# labels = labels/np.amax(labels)
test_labels = test_labels/np.amax(labels)
labels = labels/np.amax(labels)

labels = labels * 1.32

# robust = preprocessing.RobustScaler()
# f_r = robust.fit_transform(features[:,1:features.shape[1]])
# features[:,1:features.shape[1]] = f_r
# tf_r = robust.transform(test_features[:,1:features.shape[1]])
# test_features[:,1:features.shape[1]] = tf_r

enc = preprocessing.OneHotEncoder(categorical_features=[0])
enc.fit(features)
fitted = enc.transform(features).toarray()
features = fitted
test_features = enc.transform(test_features).toarray()

nn = neural_network()
nn.train(features,labels,test_features,test_labels)

guesses = nn.predict(test_features, nn.t1, nn.t2)
print(max_price, max_test_price)
np.savetxt("guesses.txt", guesses*max_price, '%9.2f', newline="\n")
train_guesses = nn.predict(features, nn.t1, nn.t2)
np.savetxt("trainguesses.txt", train_guesses*max_price, '%9.2f', newline="\n")

guesses = np.array([guesses]).T
print np.amin(guesses)
# guesses = guesses + np.absolute(np.amin(guesses))

diff = np.subtract(guesses, test_labels)
diff = np.absolute(diff)
diff = np.divide(diff, test_labels)
avg_error = np.mean(diff)
print "neural net error: %s" % (avg_error)

fig, ax = plt.subplots()
y = test_labels*max_price
ax.scatter(y, guesses*max_price)
ax.plot([y.min(), y.max()], [y.min(), y.max()], 'k--', lw=4)
ax.set_xlabel('Actual ($MM)')
ax.set_ylabel('Predicted ($MM)')
plt.title('Neural Network')
plt.show()
