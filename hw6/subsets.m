function [xset, yset] = subsets(data, personid, subsetid)
% splits data into pixels and labels based on subset id
    n = size(data, 1);
    xset = {[] [] [] [] []}; % store pixels
    yset = {[] [] [] [] []}; % store personid
    for i = 1:n
        sid = subsetid(i);
        xrow = data(i,:);
        xset{sid} = [xset{sid}; xrow];
        yrow = personid(i);
        yset{sid} = [yset{sid}; yrow];
    end

end
