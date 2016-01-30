function q6_helper(features, labels, test_features, test_labels, type)
    [~, num_features] = size(features);
    
    w0 = zeros(num_features, 1);
    
    [~, ~, ~, w5] = batch_gradient_reg(features, labels, w0, 50, 0.01, 0.05);

    [entr_x, entr_y, l2norm] = newtons_method(features, labels, w5, 50, 0.0);

    hold on;
    plot(entr_x, entr_y, 'Color', [0,0,0]);
    xlabel('Number of steps');
    ylabel('Cross-entropy');

    ttl = strcat(type, ': Newton`s method, Unregularized');

    title(ttl);

    disp(['l2norm: ', num2str(l2norm)]);
    
    [~, entr_y, ~] = newtons_method(test_features, test_labels, w5, 50, 0.0);
    
    disp(['test cross-entropy: ', num2str(entr_y(50))]);

end
