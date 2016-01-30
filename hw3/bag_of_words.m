function [total_count, labels] = bag_of_words(dictionary, ham_dir, spam_dir)
    file = fopen(dictionary);
    
    word_map = containers.Map('KeyType', 'char', 'ValueType', 'single');
    idx_map = containers.Map('KeyType', 'char', 'ValueType', 'single');
    
    line = fgetl(file);
    idx = 1;
    while ischar(line)
        split = strsplit(line);
        word_map(char(split(1))) = 0;
        idx_map(char(split(1))) = idx;
        idx = idx + 1;
        line = fgetl(file);
    end
    
    files = dir(strcat(spam_dir,'*.txt'));
    
    total_count = [];
    %spam = 1, ham = 0
    labels = [];

    for i = 1:length(files)
        file = fopen(strcat(spam_dir, files(i).name));
        counts = zeros(1, length(idx_map));
        line = fgetl(file);
        while ischar(line)
            split = strsplit(line,{' ', ',', '.', '?'});
            sz = size(split);
            for j = 1:sz(1,2)
                if (isKey(word_map, char(split(1,j))))
                    word_map(char(split(j))) = word_map(char(split(j))) + 1;
                    counts(idx_map(char(split(j)))) = counts(idx_map(char(split(j)))) + 1;
                end
            end
            line = fgetl(file);
        end
        ttl = sum(counts);
        if ttl ~= 0
            counts = counts / ttl;
        end
        total_count = [total_count; counts];
        labels = [labels; 0];
        fclose(file);
    end
    
    files = dir(strcat(ham_dir,'*.txt'));

    for i = 1:length(files)
        file = fopen(strcat(ham_dir, files(i).name));    
        counts = zeros(1, length(idx_map));
        line = fgetl(file);
        while ischar(line)
            split = strsplit(line,{' ', ',', '.', '?'});
            sz = size(split);
            for j = 1:sz(1,2)
                if (isKey(word_map, char(split(1,j))))
                    word_map(char(split(j))) = word_map(char(split(j))) + 1;
                    counts(idx_map(char(split(j)))) = counts(idx_map(char(split(j)))) + 1;
                end
            end
            line = fgetl(file);
        end
        ttl = sum(counts);
        if ttl ~= 0
            counts = counts / ttl;
        end
        total_count = [total_count; counts];
        labels = [labels; 1];
        fclose(file);
    end
    
    keyset = word_map.keys;
    valueset = cell2mat(word_map.values);
    [sortval, sortidx] = sort(valueset(:), 'descend');
    most_common = [ keyset(1, sortidx(1)) sortval(1);
               keyset(1, sortidx(2)) sortval(2);
               keyset(1, sortidx(3)) sortval(3)]
end
