function feat_match(feat_d,foreg)
sz=numel(feat_d)-1;
trackedobj=cell(sz+1,2);
num_tr_objs=1;
for i=1:sz
    matchfeat1 = vl_ubcmatch(feat_d(i).desc_cam_1, feat_d(i+1).desc_cam_1);
    matchfeat2 = vl_ubcmatch(feat_d(i).desc_cam_2, feat_d(i+1).desc_cam_2);
    matches1=size(matchfeat1(1,:));
    matches2=size(matchfeat2(1,:));
    if ~isempty([matchfeat1,matchfeat2])
        if ~isempty(feat_d(i).frame_cam_2)
            datacam2now=nonzeros(foreg(i).objs2to1(feat_d(i).frame_cam_2(sub2ind(size(feat_d(i).frame_cam_2),5*ones(matches2),matchfeat2(1,:)))));
            ft_objs_now=[feat_d(i).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5*ones(matches1),matchfeat1(1,:))),datacam2now'];
        else
            ft_objs_now=feat_d(i).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5*ones(matches1),matchfeat1(1,:)));
        end
        if ~isempty(feat_d(i+1).frame_cam_2)
            datacam2next=nonzeros(foreg(i+1).objs2to1(feat_d(i+1).frame_cam_2(sub2ind(size(feat_d(i+1).frame_cam_2),5*ones(matches2),matchfeat2(2,:)))));
            ft_objs_next=[feat_d(i+1).frame_cam_1(sub2ind(size(feat_d(i+1).frame_cam_1),5*ones(matches1),matchfeat1(2,:))),datacam2next'];
        else
            ft_objs_next=feat_d(i+1).frame_cam_1(sub2ind(size(feat_d(i+1).frame_cam_1),5*ones(matches1),matchfeat1(2,:)));
        end
        matched_objs=unique(ft_objs_next);
        matching_objs=zeros(1,numel(matched_objs));
        for j=1:numel(matched_objs)
            column=zeros(size(matched_objs));
            for k=1:numel(column)
                column(k)=sum(ismember(ft_objs_next,matched_objs(k)));
            end
            [~,matching_objs(j)]=max(column);
        end
        [dup,freq]=mode(matching_objs);
        while max(freq) > 1 && dup ~= 0
            matching_objs(matching_objs==dup)=0;
            [dup,freq]=mode(nonzeros(matching_objs));
        end
        if i==1
            if ~isempty(ft_objs_now)
                trackedobj{i,1}=1:numel(num_tr_objs);
                trackedobj{i,2}=unique(ft_objs_now);
                num_tr_objs=numel(unique(ft_objs_now));
            end
        else
            newobjs=setdiff(nonzeros(matching_objs),trackedobj{i,2});
            if ~isempty(newobjs)
                trackedobj{i,1}=[trackedobj{i,1},num_tr_objs+1:(num_tr_objs+numel(newobjs)+1)];
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
            trackedobj{i+1,1}=[tr_obj_num(nonzeros(aux2)),num_tr_objs+1:num_tr_objs+sum(nobjs)+1];
            trackedobj{i+1,2}=[matched_objs(aux1),matched_objs(nobjs)];
        end
        num_tr_objs=num_tr_objs+sum(nobjs);
    end
end
end