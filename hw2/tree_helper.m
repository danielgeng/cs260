function acc = tree_helper(tree, new_features, new_labels)
    guesses = predict(tree, new_features);
    sz = size(guesses);
    sz = sz(1,1);
    correct = 0;
    for i = 1:sz
        if strcmp(new_labels(i), guesses(i))
            correct = correct + 1;
        end
    end
    acc = correct / sz;
end
