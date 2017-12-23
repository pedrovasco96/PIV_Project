function feat_match(feat_d,foreg)
sz=numel(feat_d)-1;
trackedobj=cell(sz+1,4);
num_tr_objs=0;
for i=1:sz
    matchfeat1 = vl_ubcmatch(feat_d(i).desc_cam_1, feat_d(i+1).desc_cam_1);
    matchfeat2 = vl_ubcmatch(feat_d(i).desc_cam_2, feat_d(i+1).desc_cam_2);
    matches1=size(matchfeat1(1,:));
    matches2=size(matchfeat2(1,:));
    if ~isempty([matchfeat1,matchfeat2])
        cam2only_now=[];
        datacam2now=[];
        if ~isempty(feat_d(i).frame_cam_2)
            cam2now=feat_d(i).frame_cam_2(sub2ind(size(feat_d(i).frame_cam_2),5*ones(matches2),matchfeat2(1,:)));
            datacam2now=nonzeros(cam2now);
            ft_objs_now=[feat_d(i).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5*ones(matches1),matchfeat1(1,:))),datacam2now'];
            cam2only_now=cam2now(~find(cam2now));
        else
            ft_objs_now=feat_d(i).frame_cam_1(sub2ind(size(feat_d(i).frame_cam_1),5*ones(matches1),matchfeat1(1,:)));
        end
        if ~isempty(feat_d(i+1).frame_cam_2)
            cam2next=foreg(i+1).objs2to1(feat_d(i+1).frame_cam_2(sub2ind(size(feat_d(i+1).frame_cam_2),5*ones(matches2),matchfeat2(2,:))));
            datacam2next=nonzeros(cam2next);
            ft_objs_next=[feat_d(i+1).frame_cam_1(sub2ind(size(feat_d(i+1).frame_cam_1),5*ones(matches1),matchfeat1(2,:))),datacam2next'];
            cam2only_next=cam2next(~find(cam2next));
        else
            ft_objs_next=feat_d(i+1).frame_cam_1(sub2ind(size(feat_d(i+1).frame_cam_1),5*ones(matches1),matchfeat1(2,:)));
        end
        matched_objs=[];
        matched2_objs=[];
        matching_objs=[];
        matching2_objs=[];
        if ~isempty(datacam2now)
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
        end
        if ~isempty(cam2only_now)
            matched2_objs=unique(cam2only_next);
            matching2_objs=zeros(1,numel(matched2_objs));
            for j=1:numel(matched2_objs)
                column=zeros(size(matched2_objs));
                for k=1:numel(column)
                    column(k)=sum(ismember(cam2only_next,matched2_objs(k)));
                end
                [~,matching2_objs(j)]=max(column);
            end
            [dup,freq]=mode(matching2_objs);
            while max(freq) > 1 && dup ~= 0
                matching2_objs(matching2_objs==dup)=0;
                [dup,freq]=mode(nonzeros(matching2_objs));
            end
        end
        if i==1
            if ~isempty(ft_objs_now)||~isempty(cam2only_now)
                objs=numel(nonzeros(matching_objs));
                objs2only=numel(nonzeros(matching2_objs));
                if num_tr_objs
                    trackedobj{i,1}=num_tr_objs+1:num_tr_objs+objs;
                    trackedobj{i,2}=nonzeros(matching_objs);
                    num_tr_objs=num_tr_objs+objs;
                end
                if objs2only
                    trackedobj{i,3}=num_tr_objs:num_tr_objs+objs2only;
                    trackedobj{i,4}=nonzeros(matching2_objs);
                    num_tr_objs=num_tr_objs+objs2only;
                end
            end
        else
            newobjs=setdiff(nonzeros(matching_objs),trackedobj{i,2});
            newobjs2=setdiff(nonzeros(matching2_objs),trackedobj{i,4});
            if ~isempty(newobjs)||~isempty(newobjs2)
                if ~isempty(newobjs)
                    trackedobj{i,1}=[trackedobj{i,1},num_tr_objs+1:(num_tr_objs+numel(newobjs))];
                    trackedobj{i,2}=[trackedobj{i,2},newobjs];
                    num_tr_objs=num_tr_objs+numel(newobjs);
                end
                if ~isempty(newobjs2)
                    trackedobj{i,3}=[trackedobj{i,3},num_tr_objs+1:(num_tr_objs+numel(newobjs2))];
                    trackedobj{i,4}=[trackedobj{i,4},newobjs2];
                    num_tr_objs=num_tr_objs+numel(newobjs2);
                end
            end
        end
        tr_obj_num=trackedobj{i,1};
        obj_in_frame=trackedobj{i,2};
        tr_obj2_num=trackedobj{i,3};
        obj_in_frame2=trackedobj{i,4};
        [aux2,aux1]=ismember(matching_objs,obj_in_frame);
        [aux4,aux3]=ismember(matching2_objs,obj_in_frame2);
        nobjs=ismember(matching_objs,0);
        nobjs2=ismember(matching2_objs,0);
        if ~sum(nobjs)
            trackedobj{i+1,1}=tr_obj_num(nonzeros(aux1));
            trackedobj{i+1,2}=matched_objs(aux2);
        end
        if ~sum(nobjs2)
            trackedobj{i+1,3}=tr_obj2_num(nonzeros(aux3));
            trackedobj{i+1,4}=matched2_objs(aux4);
        end
        if sum(nobjs)
            trackedobj{i+1,1}=[tr_obj_num(nonzeros(aux1)),num_tr_objs+1:num_tr_objs+sum(nobjs)];
            trackedobj{i+1,2}=[matched_objs(aux2),matched_objs(nobjs)];
            num_tr_objs=num_tr_objs+sum(nobjs);
        end
        if sum(nobjs2)
            trackedobj{i+1,3}=[tr_obj2_num(nonzeros(aux3)),num_tr_objs+1:num_tr_objs+sum(nobjs2)];
            trackedobj{i+1,4}=[matched2_objs(aux4),matched2_objs(nobjs2)];
            num_tr_objs=num_tr_objs+sum(nobjs2);
        end
    end
end
end