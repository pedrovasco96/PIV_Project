function [R12,T,ptotal]=getfusedPC(pic1,xyz1,pic2,xyz2,x,y)
imshow(uint8(reshape(pic1,[x y 3])));
[u1,v1]=ginput(5);
imshow(uint8(reshape(pic2,[x y 3])));
[u2,v2]=ginput(5);
figure();
hold on;
plot(u1,v1,'.r');
plot(u2,v2,'.b');
hold off;
ind1=sub2ind([x y],uint64(v1),uint64(u1));
ind2=sub2ind([x y],uint64(v2),uint64(u2));
cent1=mean(xyz1(ind1,:))';
cent2=mean(xyz1(ind2,:))';
pc1=xyz1(ind1,:)'-repmat(cent1,1,5);
pc2=xyz2(ind2,:)'-repmat(cent2,1,5);
[a,~,c]=svd(pc2*pc1');
R12=a*c';
T=cent2-R12*cent1;
xyzt1=R12*(xyz1'-repmat(cent1,1,length(xyz1)));
xyzt2=xyz2'-repmat(cent2,1,length(xyz2));
ptotal=pointCloud([xyzt1';xyzt2'],'Color',[uint8(pic1);uint8(pic2)]);
end