function [x,y,imgseq1,imgseq2]=dir2struct(d_f_d,rgb_f_d,subfolder)
[~,Dformat]=strtok(d_f_d,'.');
[~,RGBformat]=strtok(rgb_f_d,'.');
D=dir(strcat(subfolder,'/*',Dformat));
RGB=dir(strcat(subfolder,'/*',RGBformat));
[n,~]=size(D);
sz=n/2;
sample=load(strcat(subfolder,'/',D(1).name));
[x,y]=size(sample.depth_array);
imgseq1= struct('rgb',cell(sz,1),'depth',cell(sz,1));
imgseq2= struct('rgb',cell(sz,1),'depth',cell(sz,1));
for i=1:n
    set=sscanf(D(i).name,d_f_d);
    if set(1) == 1
        imgseq1(set(2)).rgb = RGB(i).name;
        imgseq1(set(2)).depth = D(i).name;
    else
        imgseq2(set(2)).rgb = RGB(i).name;
        imgseq2(set(2)).depth = D(i).name;
    end
end
end
