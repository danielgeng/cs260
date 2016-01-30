function [new_accu, train_accu] = helper(train_file, new_file, k)
    [traind, trainl] = one_hot_encode(train_file);
    [newd, newl] = one_hot_encode(new_file);
    [new_accu, train_accu] = knn_classify(traind, trainl, newd, newl, k);
    new_accu
    train_accu
end
