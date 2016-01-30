function [encoded_features, encoded_labels] = one_hot_encode(file_name)
    file = fopen(file_name);
    matrix = [];

    line = fgetl(file);
    while ischar(line)
        split = strsplit(line,',');
        matrix = [matrix;split];
        line = fgetl(file);
    end

    sz = size(matrix);
    for i = 1:sz(1,1)
        for j = 1:sz(1,2)
            switch j
                case 1
                    %buying
                    if strcmp(matrix(i,j), 'vhigh')
                        matrix(i,j) = {'1000'};
                    elseif strcmp(matrix(i,j), 'high')
                        matrix(i,j) = {'0100'};
                    elseif strcmp(matrix(i,j), 'med')
                        matrix(i,j) = {'0010'};
                    elseif strcmp(matrix(i,j), 'low')
                       matrix(i,j) = {'0001'};
                    end
                case 2
                    %maint
                    if strcmp(matrix(i,j), 'vhigh')
                        matrix(i,j) = {'1000'};
                    elseif strcmp(matrix(i,j), 'high')
                        matrix(i,j) = {'0100'};
                    elseif strcmp(matrix(i,j), 'med')
                        matrix(i,j) = {'0010'};
                    elseif strcmp(matrix(i,j), 'low')
                       matrix(i,j) = {'0001'};
                    end
                case 3
                    %doors
                    if strcmp(matrix(i,j), '2')
                        matrix(i,j) = {'1000'};
                    elseif strcmp(matrix(i,j), '3')
                        matrix(i,j) = {'0100'};
                    elseif strcmp(matrix(i,j), '4')
                        matrix(i,j) = {'0010'};
                    elseif strcmp(matrix(i,j), '5more')
                       matrix(i,j) = {'0001'};
                    end
                case 4
                    %persons
                    if strcmp(matrix(i,j), '2')
                        matrix(i,j) = {'100'};
                    elseif strcmp(matrix(i,j), '4')
                        matrix(i,j) = {'010'};
                    elseif strcmp(matrix(i,j), 'more')
                        matrix(i,j) = {'001'};
                    end
                case 5
                    %lug_boot
                    if strcmp(matrix(i,j), 'small')
                        matrix(i,j) = {'100'};
                    elseif strcmp(matrix(i,j), 'med')
                        matrix(i,j) = {'010'};
                    elseif strcmp(matrix(i,j), 'big')
                        matrix(i,j) = {'001'};
                    end
                case 6
                    %safety
                    if strcmp(matrix(i,j), 'low')
                        matrix(i,j) = {'100'};
                    elseif strcmp(matrix(i,j), 'med')
                        matrix(i,j) = {'010'};
                    elseif strcmp(matrix(i,j), 'high')
                        matrix(i,j) = {'001'};
                    end
            end
        end
    end

    encoded_features = [];

    features = {'buying_vhigh', 'buying_high', 'buying_med', 'buying_low',...
        'maint_vhigh', 'maint_high', 'maint_med', 'maint_low',...
        'doors_2', 'doors_3', 'doors_4', 'doors_5more',...
        'persons_2', 'persons_3', 'persons_more',...
        'lugboot_small', 'lugboot_med', 'lugboot_big',...
        'safety_low', 'safety_med', 'safety_high'};
    
    labels = {'class_unacc', 'class_acc', 'class_good', 'class_vgood'};

    sz2 = size(features);
    
    encoded_labels = [];

    for i = 1:sz(1,1)
        string = '';
        row = zeros([1, sz2(1,2)]);
        for j = 1:sz(1,2)-1
            string = strcat(string,matrix(i,j));
        end
        tmp = cellstr(reshape(char(string),1,[])');
        for k = 1:size(tmp)
            if str2double(tmp(k)) == 1
                row(1,k) = 1;
            end
        end
        encoded_features = [encoded_features; row];
        encoded_labels = vertcat(encoded_labels, matrix(i, 7));
    end
end
