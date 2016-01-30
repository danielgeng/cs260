function q4b_helper(features, labels)
    [num_training, num_features] = size(features);
    
    w0 = zeros(num_features, 1);
    
    steps = [0.001, 0.01, 0.05, 0.1, 0.5];
    regs = [];
    for i=0:0.05:0.5
        regs = [regs, i];
    end
    
    for i = 1:length(steps)
        for j = 1:length(regs)
    
            [entr_x, entr_y, l2norm] = batch_gradient_reg(features, labels, w0, 50, steps(i), regs(j));
            
            if steps(i) == 0.01
                disp(['reg_coeff: ', num2str(regs(j)), ' l2norm: ', num2str(l2norm)]);
            end

        end
    end

end
