function [R21,T21]=getransactf(n,is1,is2,cam_params,x,y,subfolder,imsamples)
if n > imsamples
    a=linspace(1,n,imsamples);
    a=fix(a);
else
    a=1:n;
end
sz=numel(a);
xyztest1=cell(imsamples,1);
uvtest1=cell(imsamples,1);
xyztest2=cell(imsamples,1);
uvtest2=cell(imsamples,1);
for i=1:sz
    num=a(i);
    dep1=load(strcat(subfolder,'/',is1(num).depth));
    dep1=single(dep1.depth_array);
    dep2=load(strcat(subfolder,'/',is2(num).depth));
    dep2=single(dep2.depth_array);
    rgb1=imread(strcat(subfolder,'/',is1(num).rgb));
    rgb2=imread(strcat(subfolder,'/',is2(num).rgb));
    valinds=logical(dep1)&logical(dep2);
    xyz1=get_xyzasus(dep1(:),[x y],find(valinds),cam_params.Kdepth,1,0);
    xyz2=get_xyzasus(dep2(:),[x y],find(valinds),cam_params.Kdepth,1,0);
    rgbd1=get_rgbd(xyz1,rgb1,cam_params.R,cam_params.T,cam_params.Krgb);
    rgbd2=get_rgbd(xyz2,rgb2,cam_params.R,cam_params.T,cam_params.Krgb);
    img1=rgb2gray(rgbd1);
    img2=rgb2gray(rgbd2);
    [feat_e1,desc1] = vl_sift(single(img1));
    [feat_e2,desc2] = vl_sift(single(img2));
    feat_e1(1:2,:)=flip(feat_e1(1:2,:),1);
    feat_e2(1:2,:)=flip(feat_e2(1:2,:),1);
    [matchfeats,~] = vl_ubcmatch(desc1, desc2);
    u1=feat_e1(sub2ind(size(feat_e1),ones(numel(matchfeats)/2,1),matchfeats(1,:)'));
    v1=feat_e1(sub2ind(size(feat_e1),2*ones(numel(matchfeats)/2,1),matchfeats(1,:)'));
    uvtest1{i}=[u1 v1];
    u2=feat_e2(sub2ind(size(feat_e2),ones(numel(matchfeats)/2,1),matchfeats(2,:)'));
    v2=feat_e2(sub2ind(size(feat_e2),2*ones(numel(matchfeats)/2,1),matchfeats(2,:)'));
    uvtest2{i}=[u2 v2];
    xyztest1{i}=xyz1(sub2ind([x y],round(u1),round(v1)),:);
    xyztest2{i}=xyz2(sub2ind([x y],round(u2),round(v2)),:);
end
xyztest1=cell2mat(xyztest1);
uvtest1=cell2mat(uvtest1);
xyztest2=cell2mat(xyztest2);
uvtest2=cell2mat(uvtest2);
[~,inliers]=estimateFundamentalMatrix(uvtest1,uvtest2);
pc1=pointCloud(xyztest1(inliers,:));
pc2=pointCloud(xyztest2(inliers,:));
[tform,~,err]=pcregrigid(pc2,pc1,'MaxIterations',500);
pcog1=pointCloud(xyz1,'Color',reshape(rgbd1,[x*y 3]));
pc2in1=pctransform(pointCloud(xyz2,'Color',reshape(rgbd2,[x*y 3])),tform);
pcshow(pcmerge(pcog1,pc2in1,0.001));
disp(err);
R21=tform.T(1:3,1:3)';
T21=tform.T(4,1:3)';
end
%     for j=1:500
%         order=randperm(numel(matchfeats)/2,points);
%         matchcam1=matchfeats(sub2ind(size(matchfeats),ones(points,1),order'));
%         matchcam2=matchfeats(sub2ind(size(matchfeats),2*ones(points,1),order'));
%         su1=feat_e1(sub2ind(size(feat_e1),ones(points,1),matchcam1));
%         sv1=feat_e1(sub2ind(size(feat_e1),2*ones(points,1),matchcam1));
%         su2=feat_e2(sub2ind(size(feat_e2),ones(points,1),matchcam2));
%         sv2=feat_e2(sub2ind(size(feat_e2),2*ones(points,1),matchcam2));
%         %[~,inliers]=estimateFundamentalMatrix([u1 v1],[u2 v2],'Method','RANSAC','NumTrials',5000);
%         xyzcam1=xyz1(sub2ind([x y],round(su1),round(sv1)),:);
%         xyzcam2=xyz2(sub2ind([x y],round(su2),round(sv2)),:);
%         [~,~,tr]=procrustes(xyzcam1,xyzcam2,'scaling',false,'reflection',false);
%         xyztest1=xyz1(sub2ind([x y],round(u1),round(v1)),:);
%         xyztest2=xyz2(sub2ind([x y],round(u2),round(v2)),:);
%         testerr=sum(norm(xyztest1-xyztest2*tr.T'-repmat(tr.c(1,:),numel(matchfeats)/2,1)));
%         if testerr < err
%             T21=tr.c(1,:);
%             R21=tr.T;
% %             err=testerr;
% %         end
% %     end
% % end
% disp(err);
% pc1=pointCloud(xyz1,'Color',reshape(rgbd1,[x*y 3]));
% xyz21=xyz2*R21+ones(length(xyz2),1)*T21;
% pc2=pointCloud(xyz21,'Color',reshape(rgbd2,[x*y 3]));
% pcshow(pcmerge(pc1,pc2,0.001));
% % dep1=load(strcat(subfolder,'/',img1.depth));
% % dep2=load(strcat(subfolder,'/',img2.depth));
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