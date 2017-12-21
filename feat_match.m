function feat_match(feat_d,foreg)
sz=numel(feat_d)-1;
trackedobj=cell(sz+1,2);
for i=1:sz
    matchfeat1 = vl_ubcmatch(feat_d(i).desc_cam_1, feat_d(i+1).desc_cam_1);
    matchfeat2 = vl_ubcmatch(feat_d(i).desc_cam_2, feat_d(i+1).desc_cam_2);
    datacam2now=nonzeros(foreg(i).objs2to1(feat_d(i).frame_cam_2(sub2ind(size(feat_d(i).frame_cam_2),5,matchfeat2(1,:)))));
    if ~isempty(datacam2now)
        ft_objs_now=[feat_d(i).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5,matchfeat1(1,:))),datacam2now'];
    else
        ft_objs_now=feat_d(i).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5,matchfeat1(1,:)));
    end
    datacam2next=nonzeros(foreg(i+1).objs2to1(feat_d(i+1).frame_cam_2(sub2ind(size(feat_d(i).frame_cam_2),5,matchfeat2(2,:)))));
    if ~isempty(datacam2next)
        ft_objs_next=[feat_d(i+1).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5,matchfeat1(2,:))),datacam2next'];
    else
        ft_objs_next=feat_d(i+1).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5,matchfeat1(2,:)));
    end
    matched_objs=[];
    matching_objs=[];
    if ~isempty(ft_objs_next)
        matched_objs=unique(ft_objs_next);
        matching_objs=zeros(1,numel(matched_objs));
        for j=1:numel(matched_objs)
            column=zeros(size(matched_objs));
            for k=1:numel(column)
                column(k)=sum(ismember(ft_objs_next,matched_objs(k)));
            end
            [~,matches]=mode(column);
            [~,matching_objs(j)]=max(matches);
        end
        [dup,freq]=mode(matching_objs);
        while max(freq) > 1 && dup ~= 0
            matching_objs(matching_objs==dup)=0;
            [dup,freq]=mode(nonzeros(matching_objs));
        end
    end
    if i==1
        num_tr_objs=numel(unique(ft_objs_now));
        if ~num_tr_objs
            num_tr_objs=1;
        end
        if ~isempty(ft_objs_now)
            trackedobj{i,1}=1:numel(num_tr_objs);
            trackedobj{i,2}=unique(ft_objs_now);
        end
    else
        newobjs=setdiff(ft_objs_now,trackedobj{i,2});
        if ~isempty(newobjs)
            trackedobj{i,1}=[trackedobj{i,1},num_tr_objs:(num_tr_objs+numel(newobjs))];
            trackedobj{i,2}=[trackedobj{i,2},newobjs];
        end
        num_tr_objs=num_tr_objs+numel(newobjs);
    end
    tr_obj_num=trackedobj{i,1};
    obj_in_frame=trackedobj{i,2};
    [aux1,aux2]=ismember(matching_objs,obj_in_frame);
    nobjs=ismember(matching_objs,0);
    if ~sum(nobjs)
        trackedobj{i+1,1}=tr_obj_num(nonzeros(aux2));
        trackedobj{i+1,2}=matched_objs(aux1);
    else
        trackedobj{i+1,1}=[tr_obj_num(nonzeros(aux2)),num_tr_objs:num_tr_objs+sum(nobjs)];
        trackedobj{i+1,2}=[matched_objs(aux1),matched_objs(nobjs)];
    end
    num_tr_objs=num_tr_objs+sum(nobjs);
end
end