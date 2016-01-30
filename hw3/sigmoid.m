function sig = sigmoid(z)
    sig = zeros(size(z));
    sig = 1. / (1 + exp(-z));

end
