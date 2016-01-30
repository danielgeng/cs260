function [new_accu, train_accu] = naive_bayes(train_data, train_label, new_data, new_label)
    class_names = unique(train_label);
    num_classes = size(class_names);
    num_classes = num_classes(1,1);
    
    train_size = size(train_data);
    num_features = train_size(1,2);
    train_size = train_size(1,1);
    
    class_map = containers.Map('KeyType', 'char', 'ValueType', 'single');
    rev_map = containers.Map('KeyType', 'single', 'ValueType', 'char');
    class_count = containers.Map('KeyType', 'single', 'ValueType', 'single');
    
    counts = [];
    
    for i = 1:num_classes
        class_map(char(class_names(i))) = i;
        rev_map(i) = char(class_names(i));
        class_count(i) = 0;
        row = zeros(1,num_features);
        counts = [counts;row];
    end
    
    for i = 1:train_size
        class_idx = class_map(char(train_label(i)));
        class_count(class_idx) = class_count(class_idx) + 1;
        for j = 1:num_features
            if (train_data(i,j) == 1)
                counts(class_idx, j) = counts(class_idx, j) + 1;
            end
        end
    end
    
    class_probs = containers.Map('KeyType', 'single', 'ValueType', 'double');
    
    for i = 1:num_classes
        class_probs(i) = class_count(i) / train_size;
        
    end
    
    mle = [];
    
    for i = 1:num_classes
        for j = 1:num_features
            mle(i,j) = counts(i,j) / class_count(i);
            if mle(i,j) == 0
                mle(i,j) = 0.15;
            end
        end
    end
    
    keys(class_map)
    counts
    mle
    
    train_correct = 0;
    
    for i = 1:train_size
        argmax = containers.Map('KeyType', 'single', 'ValueType', 'double');
        for j = 1:num_classes
            sum = 0;
            for k = 1:num_features
                sum = sum + (train_data(i,k) * log2(mle(j,k)));
            end
            argmax(j) = (log2(class_probs(j)) + sum);
        end
        [maximum, maxi] = max(cell2mat(argmax.values));
        guess = rev_map(maxi);
        if strcmp(guess, train_label(i,1))
            train_correct = train_correct + 1;
        end
    end
    
    new_size = size(new_data);
    new_size = new_size(1,1);
    new_correct = 0;
    
    for i = 1:new_size
        argmax = containers.Map('KeyType', 'single', 'ValueType', 'double');
        for j = 1:num_classes
            sum = 0;
            for k = 1:num_features
                sum = sum + (new_data(i,k) * log2(mle(j,k)));
            end
            argmax(j) = (log2(class_probs(j)) + sum);
        end
        [maximum, maxi] = max(cell2mat(argmax.values));
        guess = rev_map(maxi);
        if strcmp(guess, new_label(i,1))
            new_correct = new_correct + 1;
        end
    end
    
    new_accu = new_correct / new_size
    train_accu = train_correct / train_size
end
% naive bayes classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%
% Output:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data 
%
% CS260 2015 Fall, Homework 2
