function [R21,T21]=getransactf(img1,img2,cam_params,x,y,subfolder)
dep1=load(strcat(subfolder,'/',img1.depth));
dep2=load(strcat(subfolder,'/',img2.depth));
% rgb1=imread(strcat(subfolder,'/',img1.rgb));
% rgb2=imread(strcat(subfolder,'/',img2.rgb));
valinds=logical(dep1.depth_array)&logical(dep2.depth_array);
xyz1 = get_xyzasus(dep1.depth_array(:), [x,y], find(valinds), cam_params.Kdepth, 1, 0);
xyz2 = get_xyzasus(dep2.depth_array(:), [x,y], find(valinds), cam_params.Kdepth, 1, 0);
% rgbd1 = get_rgbd(xyz1, rgb1, cam_params.R, cam_params.T, cam_params.Krgb);
% rgbd2 = get_rgbd(xyz2, rgb2, cam_params.R, cam_params.T, cam_params.Krgb);
pc1=pcdownsample(pcdenoise(pointCloud(xyz1)),'random',0.4);
pc2=pcdownsample(pcdenoise(pointCloud(xyz2)),'random',0.4);
[tform,tformed,err]=pcregrigid(pc2,pc1,'MaxIterations',100);
R21=tform.T(1:3,1:3)';
T21=tform.T(4,1:3)';
disp(err);
pcshow(pcmerge(pc1,tformed,0.001));