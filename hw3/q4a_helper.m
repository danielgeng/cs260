function q4a_helper(features, labels, type)
    [num_training, num_features] = size(features);
    
    w0 = zeros(num_features, 1);
    
    steps = [0.001, 0.01, 0.05, 0.1, 0.5];
    regs = [0.1];
    
    for i = 1:length(steps)
        for j = 1:length(regs)
    
            [entr_x, entr_y, l2norm] = batch_gradient_reg(features, labels, w0, 50, steps(i), regs(j));

            hold on;
            plot(entr_x, entr_y);
            xlabel('Number of steps');
            ylabel('Cross-entropy');

            ttl = strcat(type, ': Regularized Cross-entropy, step size:', {' '}, num2str(steps(i)), ', lambda: ', {' '}, num2str(regs(j)));

            title(ttl);
            uiwait;
            
        end
    end

end
