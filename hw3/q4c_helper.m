function q4c_helper(train_features, train_labels, test_features, test_labels, type)
    [num_training, num_features] = size(train_features);
    
    w0 = zeros(num_features, 1);
    
    steps = [0.001, 0.01, 0.05, 0.1, 0.5];
    regs = [];
    for i=0:0.05:0.5
        regs = [regs, i];
    end
    
    for i = 1:length(steps)
        train_y = [];
        test_y = [];
        for j = 1:length(regs)
    
            [entr_x, entr_y, l2norm] = batch_gradient_reg(train_features, train_labels, w0, 50, steps(i), regs(j));
            
            train_y = [train_y; entr_y(50)];
            
            [entr_x, entr_y, l2norm] = batch_gradient_reg(test_features, test_labels, w0, 50, steps(i), regs(j));
            
            test_y = [test_y; entr_y(50)];
        end

        hold on;
        plot(regs, train_y, 'Color', [0, 0, 0], 'Marker', 'o', 'MarkerSize', 10);
        plot(regs, test_y, 'Color', [0, 0, 0], 'Marker', 's', 'MarkerSize', 10);
        xlabel('Regularization coefficient', 'FontSize', 12);
        ylabel('Cross-entropy at 50 iterations', 'FontSize', 12);
        
        legend('Training','Test','Location','southoutside','Orientation','horizontal','FontSize',12,'FontWeight','bold');

        ttl = strcat(type, ': Regularized Cross-entropy, step size:', {' '}, num2str(steps(i)));

        title(ttl, 'FontSize', 14);

        if steps(i) == 0.01
            disp(['step size: ', num2str(steps(i)), ' l2norm: ', num2str(l2norm)]);
        end

        uiwait;
    end

end
