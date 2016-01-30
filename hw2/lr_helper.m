function acc = lr_helper(lr_model, file_name)
    [new_features, new_labels] = lr_category(file_name);
    probs = mnrval(lr_model, new_features);
    sz = size(probs);
    sz = sz(1,1);
    correct = 0;
   
    for i = 1:sz
        [maxi, guess] = max(probs(i,:));
        if (guess == new_labels(i))
            correct = correct + 1;
        end
    end
    
    acc = correct / sz;
end
