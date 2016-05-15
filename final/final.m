%%% FINAL PROJECT LUKE WUKMER MATH 521
clear all; close all; clc;
cd('/home/luke/521/final'); % make this portable
images = dir('./TIFFtraining/*.tif');

train_files = { images.name };

for i = 1:length(train_files)
    fname = train_files{i};
    if any(strfind(fname,'Dog'))
        ytrain(:,i) = 1;
    elseif any(strfind(fname,'Cat'))
            ytrain(:,i) = 0;
    else
        error('found noncat/dog in training data');
    end;
    
    tmp = double(imread(fname)); % the actual image matrix
    % there's a bug, one ofthese isn't 2d
    if ndims(tmp) > 2
        tmp = tmp(:,:,1);
    end
    
    Xtrain(:,i) = tmp(:);
end;

images = dir('./TIFFtesting/*.tif');

test_files = { images.name };

for i = 1:length(test_files)
    fname = test_files{i};
    if any(strfind(fname,'Dog'))
        ytest(:,i) = 1;
    elseif any(strfind(fname,'Cat'))
        ytest(:,i) = 0;
    else
        error('found non cat/dog in testing data');
    end;
    
    tmp = double(imread(fname)); % the actual image matrix
    Xtest(:,i) = tmp(:);
end;



clear fname i tmp images

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

