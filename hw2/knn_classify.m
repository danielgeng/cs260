function [new_accu, train_accu] = knn_classify(train_data, train_label, new_data, new_label, k)
    train_correct = 0;
    new_correct = 0;
    
    train_size = size(train_data);
    new_size = size(new_data);
    
    feature_names = unique(train_label);
    num_features = size(feature_names);
    num_features = num_features(1,1);
    
    %training data using leave-one-out
    for i = 1:train_size(1,1)
        count = zeros([1, num_features]);
        map = containers.Map(feature_names, count);
        tempd = train_data;
        curr = tempd(i,:);
        tempd(i,:) = [];
        [dist, idx] = pdist2(tempd, curr, 'euclidean', 'Smallest', k);
        for j = 1:k
            class = char(train_label(idx(j,1)));
            for f = 1:num_features
                if strcmp(class, char(feature_names(f)))
                    map(char(feature_names(f))) = map(char(feature_names(f))) + 1;
                end
            end
        end
        [maximum, maxi] = max(cell2mat(map.values));
        guess = feature_names{maxi};
        if strcmp(train_label(i), guess)
            train_correct = train_correct + 1;
        end
    end
    
    [dist, idx] = pdist2(train_data, new_data, 'euclidean', 'Smallest', k);
    
    %new data
    for i = 1:new_size(1,1)
        count = zeros([1, num_features]);
        map = containers.Map(feature_names, count);
        for j = 1:k
            class = char(train_label(idx(j,i)));
            for f = 1:num_features
                if strcmp(class, char(feature_names(f)))
                    map(char(feature_names(f))) = map(char(feature_names(f))) + 1;
                end
            end
        end
        [maximum, maxi] = max(cell2mat(map.values));
        guess = feature_names{maxi};
        if strcmp(new_label(i), guess)
            new_correct = new_correct + 1;
        end
    end
    
    new_accu = (new_correct / new_size(1,1));
    train_accu = (train_correct / train_size(1,1));
end

% k-nearest neighbor classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%  k: number of nearest neighbors
%
% Output:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data (using leave-one-out
%  strategy)
%
% CS260 2015 Fall, Homework 1
