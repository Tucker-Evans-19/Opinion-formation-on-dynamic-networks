%finds the level of division in the network. gives the ratio of intragroup
%connections to total number of connections. or if there is only one group
%left then division is set to zero. 

function divi = division(C,X)

indA = find(X(:,1)>=0);
indB = find(X(:,1)<0);

inA=0; %number of connections between nodes of A
inB=0; %number of connections between nodes of B
out=0; %number of cross-group connections

for i=1:size(indA)
    for j=1:size(indA)
        inA = inA +C(indA(i),indA(j));
    end
end

for i=1:size(indB)
    for j=1:size(indB)
        inB = inB +C(indB(i),indB(j));
    end
end

in = (inA + inB)/2; %actual sum of the intra-group connections (not doubled)

for i=1:size(indA)
    for j=1:size(indB)
        out = out + C(indA(i),indB(j));
    end
end



if (size(indA)== [0 1])|(size(indB)== [0 1]) %if one of the groups has no members we have consensus
    divi = 0;
else
    divi = in/(in + out); %ratio of the intragroup connections to the total connections - higher value means higher division
end

end
