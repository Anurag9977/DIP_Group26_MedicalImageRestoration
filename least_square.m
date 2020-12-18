I = im2double(imread('c184e15a2985b98baa512ffc85a38f23.jpg'));
imshow(I);
title('Original Image');

PSF = fspecial('gaussian',11,5);
blurred = imfilter(I,PSF,'conv');
noise_mean = 0;
noise_var = 0.02;
blurred_noisy = imnoise(blurred,'gaussian',noise_mean,noise_var);
imshow(blurred_noisy)
title('Blurred and Noisy Image')

NP = noise_var*numel(I);
[reg1,lagra] = deconvreg(blurred_noisy,PSF,NP);
imshow(reg1)
title('Restored with True NP')

reg2 = deconvreg(blurred_noisy,PSF,NP*1.3);
imshow(reg2)
title('Restored with Larger NP')

reg3 = deconvreg(blurred_noisy,PSF,NP/1.3);
imshow(reg3)
title('Restored with Smaller NP')

Edged = edgetaper(blurred_noisy,PSF);
reg4 = deconvreg(Edged,PSF,NP/1.3);
imshow(reg4)
title('Restored with Smaller NP and Edge Tapering')

reg5 = deconvreg(Edged,PSF,[],lagra);
imshow(reg5)
title('Restored with LAGRA')

reg6 = deconvreg(Edged,PSF,[],lagra*100);
imshow(reg6)
title('Restored with Large LAGRA')

reg7 = deconvreg(Edged,PSF,[],lagra/100);
imshow(reg7)
title('Restored with Small LAGRA')

c=imresize(reg7,[size(I,1) size(I,2)]);
d=imresize(reg4,[size(I,1) size(I,2)]);

peaksnr = psnr(I,reg4);
mse = immse(I,reg4);
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The mean-squared error is %0.4f\n',mse);