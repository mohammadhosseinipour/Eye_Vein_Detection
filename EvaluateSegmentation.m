clear

Dir = "\DRIVE\Training\images";

Dir_mask="\DRIVE\Training\mask";

Dir_ans="\DRIVE\Training\1st_manual_copy";

imds = imageDatastore(Dir);
masks=imageDatastore(Dir_mask);
anss=imageDatastore(Dir_ans);
 s=size(imds.Files,1);

 sensitivitys=zeros(max(max(20)),1);
 specificitys=zeros(max(max(20)),1);
 accs=zeros(max(max(20)),1);

for i=1:20
    I=imread(strcat("\DRIVE\Test\images\",num2str(i, "%02.0f"),"_test.tif"));
    mask=im2double(imread(strcat("\DRIVE\Test\mask\",num2str(i, "%02.0f"),"_test_mask.gif")));
    
    anser=im2double(imread(strcat("\DRIVE\Test\1st_manual\",num2str(i, "%02.0f"),"_manual1.gif")));


    [Gmag, Gaz, Gelev] = imgradient3(I,'central');
%     figure,
%     imshow([I Gmag],[])
%     figure,
%     imshow([Gmag(:,:,1) Gmag(:,:,2) Gmag(:,:,3)],[]);
    R=Gmag(:,:,1);
    G=Gmag(:,:,2);
    B=Gmag(:,:,3)/max(max(Gmag(:,:,3)));
    thresh = multithresh(B,10);
    quant_AB = imquantize(B,thresh);
%     figure,
%     imshow([B]);
    S=imfilter(B,fspecial('average',[20 20]));
%     S2=imfilter(B,fspecial('gaussian',[100 100]));

    K=0.95;
    T=K*S;

%     TT=K*S2;
%     YY=B>TT;

    BW = edge(B,'Canny');

    Y=B>T;
    YY=(1-Y).*(mask);
    Q=medfilt2(Y,[5 5]);

    SE=(1-Q).*(mask);

    YYY=YY.*(1-BW);
%     SE2=SE-
    QY=medfilt2(YYY,[5 5]);


    LL = bwlabel(SE,8);
    maxll=max(max(LL));
    for j=1:maxll
        if sum(sum(LL==j))<50
            LL=LL-(LL==j).*j;
        end
    end

    maxll=max(max(LL));
    LL2=zeros(size(LL));
    for j=1:maxll

            LL2=LL2+(LL==j);

    end


    LLL = bwlabel(QY,8);
    maxll=max(max(LLL));
    for j=1:maxll
        if sum(sum(LLL==j))<2
            LLL=LLL-(LLL==j).*j;
        end
    end

    maxll=max(max(LLL));
    LLLL=zeros(size(LLL));
    for j=1:maxll

            LLLL=LLLL+(LLL==j);

    end




%     LLLL.*(1-LL2)+
    goal=(1-LLLL).*(LL2)+(LLLL).*(LL2);
%     figure,imshow([Y T (1-Q).*(mask); LL2 B anser;BW YY YYY;QY LLL LLLL;goal goal goal]);
%
%     siz=size(mask);
% pause;
    all=sum(sum(mask));
    acc=sum(sum((goal.*anser).*mask))+sum(sum(((1-goal).*(1-anser)).*mask));
    acc=acc/all
    TP=sum(sum((goal.*anser).*mask));
    TN=sum(sum(((1-goal).*(1-anser)).*mask))
    FP=sum(sum((goal.*(1-anser)).*mask))
    FN=sum(sum(((1-goal).*(anser)).*mask))
    all-TP-TN-FP-FN
    sensitivity=TP/(TP+FN)
    specificity=TN/(TN+FP)
%     imshow([Y T (1-Q).*(mask) goal; LL2 B anser goal;BW YY YYY goal ;QY LLL LLLL goal]);
%     title(strcat(num2str(i), ": f_measure=", num2str(2*(sensitivity*specificity)/(sensitivity+specificity)), ": sensitivity=", num2str(sensitivity), " specificity:" , num2str(specificity), " acc:", num2str(acc)))
       sensitivitys(i)=sensitivity;
       specificitys(i)=specificity;
       accs(i)=acc;
    %     sum(sum(LLLL.*anser))+
%     [Gmag, Gdir] = imgradient(B,'central');
%     figure
%     imshowpair(Gmag, Gdir, 'montage');
%     title('Gradient Magnitude, Gmag (left), and Gradient Direction, Gdir (right), using Prewitt method')
%     Gdir_abs=abs(Gdir);
%     figure,
%     imshow(Gdir_abs>100,[]);

%     I_double=im2double(B);
%     figure,
%     imshow([I_double  (quant_AB-1)/11]);
    %     R=I(:,:,1);
%     G=I(:,:,2);
%     B=I(:,:,3);
%     imwrite(I,strcat("\DRIVE\Training\1st_manual_copy\", "Test" ,num2str(i) ,".tif"))
%     imshow(I);

%     pause;

end
tx=table(sensitivitys,specificitys,accs);

writetable(tx,"result4.xls");

% I_255=imread(path);
% thresh = multithresh(I_255,2);
% quant_A = imquantize(I_255,thresh);
% I_double=im2double(I_255);
% imshow([I_double  (quant_A-1)/3]);
