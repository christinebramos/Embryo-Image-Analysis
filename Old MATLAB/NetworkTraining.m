%Change line X for the training images
%Change line X for the training label images
%Change line X for the pixel IDs
%Change line X for the image/label dimensions
%Change line X for the classes
%Change line X for the trainingOptions
%Uncomment lines X to save the network
%Start from line X if you have a previous network
%Change line X for the testing images
%Change line X for the testing label images
%Change line X to match the MiniBatchSize in training
imageDir = fullfile('/Users/wilzh/Desktop/Fall 2019/Videos/296x296/Images'); %Location of training images
labelDir = fullfile('/Users/wilzh/Desktop/Fall 2019/Videos/296x296/Labels'); %Location of labeled training images

imds = imageDatastore(imageDir); %Function should be given the training images variable above
pixelLabelIds = [1, 2]; %Label 1 is Background, label 2 is Embryo
classNames = ["Background","Embryo"]; %Labels used
pxds = pixelLabelDatastore(labelDir,classNames,pixelLabelIds);
imageSize = [256 256]; %Must be a multiple of 2^D; make sure it matches your images/labels
numClasses = 2; %Embryo, background
lgraph = unetLayers(imageSize, numClasses, 'EncoderDepth', 4);
%Adjust InitialLearnRate, MaxEpochs, MiniBatchSize depending on your computer
options = trainingOptions('adam','InitialLearnRate',1e-4,'MaxEpochs', 20, ...
    'MiniBatchSize', 2, 'Shuffle','every-epoch','CheckpointPath','C:\Users\wilzh\Desktop\Checkpoint', ...
    'Plots','training-progress');
ds = pixelLabelImageDatastore(imds,pxds);
[net,info] = trainNetwork(ds,lgraph,options); 
%test = net;
%save test; %Save network
gpuDevice(1); %Resets GPU CUDA device to free up memory
%load('test.mat', 'net'); %Load the saved neural network
imageDir = fullfile('/Users/wilzh/Desktop/Training Set 1/TestingImages'); %Location of testing images
labelDir = fullfile('/Users/wilzh/Desktop/Training Set 1/TestingLabel'); %Location of testing labeled images
imds = imageDatastore(imageDir);  %Function should be given the training images variable above
pxdsResults = semanticseg(imds, net, 'MiniBatchSize', 6, 'Verbose', false); 
    %Calculate the predicted embryo area; try and match MiniBatchSize to the training
pxdsTruth = pixelLabelDatastore(labelDir,classNames,pixelLabelIds); %Store the labeled data info
ssm = evaluateSemanticSegmentation(pxdsResults,pxdsTruth); %Calculate metrics