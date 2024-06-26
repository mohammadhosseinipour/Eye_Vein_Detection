dataSetDir = "\DRIVE";
imageDir = fullfile(dataSetDir,'Training\images');
labelDir = fullfile(dataSetDir,'Training\1st_manual_copy');

imds = imageDatastore(imageDir);



classNames = ["d","o"];
labelIDs   = [255 0];
pxds = pixelLabelDatastore(labelDir,classNames,labelIDs);

I = read(imds);
C = read(pxds);
C1 = read(pxds);



I = imresize(I,5);
L = imresize(uint8(C{1}),5);
imshowpair(I,L,'montage')


numFilters = 100;
filterSize = 3;
numClasses = 2;
layers = [
    imageInputLayer([584 565 3])
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    maxPooling2dLayer(2,'Stride',1)
    convolution2dLayer(filterSize,numFilters,'Padding',1)
    reluLayer()
    transposedConv2dLayer(4,numFilters,'Stride',1,'Cropping',1);
    convolution2dLayer(1,numClasses);
    softmaxLayer()
    pixelClassificationLayer()
    ];

opts = trainingOptions('sgdm', ...
    'InitialLearnRate',5e-4, ...
    'MaxEpochs',100, ...
    'MiniBatchSize',2);


trainingData = pixelLabelImageDatastore(imds,pxds);


net2 = trainNetwork(trainingData,layers,opts);

testImage = imread("\DRIVE\Test\images\01_test.tif");
imshow(testImage)


C = semanticseg(testImage,net2);

buildingMask = C == 'd';


figure,imshow(buildingMask);
figure,imshow(testImage);
