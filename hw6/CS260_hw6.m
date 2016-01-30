function CS260_hw6()
    %{
        Daniel Geng
        ID: 504588536
        12/1/15
    %}
    
    % turn images into vectors
    [data, personid, subsetid] = process_data('face_data.mat');
    
    % question 3c
    d = 200;
    evecs = pca_fun(data, d);
    num_efaces = 5;
    for i = 1:num_efaces
        subplot(1, num_efaces, i);
        eface = reshape(evecs(:,i),50,50);
        imshow(eface, []);
    end
    
    % question 3d
    [xset, yset] = subsets(data, personid, subsetid);
    sets = size(xset, 2);
    
    dvals = [20, 50, 100, 200];
    for d = dvals
        taccu = 0;
        for i = 1:sets
            train_x = [];
            train_y = [];
            test_x = xset{i};
            test_y = yset{i};
            for j = 1:sets
                if j ~= i
                    train_x = [train_x; xset{j}];
                    train_y = [train_y; yset{j}];
                end
            end
            evecs = pca_fun(train_x, d);
            proj = train_x * evecs;
            proj = double(proj);
            % change c as needed
            svm = svmtrain2(train_y, proj, '-c 4 -q');
            test_x = test_x * evecs;
            test_x = double(test_x);
            [~, accu, ~] = svmpredict(test_y, test_x, svm, '-q');
            taccu = taccu + accu(1);
        end
        disp(['d = ', num2str(d), ', accuracy = ', num2str(taccu / (sets * 100))]);
    end

end
