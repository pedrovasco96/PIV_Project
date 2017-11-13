function objects = track3D_part1(imgseq1, imgseq2, cam_params, cam1toW, cam2toW)

	[~,n1] = size(imgseq1);
	[~,n2] = size(imgseq2);

	% Initialize matrix
	depth_cube_1=zeros(480,640,n1);
	r_cube_1=zeros(480,640,n1);
	g_cube_1=zeros(480,640,n1);
	b_cube_1=zeros(480,640,n1);
	depth_cube_2=zeros(480,640,n2);
	r_cube_2=zeros(480,640,n2);
	g_cube_2=zeros(480,640,n2);
	b_cube_2=zeros(480,640,n2);

	% Read information from .mat files and rgb images
	for i=1:n1
    	depth_mat_1=load(imgseq1(i).depth);
    	depth_cube_1(:,:,i)=depth_mat_1.depth_array;
    	imgRGB_1=imread(imgseq1(i).rgb);
    	r_cube_1(:,:,i)=imgRGB_1(:,:,1);
    	g_cube_1(:,:,i)=imgRGB_1(:,:,2);
    	b_cube_1(:,:,i)=imgRGB_1(:,:,3);
	end

	% Read information from .mat files and rgb images
	for i=1:n2
    	depth_mat_2=load(imgseq2(i).depth);
    	depth_cube_2(:,:,i)=depth_mat_2.depth_array;
    	imgRGB_2=imread(imgseq2(i).rgb);
    	r_cube_2(:,:,i)=imgRGB_2(:,:,1);
    	g_cube_2(:,:,i)=imgRGB_2(:,:,2);
    	b_cube_2(:,:,i)=imgRGB_2(:,:,3);
	end

	[x1,y1,~]=size(depth_cube_1);
	rbg_back_1=zeros(x1,y1,3);
	depth_back_1=zeros(x1,y1);

	[x2,y2,~]=size(depth_cube_2);
	rbg_back_2=zeros(x2,y2,3);
	depth_back_2=zeros(x2,y2);

	% Compute background
	for i=1:x1
    	for j=1:y1
        	depth_back_1(i,j)=median(depth_cube_1(i,j,:));
        	rbg_back_1(i,j,1)=median(r_cube_1(i,j,:));
        	rbg_back_1(i,j,2)=median(g_cube_1(i,j,:));
        	rbg_back_1(i,j,3)=median(b_cube_1(i,j,:));
    	end
	end

	% Compute background
	for i=1:x2
    	for j=1:y2
        	depth_back_2(i,j)=median(depth_cube_2(i,j,:));
        	rbg_back_2(i,j,1)=median(r_cube_2(i,j,:));
        	rbg_back_2(i,j,2)=median(g_cube_2(i,j,:));
        	rbg_back_2(i,j,3)=median(b_cube_2(i,j,:));
    	end
	end

	figure();
	imagesc(depth_back_1);
	colorbar;
	figure();
	imshow(uint8(rbg_back_1));

	figure();
	imagesc(depth_back_2);
	colorbar;
	figure();
	imshow(uint8(rbg_back_2));

	%objects(i).X = X;
	%objects(i).Y = Y;
	%objects(i).Z = Z;
	%objects(i).frames_tracked = frames_tracked;
    objects=0;
end

%run('Vlfeat/toolbox/vl_setup');