function q3_helper(features, labels, type)
    [num_training, num_features] = size(features);
    
    w0 = zeros(num_features, 1);
    
    steps = [0.001, 0.01, 0.05, 0.1, 0.5];
    
    for i = 1:length(steps)

        [entr_x, entr_y, l2norm] = batch_gradient(features, labels, w0, 50, steps(i));

        hold on;
        plot(entr_x, entr_y);
        xlabel('Number of steps');
        ylabel('Cross-entropy');

        ttl = strcat(type, ': Unregularized Cross-entropy, step size:', {' '}, num2str(steps(i)));

        title(ttl);

        disp(['step size: ', num2str(steps(i)), ' l2norm: ', num2str(l2norm)]);

        uiwait;

    end

end
