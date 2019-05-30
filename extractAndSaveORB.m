function extractAndSaveORB(filename,wavelength,orientation,sz)
global rsflag;

d=dir('data\parts of picture\');
jpgfiles=[dir(sprintf('data\\parts of picture\\%s',d(filename).name))];
images =sprintf('data\\parts of picture\\%s\\',d(filename).name);
j=1;
for i=3:length(jpgfiles)
    im=jpgfiles(i).name;
    
    img=imread(fullfile(images,im));
    if filename==44
        I1=im2double(img);      
    else
        I1 = impyramid(im2double(img), 'reduce');
    end 
    if rsflag==1
        if (length(size(I1))>2)
            I1=rgb2gray(imresize(I1,sz));
        else
            I1=imresize(I1,sz);
        end
    else
        if (length(size(I1))>2)
            I1=rgb2gray(I1);
        end
    end
%     I1=imgaborfilt(imgaborfilt(I1,2,0),2,0)+...
%         imgaborfilt(imgaborfilt(I1,2,45),2,45)+...
%         imgaborfilt(imgaborfilt(I1,2,90),2,135)+...
%         imgaborfilt(imgaborfilt(I1,2,135),2,-45)+...
%         imgaborfilt(imgaborfilt(I1,2,-45),2,-45)+...
%         imgaborfilt(imgaborfilt(I1,2,-90),2,-90)+...
%         imgaborfilt(imgaborfilt(I1,2,-135),2,-135);
    [mag1 ang]=imgaborfilt(imgaborfilt(I1,2,0),2,0);
    [mag2 ang]=imgaborfilt(imgaborfilt(I1,2,45),2,45);
    [mag3 ang]=imgaborfilt(imgaborfilt(I1,2,90),2,90);
    [mag4 ang]=imgaborfilt(imgaborfilt(I1,2,135),2,135);
    I1 = mag1+mag2+mag3+mag4;
    
    img=im2uint8(I1);
    points2 = detectORBFeaturesOCV(img);
    [features,vpts2] = extractORBFeaturesOCV(img,points2);
    s=size(features);
    if s(1)>0
        save("saveA"+j+".mat",'features');
        j=j+1;
    end
end

end