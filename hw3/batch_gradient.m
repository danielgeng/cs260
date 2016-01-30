function [entr_x, entr_y, l2norm] = batch_gradient(features, labels, w0, iterations, step)
    [num_train_samples, num_features] = size(features);
    minval = 1e-16;
    maxval = 1 - minval;
    
    w = w0;

    entr_x = [];
    entr_y = [];
    
    for i = 1:iterations
        temp = zeros(num_features, 1);
        sig = sigmoid(0.1 + (features * w));
        for j = 1:length(sig)
            if sig(1,j) < minval
                sig(1,j) = minval;
            end
            if sig(1,j) > maxval
                sig(1,j) = maxval;
            end
        end
        temp = temp - (features' * (labels - sig'));
        w = w - step * temp;
        
        entropy = 0;
        
        for j = 1:num_train_samples
            sig = sigmoid(0.1 + (features(j,:) * w));
            for k = 1:length(sig)
                if sig(1,k) < minval
                    sig(1,k) = minval;
                end
                if sig(1,k) > maxval
                    sig(1,k) = maxval;
                end
            end
            entropy = entropy - (labels(j) * log(sig) + (1-labels(j)) * log(1-sig));
        end
        
        entr_y = [entr_y; entropy];
        entr_x = [entr_x; i];
    end
    
    l2norm = norm(w, 2);
    
end
