function SVM = SVM(train,test)

t = templateSVM('Standardize',true,'KernelFunction','gaussian');
SVM.model = fitcecoc(train.X,train.Y,'Learners',t,'FitPosterior',true,'Verbose',2);
[SVM.label,SVM.P,~] = predict(SVM.model,test.X);
SVM.name = 'SVM';

end