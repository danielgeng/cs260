function tree = make_tree(file_name, split_crit, min_leaf)
    [features, labels] = one_hot_encode(file_name);
    tree = fitctree(features, labels, 'SplitCriterion', split_crit, 'MinLeafSize', min_leaf, 'Prune', 'off');
end
