function plot2bg(bg1,bg2,x,y)
bg_1=reshape(bg1,[x y 1]);
bg_2=reshape(bg2,[x y 1]);
figure;
subplot(2,1,1);
imagesc(bg_1);
colorbar;
title('depth cam1');
subplot(2,1,2);
imagesc(bg_2);
colorbar;
title('depth cam2');
end