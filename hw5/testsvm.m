function accu = testsvm(test_data, test_label, w, b)
% Test linear SVM 
% Input:
%  test_data: M*D matrix, each row as a sample and each column as a
%  feature
%  test_label: M*1 vector, each row as a label
%  w: feature vector 
%  b: bias term
%
% Output:
%  accu: test accuracy (between [0, 1])
%
    ns = size(test_data, 1);
    correct = 0;
    for i = 1:ns
        guess = sign(w * (test_data(i,:))' + b);
        if(guess == test_label(i))
            correct = correct + 1;
        end
    end
    accu = correct / ns;
end
