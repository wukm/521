%%% FINAL PROJECT LUKE WUKMER MATH 521
clear all; close all; clc;
cd('/home/luke/521/final'); % make this portable

[Xtrain, ytrain, Xtest, ytest, train_files, test_files] = load_cats_and_dogs;

% mean subtract training set and testing set (independently)
Xtrain = bsxfun(@minus, Xtrain, mean(Xtrain, 2));
Xtest = bsxfun(@minus, Xtest, mean(Xtest,2));

[Xtrain_lp, Xtest_lp] = lp_cats_and_dogs(Xtrain,Xtest);
Xtrain = Xtrain - Xtrain_lp;
Xtest = Xtest - Xtest_lp;

% METHOD ONE--regular SVM with defaults from MATLAB
SVMModel = fitcsvm(Xtrain',ytrain);
[test_est, score_test] = predict(SVMModel, Xtest');
test_est = test_est'; % transpose estimated labels (so same shape)
% then compare `label' directly with `test_labels'
accuracy_test = [sum(test_est==ytest)  numel(ytest)];
[train_est, score_train] = predict(SVMModel, Xtrain');
train_est = train_est';
%accuracy on training set
accuracy_train = [sum(train_est==ytrain) numel(ytrain)];

% get a silly visual output for accuracy
A = double((test_est == ytest));
A(end+1:end+2) = .5;

figure(1); montage(test_files', 'Size', [5 8]);
b = reshape(A, [8,5])';

figure(2);
[r,c] = size(b);
imagesc((1:c)+0.5,(1:r)+0.5,b);
colormap(gray);
axis equal;
set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
clear r c b A

% get confusion matrix for this method
tmp = ytest + test_est;
confusion_matrix = [ sum(tmp==2) sum(tmp==1 & ytest==0); ...
                   sum(tmp==1 & ytest==1) sum(tmp==0)];

