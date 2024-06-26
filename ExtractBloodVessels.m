Dir = "\DRIVE\Training\images";

imds = imageDatastore(Dir);

 s=size(imds.Files,1);
for i=1:s
    inImg=imread(cell2mat(imds.Files(i)));
    dim = ndims(inImg);
    if(dim == 3)
    %Input is a color image
        inImg = rgb2gray(inImg);
    end
    Threshold = 10;
    bloodVessels = VesselExtract(inImg, Threshold);
    %Output Blood Vessels image
    figure;
    subplot(121);imshow(inImg);title('Input Image');
    subplot(122);imshow(bloodVessels);title('Extracted Blood Vessels');



    pause;
%     title('Labeled Image')
%     imwrite(I,strcat("\DRIVE\Training\1st_manual_copy\", "Test" ,num2str(i) ,".tif"))
%     imshow(I);

end
%
% inImg = imread('Input.bmp');
% dim = ndims(inImg);
% if(dim == 3)
%     %Input is a color image
%     inImg = rgb2gray(inImg);
% end
% %Extract Blood Vessels
% Threshold = 10;
% bloodVessels = VesselExtract(inImg, Threshold);
% %Output Blood Vessels image
% figure;
% subplot(121);imshow(inImg);title('Input Image');
% subplot(122);imshow(bloodVessels);title('Extracted Blood Vessels');
