function accu = cross_validation(data, labels, w, b)
    ns = size(data,1);
    k = 5;
    xsets = [];
    ysets = [];
    nps = ns/k;
    for i = 1:nps:ns
        xset = data(i:i+nps-1,:);
        yset = labels(i:i+nps-1);
        xsets = cat(3, xsets, xset);
        ysets = [ysets yset];
    end
    sets = size(xsets,3);
    accs = [];
    for i = 1:sets
        accs = [accs testsvm(xsets(:,:,i),ysets(:,i),w,b)];
    end
    accu = mean(accs);

end
