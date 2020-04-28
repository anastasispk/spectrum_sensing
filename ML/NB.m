function NB = NB(train, test)

NB.model = fitcnb(train.X,train.Y);
[NB.label,NB.P,~] = predict(NB.model,test.X);
NB.name = 'NB';
