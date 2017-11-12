D=dir('*.mat');
RGB=dir('*.jpg');
[n,~]=size(D);
for i=1:n
    file_name(i)=struct('rgb',RGB(i).name,'depth',D(i).name);
    depth_mat=load(file_name(i).depth);
    depth_cube(:,:,i)=depth_mat.depth_array;
    imgRGB=imread(file_name(i).rgb);
    r_cube(:,:,i)=imgRGB(:,:,1);
    g_cube(:,:,i)=imgRGB(:,:,2);
    b_cube(:,:,i)=imgRGB(:,:,3);
end
[x,y,~]=size(depth_cube);
for i=1:x
    for j=1:y
        depth_back(i,j)=median(depth_cube(i,j,:));
        rbg_back(i,j,1)=median(r_cube(i,j,:));
        rbg_back(i,j,2)=median(g_cube(i,j,:));
        rbg_back(i,j,3)=median(b_cube(i,j,:));
    end
end
imagesc(depth_back);
imshow(rbg_back);
