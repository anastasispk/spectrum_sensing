% function[Pd, Pfa] = sense2(avSNRdB)

%% Scenario

avSNRdB = -12;
scenario.avSNR = 10^(avSNRdB/10);
scenario.Tx = [0, 3*scenario.avSNR/2, 3*scenario.avSNR*(5/6), 3*scenario.avSNR*(7/6), 3*scenario.avSNR*(9/6)]; 
scenario.samples = 3000;
scenario.fading = false;                     % Adds Rayleigh fading to the received signals
M = 5;                          % Sensing slots in a window
W = 5000;                      % Sensing windows

y = zeros(1,M);
c = zeros(W,M);

%% Clustering

train = struct();
S = zeros(1,W);

for w = 1:W
    scenario.TXPower = randsample(scenario.Tx, 1, true, [0.5 0.125 0.125 0.125 0.125]);
    trainingScenario = scenario;
    trainingScenario.realiz = 1; 			% Training samples
    S(w) = find(scenario.Tx == scenario.TXPower);
for m = 1:M
    [train.X,~,~,SNR] = MCS2(trainingScenario);
    x = train.X;
    for i = 1:length(x)
        c(w,m) = c(w,m) + x(i);
    end
end
end

c = normalize(c, 'range');

manifest = struct();

manifest.kmeans = true;
manifest.dbscan = false;
manifest.hclust = false;

idx = clusteralg(manifest, c, W);
wrong = S - idx;
wrong = length(wrong(wrong~=0))/length(wrong);

%% Training

test = struct();
testSamples = 0.25 * W;
y = zeros(testSamples,M);
A = zeros(1,length(testSamples));

for t = 1:testSamples
    scenario.TXPower = randsample(scenario.Tx, 1, true, [0.5 0.125 0.125 0.125 0.125]);
    testScenario = scenario;
    testScenario.realiz = 1;
    A(t) = find(scenario.Tx == scenario.TXPower);
    for m = 1:M
        [test.X, ~, ~, ~] = MCS2(testScenario);
        x = test.X;
        for i = 1:length(x)
            y(t,m) = y(t,m) + x(i);
        end
    end
end

y = normalize(y, 'range');

tr = struct();
te = struct();
te.X = y;
tr.X = c;
% tr.Y = idx;

%% Presence or absence

for i = 1:length(idx)
    if(idx(i) > 1)
        tr.Y(i) = 1;
    else
        tr.Y(i) = -1;
    end
end
model = SVM_dual(tr,te);
[Acc, Pd, Pfa] = metrics(model,A,testSamples);

%% Power recognition

tr.Y = idx;
model = NB(tr,te);

%% Plot

% figure;
% gscatter(c(:,1),c(:,2))
% title('Energy features detected by SU')
% xlabel('1st dimension of y')
% ylabel('2nd dimension of y')
% xlim([0 1])
% ylim([0 1])
% figure;
% gscatter(c(:,1),c(:,2),idx)
% title('Energy features detected by SU (after clustering)')
% xlabel('1st dimension of y')
% ylabel('2nd dimension of y')
% xlim([0 1])
% ylim([0 1])
figure;
gscatter(c(:,1),c(:,2),idx)
hold on
gscatter(y(:,1),y(:,2),model.label)
title('Energy features detected by SU (after classification)')
xlabel('1st dimension of y')
ylabel('2nd dimension of y')
xlim([0 1])
ylim([0 1])

% writematrix(c,'train.csv')



