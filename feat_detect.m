function [feat_d,foreg,matches]=feat_detect(BG1,BG2,R21,T21,imseq1,imseq2,x,y,n,cam_params,subfolder)
feat_d=struct('frame_cam_1',cell(n,1),'desc_cam_1',cell(n,1),'frame_cam_2',cell(n,1),'desc_cam_2',cell(n,1));
foreg=struct('foreground_cam_1',cell(n,1),'foreground_cam_2',cell(n,1),'objs2to1',cell(n,1));
bg1=reshape(BG1,[x y]);
bg2=reshape(BG2,[x y]);
matches=0;
% figure();
for i=1:n
    dep1=load(strcat(subfolder,'/',imseq1(i).depth));
    dep1=single(dep1.depth_array);
    Dep1=imgradient(dep1)./8;
    dep2=load(strcat(subfolder,'/',imseq2(i).depth));
    dep2=single(dep2.depth_array);
    Dep2=imgradient(dep2)./8;
    rgb1=imread(strcat(subfolder,'/',imseq1(i).rgb));
    rgb2=imread(strcat(subfolder,'/',imseq2(i).rgb));
    xyz1=get_xyzasus(dep1(:),[x y],find(dep1),cam_params.Kdepth,1,0);
    xyz2=get_xyzasus(dep2(:),[x y],find(dep2),cam_params.Kdepth,1,0);
    rgbd1=get_rgbd(xyz1,rgb1,cam_params.R,cam_params.T,cam_params.Krgb);
    rgbd2=get_rgbd(xyz2,rgb2,cam_params.R,cam_params.T,cam_params.Krgb);
    fg1=imfill(imopen(abs(dep1-bg1)>200,strel('disk',3)),'holes');
    fg2=imfill(imopen(abs(dep2-bg2)>200,strel('disk',3)),'holes');
    fg1(Dep1>200)=0;
    fg2(Dep2>200)=0;
    fg1=bwareaopen(fg1,200);
    fg2=bwareaopen(fg2,200);
%     imshow(fg1);
    img1=rgb2gray(rgbd1).*uint8(fg1);
    img2=rgb2gray(rgbd2).*uint8(fg2);
    [feat_e1,desc1] = vl_sift(single(img1));
    [feat_e2,desc2] = vl_sift(single(img2));
%     h1 = vl_plotframe(feat_e2);
%     set(h1,'color','y','linewidth',2);
    feat_e1(1:2,:)=flip(feat_e1(1:2,:),1);
    feat_e2(1:2,:)=flip(feat_e2(1:2,:),1);
    val_f1=fg1(sub2ind([x y],round(feat_e1(1,:)),round(feat_e1(2,:))));
    val_f2=fg2(sub2ind([x y],round(feat_e2(1,:)),round(feat_e2(2,:))));
    feat_e1=feat_e1(:,val_f1);
    desc1=desc1(:,val_f1);
    feat_e2=feat_e2(:,val_f2);
    desc2=desc2(:,val_f2);
    ConComp1=bwconncomp(bwselect(fg1,feat_e1(2,:),feat_e1(1,:),8));
    ConComp2=bwconncomp(bwselect(fg2,feat_e2(2,:),feat_e2(1,:),8));
    objs1=single(labelmatrix(ConComp1));
    objs2=single(labelmatrix(ConComp2));
    feat_d(i).frame_cam_1 = [feat_e1;objs1(sub2ind([x y],round(feat_e1(1,:)),round(feat_e1(2,:))))];
    feat_d(i).frame_cam_2 = [feat_e2;objs2(sub2ind([x y],round(feat_e2(1,:)),round(feat_e2(2,:))))];
    feat_d(i).desc_cam_1 = desc1;
    feat_d(i).desc_cam_2 = desc2;
    foreg(i).foreground_cam_1=cell(ConComp1.NumObjects,1);
    foreg(i).foreground_cam_2=cell(ConComp2.NumObjects,1);
    centr1=zeros(ConComp1.NumObjects,3);
    for j=1:ConComp1.NumObjects
        A=cell2mat(ConComp1.PixelIdxList(1,j));
        foreg(i).foreground_cam_1{j}=[max(xyz1(A,:),[],1),min(xyz1(A,:),[],1)];
        centr1(j,:)=mean(xyz1(A,:));
    end
    for j=1:ConComp2.NumObjects
        A=cell2mat(ConComp2.PixelIdxList(1,j));
        foreg(i).foreground_cam_2{j}=[max(xyz2(A,:),[],1),min(xyz2(A,:),[],1)];
        centr2=mean(xyz2(A,:))';
        centr2=R21*centr2+T21;
        dist2cent=zeros(1,ConComp1.NumObjects);
        for k=1:ConComp1.NumObjects
            dist2cent(1,k)=norm(centr2-centr1(k,:)');
        end
        dist2cent(dist2cent>0.5)=NaN;
        [isattr,centr2in1]=min(dist2cent);
        if ~isnan(isattr)
            matches=matches+1;
            foreg(i).objs2to1(j)=centr2in1;
        else
            foreg(i).objs2to1(j)=0;
        end
    end
%     imagesc([objs1 objs2]);
%     pause(.05);
end