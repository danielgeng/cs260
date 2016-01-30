function [ptrainf, ptestf] = process_data(trainf, testf)
    [num_train, ~] = size(trainf);
    [num_test, ~] = size(testf);
    means = mean(trainf);
    stddev = std(trainf);
    
    ptrainf = trainf;
    ptestf = testf;
    
    for i=1:num_train
        ptrainf(i,:) = ptrainf(i,:) - means;
        ptrainf(i,:) = ptrainf(i,:) ./ stddev;
    end
    
    
    for i=1:num_test
        ptestf(i,:) = ptestf(i,:) - means;
        ptestf(i,:) = ptestf(i,:) ./ stddev;
    end
    
    testmeans = mean(testf);
    teststddev = std(testf);
    
    disp(['3rd feature - mean: ', num2str(testmeans(3)), ', stddev: ', num2str(teststddev(3))]);
    disp(['10th feature - mean: ', num2str(testmeans(10)), ', stddev: ', num2str(teststddev(10))]);
end
