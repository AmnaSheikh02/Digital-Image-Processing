
%% STEP-1
%% Image input
% We take a RGB image as input and convert it to grayscale and store it in another variable
% , so we can get the mean luminance (the intensity of light
% emitted from a surface per unit area in a given direction)
% (im2double) function is used for persesion by converting image from unit08
% into double format.
% (rgb2gray) is used to convert rgb into greyscale 

RGB_Image = imread('6.png');
RGB_Image = im2double(RGB_Image);
Gray_Image = rgb2gray(RGB_Image); 

%% STEP-2
%% White Balancing
% Extract the individual red, green, and blue color channels.
% (RGB_Image(:, :, 1)) function is used for extracting RGB channels
Red_Channel = RGB_Image(:, :, 1);
Green_Channel = RGB_Image(:, :, 2);
Blue_Channel = RGB_Image(:, :, 3);

%% STEP-3
%% Taking mean of R,G,B and Grey channel
% function (mean2) is used for (taking mean of an image)
mean_Red = mean2(Red_Channel);
mean_Green = mean2(Green_Channel);
mean_Blue = mean2(Blue_Channel);
mean_Gray = mean2(Gray_Image);

%% STEP-4
%% Make all channels have the same mean
% (double) function is used to clear any rounf-off errors

Red_Channel = (double(Red_Channel) * mean_Gray / mean_Red);
Green_Channel = (double(Green_Channel) * mean_Gray / mean_Green);
Blue_Channel = (double(Blue_Channel) * mean_Gray / mean_Blue);

%% STEP-5
%% Red_Channel and Blue_Channel Correction
% equation : Irc(x) = Ir(x) - ?.( ¯Ig ? ¯Ir) .Ig(x).(1 ? Ir(x))

% a = Constant peremeter = 0.3 , ¯Ig = mean of Ig , ¯Ir = mean of Ir
% Irc = compensated red channel

% equation : Ibc(x) = Ib(x) + ?.( ¯Ig ? ¯Ib) .Ig(x).(1 ? Ib(x))

% a = Constant peremeter , ¯Ig = mean of Ig , ¯Ib = mean of Ib
% Ibc = compensated blue channel


Red_Channel = Red_Channel-0.3*(mean_Green-mean_Red).*Green_Channel.*(1-Red_Channel);
Blue_Channel = Blue_Channel+0.3*(mean_Green-mean_Blue).*Green_Channel.*(1-Blue_Channel);

%% STEP-6
%% Recombine separate color channels into a single, true color RGB image.
% (cat) function is used to combine all r,g,b channels into one.
% (figure) function creates a new figure object using default property values.
% (subplot) function is used to plot image in frame
% (title) is used to give the name to figure object

RGB_and_white_balance = cat(3, Red_Channel, Green_Channel, Blue_Channel);

figure('Name','Color Enhancement       M. Mohasin (003) / Amna Shakeel (039)');
subplot(221);
imshow(Red_Channel);
title('Suppressed Red Channel');

subplot(222);
imshow(Blue_Channel);
title('Enhanced Blue Channel');

subplot(223);
imshow(Green_Channel);
title('Green Channel');

subplot(224);
imshow(RGB_and_white_balance);
title('After White balance');

%% Gamma Correction and Image Sharpening
%% Gamma Correction :
% (iamadjust ) function is to Adjust the contrast, specifying a gamma value
% of less than 1 (0.5). Notice that in the call to imadjust, the example 
% specifies the data ranges of the input and output images as empty matrices. 
% When you specify an empty matrix, imadjust uses the default range of [0,1]. 
% In the example, both ranges are left empty. This means that gamma correction
% is applied without any other adjustment of the data.

Gamma_Correction = imadjust(RGB_and_white_balance,[],[],0.5);

%% Image Sharpening using un sharp masking
% (imsharpen) function is used to sharpen the combined channel image

%J= imsharpen (RGB_and_white_balance);           

Image_Sharpening=(RGB_and_white_balance+(RGB_and_white_balance-imgaussfilt(RGB_and_white_balance)));
figure('Name','Step I-III      M. Mohasin (003) / Amna Shakeel (039)');
subplot(221);
imshow(RGB_Image);
title('Original Image');

subplot(222);
imshow(RGB_and_white_balance);
title('I. White Balance');

subplot(223);
imshow(Gamma_Correction);
title('II. Gamma Corrected');

subplot(224);
imshow(Image_Sharpening);
title('III. Sharpened');

%% Image Fusion using wavelet transform
% (wfusimg) funstion is used for fusion of images in wavelet form
Image_Fusion = wfusimg(Gamma_Correction,Image_Sharpening,'sym4',3,'max','max');

figure('Name','Final Comparison      M. Mohasin (003) / Amna Shakeel (039)');
subplot(121);
imshow(RGB_Image);
title('Original');

% (histeq) funstion is used to convert image from wavelength into graphical
% representation

subplot(122);
imshow((histeq(Image_Fusion)));
title('IV. Wavelet fusion');