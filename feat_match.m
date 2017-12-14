function feat_match(imseq1,imseq2,feat_d,foreg,cam_params,x,y)
[R12,T12]=getfusedPC(imseq1(1),imseq2(1),cam_params,x,y);
sz=numel(feat_d)-1;
match=struct('feat1',cell(sz,1),'sc1',cell(sz,1),'feat2',cell(sz,1),'sc2',cell(sz,1));
for i=1:numel(feat_d)-1
[match(i).feat1, match(i).sc1] = vl_ubcmatch(feat_d(i).desc_cam_1, feat_d(i+1).desc_cam_1) ;
[match(i).feat2, match(i).sc2] = vl_ubcmatch(feat_d(i).desc_cam_2, feat_d(i+1).desc_cam_2) ;
end
end
