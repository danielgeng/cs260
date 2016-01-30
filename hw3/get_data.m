function [features, labels] = get_data(file_name)
    file = fopen(file_name);
    
    matrix = [];
    
    line = fgetl(file);
    while ischar(line)
        split = strsplit(line,',');
        matrix = [matrix;split];
        line = fgetl(file);
    end
    
    fclose(file);
    
    sz = size(matrix);
    
    features = [];
    labels = [];
    for i = 1:sz(1,1)
        for j = 1:sz(1,2)-1
            features(i,j) = str2double(matrix(i,j));
        end
        labels = [labels;matrix(i,sz(1,2))];
    end

end
