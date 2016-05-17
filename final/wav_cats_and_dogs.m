function [ Xtrain_wav, Xtest_wav, signal_size ] = wav_cats_and_dogs( Xtrain, Xtest )
%WAV_CATS_AND_DOGS Summary of this function goes here
%   Detailed explanation goes here

if exist('wav_cats_and_dogs.mat')
    load('wav_cats_and_dogs.mat', 'Xtrain_wav', 'Xtest_wav','signal_size');
else
    X_all = [Xtrain Xtest];
    for i = 1:size(X_all,2)
        img = reshape(X_all(:,i), [64 64]);
        [C,S] = wavedec2(img,1,'haar');
        X_new(:,i) = C(1:32*32);
        signal_size = S(1,:);
    end;
    
    Xtrain_wav = X_new(:,1:size(Xtrain,2));
    Xtest_wav =X_new(:,size(Xtrain,2)+1:end);
    
    save('wav_cats_and_dogs.mat', 'Xtrain_wav', 'Xtest_wav', 'signal_size');
    
end
end

