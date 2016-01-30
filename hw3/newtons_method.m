function [entr_x, entr_y, l2norm] = newtons_method(features, labels, w0, iterations, reg)
    [num_train_samples, ~] = size(features);
    w = w0;
    
    minval = 1e-16;
    maxval = 1 - minval;
    
    entr_x = [];
    entr_y = [];
    
    for i = 1:iterations
        grad = 0;
        h = 0;
        for j = 1:num_train_samples
            sig = sigmoid(features(j,:) * w);
            if sig < minval
                sig = minval;
            elseif sig > maxval
                sig = maxval;
            end
            grad = grad + (sig - labels(j)) * features(j,:);
            h = h + sig * (1-sig) * features(j,:) * features(j,:)';
        end
        grad = grad / num_train_samples;
        h = h / num_train_samples;
        w = w - (2 * reg * w) - (inv(h) * grad');
        
        entropy = 0;
        
        for j = 1:num_train_samples
            sig = sigmoid(features(j,:) * w);
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
