%Modify lines 2-7 as desired
isImage = 1; %0 for labels, 1 for original images
isGray = 1; %0 if not grayscale images (LABELS), 1 for grayscale images
startFrameNumber = 3702; %how many frames before the frame you start renaming
w = startFrameNumber;
degrees = 0; %degrees
widthlength = 496; %size of the resized image
mirror = 0; %mirror over x axis = 1; mirror over y axis = 2; no mirror = 0
combine = 0; %combines two images to create two new different images
crop = 1;
originalpath = 'C:\Users\Joel\Desktop\SPRING 2020\EE 496\Neural Network Training (Human)\imagesCombinedResized\';
newpath = 'C:\Users\Joel\Desktop\SPRING 2020\EE 496\Neural Network Training (Human)\Augmented_imagesCombinedResized\';

type = 'Labels';
if(isImage == 1)
    type = 'Images';
end
files = dir(strcat(originalpath,'/*.png'));
if(degrees == 0 && mirror == 0)
    N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength));
elseif(mirror ~= 0)
    if(mirror == 1)
        N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength), ', Rotated_', num2str(degrees), ', MirrorX');
    else
        N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength), ', Rotated_', num2str(degrees), ', MirrorY');
    end
else
    N = strcat(newpath, type, ', ', num2str(widthlength), 'x', num2str(widthlength), ',Rotated_', num2str(degrees));
end

if (crop == 1)
    N = strcat(N, ', crop');
end

if (combine == 1)
    N = strcat(N, ', combine');
end

mkdir(N);
for k = 1:length(files)
    lengthFile = length(files);
    Image = imread(strcat(originalpath, files(k).name));
    if(isImage == 1 && isGray == 0)
       Image = rgb2gray(Image); 
    end
    if(degrees ~= 0)
        Image = imrotate(Image, degrees);
        if(isImage == 0)
            Image = label2rgb(Image);
            [r, c, ~] = size(Image);
            val1 = Image(1,1,1);
            val2 = Image(1,1,2);
            val3 = Image(1,1,3);
            for p = 1:r
                for l = 1:c
                    if(Image(p,l,1) == val1 && Image(p,l,2) == val2 && Image(p,l,3) == val3)
                        Image(p,l,1) = 0;
                        Image(p,l,2) = 0;
                        Image(p,l,3) = 255;
                    end
                end
            end
            [Image, map] = rgb2ind(Image, 2);
        end
    end
    if(mirror ~= 0)
        if(mirror == 1)
            Image = flipud(Image);
        else
            Image = flip(Image,2);
        end
    end
    if(crop ~= 0 || combine ~= 0)
            sizeImage = size(Image);
            totalpixels_x = sizeImage(2);
            totalpixels_y = sizeImage(1);
            segment_x = totalpixels_x/2;
            segment_y = totalpixels_y/2;
        if(crop == 1 && combine == 0)
            I1 = Image(1:segment_y, 1:segment_x);
            I1 = imresize(I1,[widthlength, widthlength]);
            I2 = Image(1:segment_y, segment_x+1:2*segment_x);
            I2 = imresize(I2,[widthlength, widthlength]);
            I3 = Image(segment_y+1:2*segment_y, 1:segment_x);
            I3 = imresize(I3,[widthlength, widthlength]);
            I4 = Image(segment_y+1:2*segment_y, segment_x+1:2*segment_x);
            I4 = imresize(I4,[widthlength, widthlength]);
            filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
            imwrite(I1, filename);
            w = w + 1;
            filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
            imwrite(I2, filename);
            w = w + 1;
            filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
            imwrite(I3, filename);
            w = w + 1;
            filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
            imwrite(I4, filename);
        end
        if(crop == 0 && combine == 1)
            nextImage = imread(strcat(originalpath, files(lengthFile).name));
            if(lengthFile ~= k)
                I1(1:totalpixels_y,1:segment_x) = Image(1:totalpixels_y,1:segment_x);
                I1(1:totalpixels_y,segment_x+1:2*segment_x) = nextImage(1:totalpixels_y,segment_x+1:2*segment_x);
                I2(1:totalpixels_y,1:segment_x) = nextImage(1:totalpixels_y,1:segment_x);
                I2(1:totalpixels_y,segment_x+1:2*segment_x) = Image(1:totalpixels_y,segment_x+1:2*segment_x);
            end
            lengthFile = lengthFile - 1;
            filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
            imwrite(I1, filename);
            w = w + 1;
            filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
            imwrite(I2, filename);
       end
    end
    Image = imresize(Image, [widthlength widthlength]); %change size of image (x,y)
    if(combine == 0 && crop == 0)
        filename=strcat(N, '/', num2str(k + startFrameNumber),'.png');
        imwrite(Image, filename);
    end
end