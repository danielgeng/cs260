function [w,b] = trainsvm(train_data, train_label, C)
% Train linear SVM (primal form)
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  C: tradeoff parameter (on slack variable side)
%
% Output:
%  w: feature vector (column vector)
%  b: bias term
%   
    tstart = tic;
    [ns, nf] = size(train_data);

    K = train_data * train_data';
    H = (train_label * train_label') .* K + 1e-5*eye(ns);
    f = repmat(1,ns,1);
    lb = repmat(0,ns,1);
    ub = repmat(C,ns,1);
    Aeq = train_label';
    beq = 0;
    options = optimset('Display', 'off');
    alpha = quadprog(H, -f, [], [], Aeq, beq, lb, ub, [], options);
    tmp = sum(repmat(alpha .* train_label, 1, ns) .* K, 1)';
    bpos = find(alpha > 1e-6);
    b = mean(train_label(bpos) - tmp(bpos));
    w = sum(repmat(alpha .* train_label, 1, nf) .* train_data, 1);
    
    telapsed = toc(tstart);
    disp(['C: ', num2str(C)]);
    disp(['total time: ', num2str(telapsed)]);

end
