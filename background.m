function bg = background (file_name,n,x,y)
depth_cube=zeros(x,y,n);
r_cube=zeros(x,y,n);
g_cube=zeros(x,y,n);
b_cube=zeros(x,y,n);
for i=1:n
    depth_mat=load(file_name(i).depth);
    depth_cube(:,:,i)=depth_mat.depth_array;
    imgRGB=imread(file_name(i).rgb);
    r_cube(:,:,i)=imgRGB(:,:,1);
    g_cube(:,:,i)=imgRGB(:,:,2);
    b_cube(:,:,i)=imgRGB(:,:,3);
end
depth_back=zeros(x,y);
rgb_back=zeros(x,y,3);
for i=1:x
    for j=1:y
        depth_back(i,j)=median(depth_cube(i,j,:));
        rgb_back(i,j,1)=median(r_cube(i,j,:));
        rgb_back(i,j,2)=median(g_cube(i,j,:));
        rgb_back(i,j,3)=median(b_cube(i,j,:));
    end
end
bg = struct('rgb',rgb_back,'depth',depth_back);
end

