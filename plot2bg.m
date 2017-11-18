function plot2bg(bg1d,bg1rgb,bg2d,bg2rgb,x,y)
bg1_d=reshape(bg1d,[x y 1]);
bg1_rgb=reshape(bg1rgb,[x y 3]);
bg2_d=reshape(bg2d,[x y 1]);
bg2_rgb=reshape(bg2rgb,[x y 3]);
figure;
subplot(2,2,1);
imagesc(bg1_d);
colorbar;
title('depth cam1');
subplot(2,2,2);
imshow(uint8(bg1_rgb));
title('rgb cam1');
subplot(2,2,3);
imagesc(bg2_d);
colorbar;
title('depth cam2');
subplot(2,2,4);
imshow(uint8(bg2_rgb));
title('rgb cam2');
end