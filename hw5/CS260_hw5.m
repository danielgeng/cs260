function CS260_hw5()
    % assume data is in same directory
    load 'splice_train.mat'
    trainf = data;
    trainl = label;
    load 'splice_test.mat'
    testf = data;
    testl = label;
    
    disp('--- 5.1 ---');
    [trainf, testf] = process_data(trainf, testf);
    
    C = [4^-6 4^-5 4^-4 4^-3 4^-2 4^-1 1 4 16];    
        
    disp('--- 5.3a ---');
    for i = 1:length(C)
        [w,b] = trainsvm(trainf, trainl, C(i));
        accu = cross_validation(trainf, trainl, w, b);
        disp(['accuracy: ', num2str(accu)]);
    end
    
    disp('--- 5.3c ---');
    [w,b] = trainsvm(trainf, trainl, 4^-2);
    accu = testsvm(testf, testl, w, b);
    disp(['test accuracy: ', num2str(accu)]);
    
    disp('--- 5.4 ---');
    % renamed svmtrain to svmtrain2 b/c of conflict
    options = '-v 5 -c ';
    for i = 1:length(C)
        tstart = tic;
        svmmodel = svmtrain2(trainl, trainf, [options num2str(C(i))]);
        telapsed = toc(tstart)/5;
        disp(['C: ', num2str(C(i))]);
        disp(['average time ', num2str(telapsed)]);
    end
    
    C = [4^-3 4^-2 4^-1 1 4 16 4^3 4^4 4^5 4^6 4^7];
    disp('--- 5.5a ---');
    degrees = [1 2 3];
    options = '-v 5 -t 1 -c ';
    for i = 1:length(C)
        for j = 1:length(degrees)
            tstart = tic;
            svmmodel = svmtrain2(trainl, trainf, [options num2str(C(i)) ' -d ' num2str(degrees(j))]);
            telapsed = toc(tstart)/5;
            disp(['degree: ', num2str(degrees(j))]);
            disp(['C: ', num2str(C(i))]);
            disp(['average time ', num2str(telapsed)]);
        end
    end
    
    disp('--- 5.5b ---');
    gamma = [4^-7 4^-6 4^-5 4^-4 4^-3 4^-2 4^-1];
    options = '-v 5 -t 2 -c ';
    for i = 1:length(gamma)
        for j = 1:length(C)
            tstart = tic;
            svmmodel = svmtrain2(trainl, trainf, [options num2str(C(j)) ' -g ' num2str(gamma(i))]);
            telapsed = toc(tstart)/5;
            disp(['gamma: ', num2str(gamma(i))]);
            disp(['C: ', num2str(C(j))]);
            disp(['average time ', num2str(telapsed)]);
        end
    end
    
    options = ['-c ' num2str(4) ' -g ' num2str(4^-3)];
    svmmodel = svmtrain2(trainl, trainf, options);
    
    [~, accu, ~] = svmpredict(testl, testf, svmmodel);
    disp(accu);

end
