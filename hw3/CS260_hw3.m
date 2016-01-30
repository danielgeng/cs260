function CS260_hw3()
    %Data setup
    [i_train_features, labels] = get_data('hw3_data/ionosphere/ionosphere_train.dat');
    i_train_labels = [];
    for i = 1:length(labels)
        if(strcmp(labels(i), 'g'))
            i_train_labels = [i_train_labels; 0];
        else
            i_train_labels = [i_train_labels; 1];
        end
    end
    [i_test_features, labels] = get_data('hw3_data/ionosphere/ionosphere_test.dat');
    i_test_labels = [];
    for i = 1:length(labels)
        if(strcmp(labels(i), 'g'))
            i_test_labels = [i_test_labels; 0];
        else
            i_test_labels = [i_test_labels; 1];
        end
    end

    dictionary = 'hw3_data/spam/dic.dat';
    train_ham_dir = 'hw3_data/spam/train/ham/';
    train_spam_dir = 'hw3_data/spam/train/spam/';
    test_ham_dir = 'hw3_data/spam/test/ham/';
    test_spam_dir = 'hw3_data/spam/test/spam/';
    
    %Question 1 - takes around 30 seconds
    [e_train_features, e_train_labels] = bag_of_words(dictionary, train_ham_dir, train_spam_dir);
    [e_test_features, e_test_labels] = bag_of_words(dictionary, test_ham_dir, test_spam_dir);
    
    %Question 3 - function proceeds as plots are closed
    q3_helper(i_train_features, i_train_labels, 'Ionosphere');
    q3_helper(e_train_features, e_train_labels, 'EmailSpam');
    
    %Question 4a - function proceeds as plots are closed
    q4a_helper(i_train_features, i_train_labels, 'Ionosphere');
    q4a_helper(e_train_features, e_train_labels, 'EmailSpam');
    
    %Question 4b
    q4b_helper(i_train_features, i_train_labels);
    q4b_helper(e_train_features, e_train_labels);
    
    %Question 4c - function proceeds as plots are closed
    q4c_helper(i_train_features, i_train_labels, i_test_features, i_test_labels, 'Ionosphere');
    q4c_helper(e_train_features, e_train_labels, e_test_features, e_test_labels, 'EmailSpam');
    
    %Question 6 - function proceeds as plots are closed
    q6_helper(i_train_features, i_train_labels, i_test_features, i_test_labels, 'Ionosphere');
    q6_helper(e_train_features, e_train_labels, e_test_features, e_test_labels, 'EmailSpam');
    
    %Question 7 - function proceeds as plots are closed
    q7_helper(i_train_features, i_train_labels, i_test_features, i_test_labels, 'Ionosphere');
    q7_helper(e_train_features, e_train_labels, e_test_features, e_test_labels, 'EmailSpam');
end
