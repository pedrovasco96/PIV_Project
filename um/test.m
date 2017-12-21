clear all;

d=dir;

r=zeros(480,640,38);
g=zeros(480,640,38);
b=zeros(480,640,38);


for i=3:2:77
    aux = double(imread(d(i).name));
    r(:,:,(i-1)/2)=aux(:,:,1);
    g(:,:,(i-1)/2)=aux(:,:,2);
    b(:,:,(i-1)/2)=aux(:,:,3);
end

for i=1:480
    for j=1:640
        rm(i,j)=median(r(i,j,:));
        gm(i,j)=median(g(i,j,:));
        bm(i,j)=median(b(i,j,:));
    end
end

back(:,:,1)=rm;
back(:,:,2)=gm;
back(:,:,3)=bm;

imshow(uint8(back));