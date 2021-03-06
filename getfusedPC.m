function [R21,T21]=getfusedPC(img1,img2,cam_params,x,y,subfolder)
dep1=load(strcat(subfolder,'/',img1.depth));
rgb1=imread(strcat(subfolder,'/',img1.rgb));
dep2=load(strcat(subfolder,'/',img2.depth));
rgb2=imread(strcat(subfolder,'/',img2.rgb));
xyz1 = get_xyzasus(dep1.depth_array(:), [x,y], find(dep1.depth_array), cam_params.Kdepth, 1, 0);
xyz2 = get_xyzasus(dep2.depth_array(:), [x,y], find(dep2.depth_array), cam_params.Kdepth, 1, 0);
rgbd1 = get_rgbd(xyz1, rgb1, cam_params.R, cam_params.T, cam_params.Krgb);
rgbd2 = get_rgbd(xyz2, rgb2, cam_params.R, cam_params.T, cam_params.Krgb);
figure();
imshow(uint8(reshape(rgbd1,[x y 3])));
[u1,v1]=ginput(6);
imshow(uint8(reshape(rgbd2,[x y 3])));
[u2,v2]=ginput(6);
%[u1,v1,u2,v2]=fix([u1,v1,u2,v2]);
hold on;
plot(u1,v1,'.r');
plot(u2,v2,'.b');
hold off;
ind1=sub2ind([x y],uint64(v1),uint64(u1));
ind2=sub2ind([x y],uint64(v2),uint64(u2));
P1=xyz1(ind1,:);
P2=xyz2(ind2,:);
valind=find((P1(:,3).*P2(:,3))>0);
[~,~,tr]=procrustes(P1(valind,:),P2(valind,:),'scaling',false,'reflection',false);
T21=tr.c;
R21=tr.T;
pc1=pointCloud(xyz1,'Color',reshape(rgbd1,[x*y 3]));
xyz21=xyz2*tr.T+ones(length(xyz2),1)*tr.c(1,:);
pc2=pointCloud(xyz21,'Color',reshape(rgbd2,[x*y 3]));
pcshow(pcmerge(pc1,pc2,0.001));
end