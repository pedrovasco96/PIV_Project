function bg = backgrounD (file_name,n,px,subfolder)
if n > 25
    a=linspace(1,n,25);
    a=fix(a);
else
    a=1:n;
end
sz=numel(a);
depth_cube=zeros(px,sz);
for i=1:sz
    depth_mat=load(strcat(subfolder,'/',file_name(a(i)).depth));
    depth_cube(:,i)=reshape(depth_mat.depth_array,[px 1]);
end
depth_back=zeros(px,1);
for i=1:px
    depth_back(i)=median(depth_cube(i,:));
end
bg = depth_back;
end