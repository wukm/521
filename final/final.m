%%% FINAL PROJECT LUKE WUKMER MATH 521
clear all; close all; clc;

cd('/home/luke/Documents/MATLAB');

images = dir('/home/luke/Documents/MATLAB/TIFFtraining/*.tif');

for i = 1:length(images)
    fname = images(i).name;
    train_ids(i,:) = fname; % get the filenames in order just in case
    if any(strfind(fname,'Dog'))
        train_labels(i) = 1;
    elseif any(strfind(fname,'Cat'))
            train_labels(i) = 0;
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

images = dir('/home/luke/Documents/MATLAB/TIFFTesting/*.tif');

for i = 1:length(images)
    fname = images(i).name;
    test_ids(i,:) = fname; % get the filenames in order
    if any(strfind(fname,'Dog'))
        test_labels(i) = 1;
    elseif any(strfind(fname,'Cat'))
        test_labels(i) = 0;
    else
        error('found non cat/dog in testing data');
    end;
    
    tmp = double(imread(fname)); % the actual image matrix
    Xtest(:,i) = tmp(:);
end;



clear fname i tmp

% METHOD ONE--regular SVM with defaults from MATLAB
SVMModel = fitcsvm(Xtrain',train_labels,'KernelFunction', 'rbf');
[test_est, score_test] = predict(SVMModel, Xtest');
% then compare `label' directly with `test_labels'
accuracy_test = [sum(test_est==test_labels')  numel(test_labels)];
[train_est, score_train] = predict(SVMModel, Xtrain');
%accuracy on training set
accuracy_train = [sum(train_est==train_labels') numel(train_labels)];

% get a silly visual output for accuracy
A = double((test_est == test_labels'));
A(end+1:end+2) = .5;

figure(1); montage({images.name}', 'Size', [5 8]);
b = reshape(A, [8,5])';
%figure(2); imagesc(b); axis image; grid on;
figure(2);
[r,c] = size(b);
imagesc((1:c)+0.5,(1:r)+0.5,b);
colormap(gray);
axis equal;
set(gca,'XTick',1:(c+1),'YTick',1:(r+1),...
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');


