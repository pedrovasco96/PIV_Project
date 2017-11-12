D=dir('*.mat');
RGB=dir('*.jpg');
[n,~]=size(c);
for i=1:n
    file_name(i)=struct('rgb',RGB(i).name,'depth',D(i).name);
end
