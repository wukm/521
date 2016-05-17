function [ Xtrain, ytrain, Xtest, ytest, train_files, test_files ] = load_cats_and_dogs
%LOAD_CATS_AND_DOGS load training & testing data for cats and dogs problem
%   load X,y for test and train. use existing file if that exists
%   this assumes you are in the correct current directory.
%   maybe learning about structs would make this easier?

%% if mat file exists, just load that
sprintf('i am here');
if exist('catsanddogs.mat') == 2
    load catsanddogs;
    sprintf('found file. loading');
else
    sprintf('recreating from scratch');
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

    save('catsanddogs.mat', 'Xtrain', 'ytrain', 'Xtest', 'ytest', ...
                            'train_files', 'test_files');
end            
end
