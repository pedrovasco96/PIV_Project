im=rgb2gray(imread('parede1.jpg'));
[b r c]=harris(im,1,1000,10,1);
figure(1);clf;
imagesc(im);
hold;
plot(c,r,'*');
colormap(gray);
figure(2);
imagesc(b);
colormap(gray);

im2=rgb2gray(imread('parede2.jpg'));
[b2 r2 c2]=harris(im2,1,1000,10,1);
figure(3);
imagesc(im2);
hold;
plot(c2,r2,'*');
colormap(gray);
figure(4);
imagesc(b2);
colormap(gray);
pause;
%Correlation
figure(1);
imagesc(im);
%At this time you need to select a point in the figure
[x y]=ginput(1);
SI=im(y-5:y+5,x-5:x+5);
c=normxcorr2(double(SI),double(im2));
figure;
mesh(c);
axis ij;
figure;
imshow(im);
figure;
imshow(im2);