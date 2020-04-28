function[Acc, Pd, Pfa] = metrics(model,A,testSamples)

for i = 1:length(A)
    if(A(i) > 1)
        A(i) = 1;
    else
        A(i) = -1;
    end
end

Acc = (1 - length(find((A'-model.label)~=0))/testSamples)*100;

% Pd = length(find(model.label ~= 1))/length(find(A ~= 1));
tmp = find(model.label ~= 1);
% counter = 0;
% for i = 1:length(tmp)
%     if(A(tmp(i)) ~= model.label(tmp(i)))
%         counter = counter + 1;
%     end
% end
% Pd = 1 - counter/length(find(A ~= 1));

% Pfa = length(find(model.label ~= 1))/length(find(A == 1));

status = model.label;
detected = (A' - status == 0);
% falseAlarm = logical(A' - status);
Pd = sum(detected)/length(A);
% Pfa = sum(falseAlarm)/(length(A)-length(A(A>1)));

counter = 0;
for i = 1:length(tmp)
    if(A(tmp(i)) == 1)
        counter = counter + 1;
    end
end
Pfa = counter/length(tmp);


end