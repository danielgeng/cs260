function [data, personid, subsetid] = process_data(image_file)
% convert images to vectors (1 sample per row)
    file = load(image_file);
    [~, num_samples] = size(file.image);
    personid = file.personID';
    subsetid = file.subsetID';
    data = [];
    for i = 1:num_samples
        img = cell2mat(file.image(i));
        [~, num_cols] = size(img);
        row = [];
        for j = 1:num_cols
            row = [row img(:,j)']; % columns first, otherwise they will be displayed rotated
        end
        data = [data; row];
    end

end
