function [R21,T21]=getransactf(img1,img2,cam_params,x,y,subfolder)
dep1=load(strcat(subfolder,'/',img1.depth));
dep1=single(dep1.depth_array);
dep2=load(strcat(subfolder,'/',img2.depth));
dep2=single(dep2.depth_array);
rgb1=imread(strcat(subfolder,'/',img1.rgb));
rgb2=imread(strcat(subfolder,'/',img2.rgb));
xyz1=get_xyzasus(dep1(:),[x y],find(dep1),cam_params.Kdepth,1,0);
xyz2=get_xyzasus(dep2(:),[x y],find(dep2),cam_params.Kdepth,1,0);
rgbd1=get_rgbd(xyz1,rgb1,cam_params.R,cam_params.T,cam_params.Krgb);
rgbd2=get_rgbd(xyz2,rgb2,cam_params.R,cam_params.T,cam_params.Krgb);
img1=rgb2gray(rgbd1);
img2=rgb2gray(rgbd2);
[feat_e1,desc1] = vl_sift(single(img1));
[feat_e2,desc2] = vl_sift(single(img2));
feat_e1(1:2,:)=flip(feat_e1(1:2,:),1);
feat_e2(1:2,:)=flip(feat_e2(1:2,:),1);
[matchfeats,scores] = vl_ubcmatch(desc1, desc2);
[~,order]=sort(scores);
matchcam1=matchfeats(sub2ind(size(matchfeats),ones(numel(matchfeats)/2,1),order'));
matchcam2=matchfeats(sub2ind(size(matchfeats),2*ones(numel(matchfeats)/2,1),order'));
u1=feat_e1(sub2ind(size(feat_e1),ones(numel(matchfeats)/2,1),matchcam1));
v1=feat_e1(sub2ind(size(feat_e1),2*ones(numel(matchfeats)/2,1),matchcam1));
u2=feat_e2(sub2ind(size(feat_e2),ones(numel(matchfeats)/2,1),matchcam2));
v2=feat_e2(sub2ind(size(feat_e2),2*ones(numel(matchfeats)/2,1),matchcam2));
[~,inliers]=estimateFundamentalMatrix([u1 v1],[u2 v2],'Method','RANSAC','NumTrials',5000);
xyzcam1=xyz1(sub2ind([x y],round(u1(inliers)),round(v1(inliers))),:);
xyzcam2=xyz2(sub2ind([x y],round(u2(inliers)),round(v2(inliers))),:);
[err,~,tr]=procrustes(xyzcam1,xyzcam2,'scaling',false,'reflection',false);
T21=tr.c;
R21=tr.T;
pc1=pointCloud(xyz1,'Color',reshape(rgbd1,[x*y 3]));
xyz21=xyz2*tr.T+ones(length(xyz2),1)*tr.c(1,:);
pc2=pointCloud(xyz21,'Color',reshape(rgbd2,[x*y 3]));
pcshow(pcmerge(pc1,pc2,0.001));
disp(err);
% dep1=load(strcat(subfolder,'/',img1.depth));
% dep2=load(strcat(subfolder,'/',img2.depth));
% % rgb1=imread(strcat(subfolder,'/',img1.rgb));
% % rgb2=imread(strcat(subfolder,'/',img2.rgb));
% valinds=logical(dep1.depth_array)&logical(dep2.depth_array);
% xyz1 = get_xyzasus(dep1.depth_array(:), [x,y], find(valinds), cam_params.Kdepth, 1, 0);
% xyz2 = get_xyzasus(dep2.depth_array(:), [x,y], find(valinds), cam_params.Kdepth, 1, 0);
% % rgbd1 = get_rgbd(xyz1, rgb1, cam_params.R, cam_params.T, cam_params.Krgb);
% % rgbd2 = get_rgbd(xyz2, rgb2, cam_params.R, cam_params.T, cam_params.Krgb);
% pc1=pcdownsample(pcdenoise(pointCloud(xyz1)),'gridAverage',0.1);
% pc2=pcdownsample(pcdenoise(pointCloud(xyz2)),'gridAverage',0.1);
% [tform,tformed,err]=pcregrigid(pc2,pc1,'MaxIterations',50,'Metric','pointToPlane','Extrapolate',true);
% R21=tform.T(1:3,1:3)';
% T21=tform.T(4,1:3)';
% disp(err);
% pcshow(pcmerge(pc1,tformed,0.001));
end