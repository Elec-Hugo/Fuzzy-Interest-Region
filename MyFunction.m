function [bl,br,bu,bd,maxFuzzyOut] = MyFunction(vr,vid)
global rsflag;
global timeTic;
global a1;
global a2;
global a3;
global b1;
global b2;
global b3;
filename=SelectFile();
timeTic(1)=toc;
sz=[128,128];

wavelength = 4;
orientation = 20;
delete('*.mat');
extractAndSaveORB(filename,wavelength,orientation,sz);
[a1,a2,a3]=size(read(vr,5));
I1 = impyramid(im2double(read(vr,5)), 'reduce');
%I1 = impyramid(I1, 'reduce');
%I1 = impyramid(I1, 'reduce');

if rsflag==1
I1=rgb2gray(imresize(I1,sz));
else
I1=rgb2gray(I1);
end

[mag1 ang]=imgaborfilt(imgaborfilt(I1,2,0),2,0);
    [mag2 ang]=imgaborfilt(imgaborfilt(I1,2,45),2,45);
    [mag3 ang]=imgaborfilt(imgaborfilt(I1,2,90),2,90);
    [mag4 ang]=imgaborfilt(imgaborfilt(I1,2,135),2,135);
    I1 = mag1+mag2+mag3+mag4;
    
img=im2uint8(I1);
points = detectORBFeaturesOCV(img);

[f,valid_points]=extractORBFeaturesOCV(img,points);
f= binaryFeatures(f);
figure(1);

imshow(img);
matchedPoints=[];
d=dir('*.mat');
for i=1:length(d)
    savedFeatures = matfile("saveA"+i+".mat");
    features = savedFeatures.features;
    features = binaryFeatures(features);
    indexPairs = matchFeatures(f,features, 'MatchThreshold', 100,'MaxRatio',0.9 );
    matchedPoints = cat(1,matchedPoints, valid_points.Location(indexPairs(:,1),:));
end

hold on;
plot(matchedPoints(:,1),matchedPoints(:,2),'r+');
title('Gabor magnitude and Features');

dens=zeros(4,4);
for i=0:3
    for j=0:3
        dens(i+1,j+1)=size(matchedPoints(any(matchedPoints(:,2)<32*(j+1) & matchedPoints(:,1)<32*(i+1)...
            & matchedPoints(:,1)>32*i & matchedPoints(:,2)>32*j,2),:),1);
    end
end

dens=dens./sum(dens(:));
dens=smf(dens,[.1,0.9]);
rl=zeros(4,4,2);
Xc=[16,48,80,112];
Yc=[16,48,80,112];

fxy=0;
mfRegion=0;

x = 0:1:127;
y = x;
[X,Y] = meshgrid(x);
s=62;

figure(2);
axis ij;
for i=1:4
    for j=1:4
        mfRegion=mfRegion+exp(-((X-Xc(i)).^2+(Y-Yc(j)).^2)/(2*s)).^2;
        mesh(X,Y,mfRegion);
        drawnow limitrate
    end
end
for i=1:4
    for j=1:4
        center = [Xc(i),Yc(j)];
        rl(i,j,:)=dens(i,j)*center;
        fxy=fxy+dens(i,j)*exp(-((X-Xc(i)).^2+(Y-Yc(j)).^2)/(2*s)).^2;        
    end
end
zlim([0 1])
xlim([0 129])
ylim([0 129])
xlabel('x')
ylabel('y')
title('Regional MF');

figure(3);
mesh(X,Y,fxy);
zlim([0 1])
xlim([0 128])
ylim([0 128])
title('Density of Features');
axis ij;
drawnow limitrate
xlabel('x')
ylabel('y')

def=0;
for i=50:60
img=imresize(rgb2gray(im2double(vid(:,:,:,i))),sz);
image2=imresize(rgb2gray(im2double(vid(:,:,:,i+1))),sz);
def=def+im2double(abs(image2-img));
end

def=imgaussfilt(def/10,8);
def=def/max(def(:));

Y0=[16,48,80,112].*[dens(1,1) dens(1,2) dens(1,3) dens(1,4)]...
    +[16,48,80,112].*[dens(2,1) dens(2,2) dens(2,3) dens(2,4)]...
    +[16,48,80,112].*[dens(3,1) dens(3,2) dens(3,3) dens(3,4)]...
    +[16,48,80,112].*[dens(4,1) dens(4,2) dens(4,3) dens(4,4)];
Y0=sum(Y0(:))/sum(dens(:));
X0=[16,16,16,16].*[dens(1,1) dens(1,2) dens(1,3) dens(1,4)]...
    +[48,48,48,48].*[dens(2,1) dens(2,2) dens(2,3) dens(2,4)]...
    +[80,80,80,80].*[dens(3,1) dens(3,2) dens(3,3) dens(3,4)]...
    +[112,112,112,112].*[dens(4,1) dens(4,2) dens(4,3) dens(4,4)];
X0=sum(X0(:))/sum(dens(:));



% [x, y] = meshgrid(1:size(fxy, 2), 1:size(fxy, 1));
% weightedx = x .* fxy;
% weightedy = y .* fxy;
% X0 = sum(weightedx(:)) / sum(fxy(:));
% Y0 = sum(weightedy(:)) / sum(fxy(:));
% 






c=var([matchedPoints(:,1)-X0,matchedPoints(:,2)-Y0]);

mf=exp(-((X-X0).^2/c(1)+(Y-Y0).^2/c(2))/2);

figure(4);
mesh(mf);
zlim([0 1])
xlim([0 128])
ylim([0 128])
xlabel('x')
ylabel('y')
title('Features MF');
axis ij;
figure(5);
mesh(def);
zlim([0 1])
xlim([0 128])
ylim([0 128])
xlabel('x')
ylabel('y')
title('Changes MF');
axis ij;
figure(6);
mesh(def.*mf);
zlim([0 1])
xlim([0 128])
ylim([0 128])
xlabel('x')
ylabel('y')
title('Fuzzy output');
axis ij;
figure(7);
outfuzzy=def.*mf;
region=(outfuzzy)>0.01;
maxFuzzyOut=max(max(outfuzzy));
mesh(region);
zlim([0 1])
xlim([0 128])
ylim([0 128])
xlabel('x')
ylabel('y')
title('Final output');
axis ij;
drawnow limitrate;

[Xborder Yborder]=ind2sub(size(region),find(region==1));
sz=size(vid(:,:,:,1));
cornerMax=floor([sz(1)*max(Xborder) sz(2)*max(Yborder)]/128);
cornerMin=floor([sz(1)*min(Xborder) sz(2)*min(Yborder)]/128);

bl=cornerMin(2);
br=cornerMax(2);
bu=cornerMin(1);
bd=cornerMax(1);

figure(8);
imshow(im2double(vid(:,:,:,1)));
title('Borders in the image');

rectangle('Position',[bl bu br-bl bd-bu ],...
        'Curvature',[0.1,0.1],'EdgeColor','g',...
        'LineWidth',2);
    
figure(9);
imshow(vid(bu:bd,bl:br,1:3));
title('The Region''s image');

reduceImage(vid,cornerMin,cornerMax);

[b1,b2,b3]=size(vid(bu:bd,bl:br,:,1));

end

