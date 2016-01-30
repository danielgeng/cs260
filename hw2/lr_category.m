function [cate_features, cate_labels] = lr_category(file_name)
    file = fopen(file_name);
    matrix = [];

    line = fgetl(file);
    while ischar(line)
        split = strsplit(line,',');
        matrix = [matrix;split];
        line = fgetl(file);
    end
    
    cate_features = [];
    cate_labels = [];
    
    sz = size(matrix);
    for i = 1:sz(1,1)
        row = zeros(1,sz(1,2)-1);
        for j = 1:sz(1,2)
            switch j
                case 1
                    %buying
                    if strcmp(matrix(i,j), 'vhigh')
                        row(1,j) = 1;
                    elseif strcmp(matrix(i,j), 'high')
                        row(1,j) = 2;
                    elseif strcmp(matrix(i,j), 'med')
                        row(1,j) = 3;
                    elseif strcmp(matrix(i,j), 'low')
                       row(1,j) = 4;
                    end
                case 2
                    %maint
                    if strcmp(matrix(i,j), 'vhigh')
                        row(1,j) = 1;
                    elseif strcmp(matrix(i,j), 'high')
                        row(1,j) = 2;
                    elseif strcmp(matrix(i,j), 'med')
                        row(1,j) = 3;
                    elseif strcmp(matrix(i,j), 'low')
                       row(1,j) = 4;
                    end
                case 3
                    %doors
                    if strcmp(matrix(i,j), '2')
                        row(1,j) = 1;
                    elseif strcmp(matrix(i,j), '3')
                        row(1,j) = 2;
                    elseif strcmp(matrix(i,j), '4')
                        row(1,j) = 3;
                    elseif strcmp(matrix(i,j), '5more')
                       row(1,j) = 4;
                    end
                case 4
                    %persons
                    if strcmp(matrix(i,j), '2')
                        row(1,j) = 1;
                    elseif strcmp(matrix(i,j), '4')
                        row(1,j) = 2;
                    elseif strcmp(matrix(i,j), 'more')
                        row(1,j) = 3;
                    end
                case 5
                    %lug_boot
                    if strcmp(matrix(i,j), 'small')
                        row(1,j) = 1;
                    elseif strcmp(matrix(i,j), 'med')
                        row(1,j) = 2;
                    elseif strcmp(matrix(i,j), 'big')
                        row(1,j) = 3;
                    end
                case 6
                    %safety
                    if strcmp(matrix(i,j), 'low')
                        row(1,j) = 1;
                    elseif strcmp(matrix(i,j), 'med')
                        row(1,j) = 2;
                    elseif strcmp(matrix(i,j), 'high')
                        row(1,j) = 3;
                    end
                case 7
                    if strcmp(matrix(i,j), 'unacc')
                        cate_labels = [cate_labels;1];
                    elseif strcmp(matrix(i,j), 'acc')
                        cate_labels = [cate_labels;2];
                    elseif strcmp(matrix(i,j), 'good')
                        cate_labels = [cate_labels;3];
                    elseif strcmp(matrix(i,j), 'vgood')
                        cate_labels = [cate_labels;4];
                    end
            end
        end
        cate_features = [cate_features;row];
    end

end
