close all;

load('calib_asus.mat');

cam_params.K = Depth_cam.K;
cam_params.R = R_d_to_rgb;
cam_params.T = T_d_to_rgb;

D1=dir('depth1*.mat');
D2=dir('depth2*.mat');
RGB1=[dir('*image1*.png');dir('*image1*.jpg')];
RGB2=[dir('*image2*.png');dir('*image2*.jpg')];

[n1,~]=size(D1);
[n2,~]=size(D2);

for i=1:n1
    imgseq1(i)=struct('rgb',RGB1(i).name,'depth',D1(i).name);
end

for i=1:n2
    imgseq2(i)=struct('rgb',RGB2(i).name,'depth',D2(i).name);
end

cam1toW=0;
cam2toW=0;

objects = track3D_part1(imgseq1, imgseq2, cam_params, cam1toW, cam2toW);