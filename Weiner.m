Ioriginal = imread("76052f7902246ff862f52f5d3cd9cd_jumbo.jpg");
imshow(Ioriginal)
title('Original Image')

PSF = fspecial('motion',21,11);
Idouble = im2double(Ioriginal);
blurred = imfilter(Idouble,PSF,'conv','circular');
imshow(blurred)
title('Blurred Image')

wnr1 = deconvwnr(blurred,PSF);
imshow(wnr1)
title('Restored Blurred Image')

noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred,'gaussian',noise_mean,noise_var);
imshow(blurred_noisy)
title('Blurred and Noisy Image')

wnr2 = deconvwnr(blurred_noisy,PSF);
imshow(wnr2)
title('Restoration of Blurred Noisy Image (NSR = 0)')

signal_var = var(Idouble(:));
NSR = noise_var / signal_var;
wnr3 = deconvwnr(blurred_noisy,PSF,NSR);
imshow(wnr3)
title('Restoration of Blurred Noisy Image (Estimated NSR)')

peaksnr = psnr(Idouble,wnr3);
mse = immse(Idouble,wnr3);

fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The mean-squared error is %0.4f\n',mse);
