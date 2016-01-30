function [train_acc, valid_acc, test_acc] = tree_acc(split_crit, min_leaf)
    tree = make_tree('car_train.data', split_crit, min_leaf);
    [train_features, train_labels] = one_hot_encode('car_train.data');
    [valid_features, valid_labels] = one_hot_encode('car_valid.data');
    [test_features, test_labels] = one_hot_encode('car_test.data');
    train_acc = tree_helper(tree, train_features, train_labels)
    valid_acc = tree_helper(tree, valid_features, valid_labels)
    test_acc = tree_helper(tree, test_features, test_labels)

end
