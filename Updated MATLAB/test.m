path = 'C:\Users\wchang\Desktop\VIP\Code\testOne\';%Insert folder path here
files = dir(strcat(path,'/*.png'));
for i=1:size(files)
    Image = imread(strcat(path, files(i).name));
    dim = size(Image);
    if(dim(1) ~= 496 || dim(2) ~= 496)
        if(class(Image) ~= uint8)
           disp(strcat('Wrong bit depth: ', files(i).name)); 
        end
      disp(files(i).name);  
    end
end