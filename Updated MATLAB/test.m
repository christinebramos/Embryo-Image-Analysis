path = 'C:\Users\wchang\Desktop\VIP\Code\testOne\'; %Insert folder path here

size = 496;
bitdepth = uint8;
files = dir(strcat(path,'/*.png'));
for i=1:size(files)
    Image = imread(strcat(path, files(i).name));
    dim = size(Image);
    if(dim(1) ~= size || dim(2) ~= size)
        if(class(Image) ~= bitdepth)
           disp(strcat('Wrong bit depth: ', files(i).name)); 
        end
      disp(strcat('Wrong size: ', files(i).name));  
    end
end