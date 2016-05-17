function [ Xtrain_edges, Xtest_edges ] = lp_cats_and_dogs(Xtrain, Xtest)
%LP_CATS_AND_DOGS Summary of this function goes here
%   Detailed explanation goes here

if exist('lp_cats_and_dogs.mat')
    load('lp_cats_and_dogs.mat', 'Xtrain_edges', 'Xtest_edges');
else
    lp_filter = [ 1 1 1 ; 1 -8 1 ; 1 1 1 ];
    X_all = [Xtrain Xtest];
    for i = 1:size(X_all,2)
        img = reshape(X_all(:,i), [64 64]);
        edge = conv2(lp_filter, img);
        edge = edge(2:end-1, 2:end-1); % remove padding
        X_all(:,i) = edge(:);
    end;
    
    Xtrain_edges = X_all(:,1:size(Xtrain,2));
    Xtest_edges =X_all(:,size(Xtrain,2)+1:end);
    
    save('lp_cats_and_dogs.mat', 'Xtrain_edges', 'Xtest_edges');
    
end

