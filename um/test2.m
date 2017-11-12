clear all;

d=dir;

aux=zeros(480,640,38);
rm=zeros(480,640);

for i=3:2:77
    aux(:,:,(i-1)/2)= double(rgb2gray(imread(d(i).name)));
end

for i=1:480
    for j=1:640
        rm(i,j)=median(aux(i,j,:));
    end
end

imshow(uint8(rm));