function SVM = SVM_dual(train,test)

SVM.model = fitcsvm(train.X,train.Y,'KKTTolerance',1e-2,'KernelFunction','gaussian');
[SVM.label,SVM.P,~] = predict(SVM.model,test.X);
SVM.name = 'SVM';

end

