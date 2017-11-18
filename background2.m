function bg = background2 (file_name,n,px)
depth_cube=zeros(px,n);
r_cube=zeros(px,n);
g_cube=zeros(px,n);
b_cube=zeros(px,n);
for i=1:n
    depth_mat=load(file_name(i).depth);
    depth_cube(:,i)=reshape(depth_mat.depth_array,[px 1]);
    imgRGB=imread(file_name(i).rgb);
    r_cube(:,i)=reshape(imgRGB(:,:,1),[px 1]);
    g_cube(:,i)=reshape(imgRGB(:,:,2),[px 1]);
    b_cube(:,i)=reshape(imgRGB(:,:,3),[px 1]);
end
depth_back=zeros(px,1);
rgb_back=zeros(px,3);
for i=1:px
    depth_back(i)=median(depth_cube(i,:));
    rgb_back(i,1)=median(r_cube(i,:));
    rgb_back(i,2)=median(g_cube(i,:));
    rgb_back(i,3)=median(b_cube(i,:));
end
bg = struct('rgb',rgb_back,'depth',depth_back);
end