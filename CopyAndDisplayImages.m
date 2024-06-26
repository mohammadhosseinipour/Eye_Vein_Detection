Dir = "\DRIVE\Training\1st_manual";

imds = imageDatastore(Dir);

 s=size(imds.Files,1);
for i=1:s
    I=imread(cell2mat(imds.Files(i)));
    imwrite(I,strcat("\DRIVE\Training\1st_manual_copy\", "Test" ,num2str(i) ,".tif"))
    imshow(I);

end
