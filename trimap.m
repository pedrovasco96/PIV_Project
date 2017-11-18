function [xyz,p]=trimap(depth_array,rgb,K,H,W)
Kx = K(1,1);
Cx = K(1,3);
Ky = K(2,2);
Cy = K(2,3);
u = repmat(1:W,H,1);
u = u(:)-Cx;
v = repmat((1:H)',W,1);
v=v(:)-Cy;
xyz=zeros(length(u),3);
xyz(:,3) = double(depth_array)*0.001;
xyz(:,1) = (xyz(:,3)/Kx) .* u ;
xyz(:,2) = (xyz(:,3)/Ky) .* v;
figure();
p = pointCloud(xyz,'color',uint8(rgb));
end