function [feat_d,fg_px]=feat_detect(BG1,BG2,imseq1,imseq2,x,y,n)
feat_d=struct('frame_cam_1',cell(n,1),'desc_cam_1',cell(n,1),'frame_cam_2',cell(n,1),'desc_cam_2',cell(n,1));
fg_px=struct('foreground_cam_1',cell(n,1),'foreground_cam_2',cell(n,1));
figure();
for i=1:n
    dep1=load(imseq1(i).depth);
    dep1=double(dep1.depth_array(:));
    rgb1=rgb2gray(imread(imseq1(i).rgb));
    dep2=load(imseq2(i).depth);
    dep2=double(dep2.depth_array(:));
    rgb2=rgb2gray(imread(imseq2(i).rgb));
    fg1=imfill(imopen(abs(dep1-BG1.*single(logical(dep1)))>100,strel('disk',3)),'holes');
    fg2=imfill(imopen(abs(dep2-BG2.*single(logical(dep2)))>100,strel('disk',3)),'holes');
    [gix1,giy1]=ind2sub([x,y],find(fg1));
    [gix2,giy2]=ind2sub([x,y],find(fg2));
    fg_px(i).foreground_cam_1=cat(2,[gix1,giy1],dep1(fg1));
    fg_px(i).foreground_cam_2=cat(2,[gix2,giy2],dep2(fg2));
    img1=rgb1.*uint8(reshape(fg1,[x,y]));
    img2=rgb2.*uint8(reshape(fg1,[x,y]));
    %imshow(img1);
    [feat_e1,desc1] = vl_sift(single(img1),'PeakThresh',10);
    [feat_e2,desc2] = vl_sift(single(img2),'PeakThresh',10);
%     h1 = vl_plotframe(feat_e1);
%     set(h1,'color','y','linewidth',2);
    feat_d(i).frame_cam_1 = feat_e1;
    feat_d(i).frame_cam_2 = feat_e2;
    feat_d(i).desc_cam_1 = desc1;
    feat_d(i).desc_cam_2 = desc2;
%     pause(.05);
end