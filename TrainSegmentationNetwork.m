Dir="\DRIVE";
imDir = fullfile(Dir,'Test','images');
imds = imageDatastore(imDir);
test_size=size(imds.Files);
% for i=1:test_size
%     I = readimage(imds,i);
%
%     imshow(I);
%     pause;
%
% end

I = readimage(imds,1);
figure
imshow(I)

classNames = ["other" "drive"];

pixelLabelID = [1 2];

pxDir = fullfile(Dir,'Test','1st_manual');

pxds = pixelLabelDatastore(pxDir,classNames,pixelLabelID);

cc=imread("\DRIVE\Test\2nd_manual\01_manual2.gif");
C = readimage(pxds,1);
figure
imshow(cc)

B = labeloverlay(I,cc);
figure
imshow(B)




buildingMask = cc == 1;

figure
imshowpair(I, buildingMask,'montage')

inputSize = [32 32 3];
imgLayer = imageInputLayer(inputSize)


filterSize = 3;
numFilters = 32;
conv = convolution2dLayer(filterSize,numFilters,'Padding',1);
relu = reluLayer();





poolSize = 2;
maxPoolDownsample2x = maxPooling2dLayer(poolSize,'Stride',2);


downsamplingLayers = [
    conv
    relu
    maxPoolDownsample2x
    conv
    relu
    maxPoolDownsample2x
    ]


filterSize = 4;
transposedConvUpsample2x = transposedConv2dLayer(4,numFilters,'Stride',2,'Cropping',1);


upsamplingLayers = [
    transposedConvUpsample2x
    relu
    transposedConvUpsample2x
    relu
    ]

numClasses = 2;
conv1x1 = convolution2dLayer(1,numClasses);


finalLayers = [
    conv1x1
    softmaxLayer()
    pixelClassificationLayer()
    ]



net = [
    imgLayer
    downsamplingLayers
    upsamplingLayers
    finalLayers
    ]


trainNetwork()
