I = imread('ctofbrainsh594606644_1341028-860x550.jpg');

figure;
imshow(I);
title('Original Image');

PSF = fspecial('gaussian',5,5);
Blurred = imfilter(I,PSF,'symmetric','conv');
figure;
imshow(Blurred);
title('Blurred');

V = .002;
BlurredNoisy = imnoise(Blurred,'gaussian',0,V);
figure;
imshow(BlurredNoisy);
title('Blurred & Noisy');

luc1 = deconvlucy(BlurredNoisy,PSF,5);
figure;
imshow(luc1);
title('Restored Image, NUMIT = 5');

luc1_cell = deconvlucy({BlurredNoisy},PSF,5);
luc2_cell = deconvlucy(luc1_cell,PSF);
luc2 = im2uint8(luc2_cell{2});
figure;
imshow(luc2);
title('Restored Image, NUMIT = 15');

DAMPAR = im2uint8(3*sqrt(V));
luc3 = deconvlucy(BlurredNoisy,PSF,15,DAMPAR);
figure;
imshow(luc3);
title('Restored Image with Damping, NUMIT = 15');


peaksnr = psnr(I,luc3);
mse = immse(I,luc3);
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The mean-squared error is %0.4f\n',mse);