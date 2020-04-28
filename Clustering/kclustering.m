function[cidx] = kclustering(c)
% 
% E = evalclusters(c,'kmeans','DaviesBouldin','klist',[2:5]);
% [kidx,C] = kmeans(c,E.OptimalK);
distM=squareform(pdist(c));
E = 4;
% 
% for i = 1:4
%     [kidx,C] = kmeans(c,i+1,'MaxIter',10000);
%     DI(i) = dunns(i+1, distM, kidx);
%     DBI(i) = Davies_Bouldin(i+1, c, kidx);
% end
% 
% tmpDI = sort(DI, 'descend');
% tmpDBI = sort(DBI);
%     
% for i = 1:4
%     c1 = find(DBI == tmpDBI(i));
%     c2 = find(DI == tmpDI(i));
%     if(c1 == c2)
%         E = c1 + 1;
%         break;
%     end
% end

[kidx,C] = kmeans(c,E,'MaxIter',10000);

d = zeros(1,size(C,1));
for j = 1:size(C,1)
    for i = 1:size(C,2)
        d(j) = d(j) + C(j,i)^2;
    end
end

sorted = sort(d);
cidx = zeros(1,length(kidx));

for i = 1:length(d)
    tmp = find(sorted == d(i));
    for j = 1:length(kidx)
        if(kidx(j) == i)
            cidx(j) = tmp;
        end
    end
end

end
