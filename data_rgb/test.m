clear all;

d=dir;

aux=zeros(480,640,13);
rm=zeros(480,640);

for i=25:1:38
    aux(:,:,i-24)= double(rgb2gray(imread(d(i).name)));
end

for i=1:480
    for j=1:640
        rm(i,j)=median(aux(i,j,:));
    end
end

imshow(uint8(rm));