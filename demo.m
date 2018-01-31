C = cropCamera(getCameraParam('color'));
%C = getCameraParam('color');
D = imread('imgs/depth.png');

D = double(D)./1000;

[height,width] = size(D);

RD = imread('imgs/rawdepth.png');
missingMask = (RD == 0);
[pc, N, yDir, h, pcRot, NRot] = processDepthImage(D*100, missingMask, C);
angl = acosd(min(1,max(-1,sum(bsxfun(@times, N, reshape(yDir, 1, 1, 3)), 3))));
    
% Making the minimum depth to be 100, to prevent large values for disparity!!!
pc(:,:,3) = max(pc(:,:,3), 100);
I(:,:,1) = 31000./pc(:,:,3); 
I(:,:,2) = h;
I(:,:,3) = (angl+128-90); %Keeping some slack
HHA = uint8(I);

imwrite(HHA(:,:,2), 'imgs/height.png')

%%%
figure()
subplot(221)
imshow(HHA(:,:,1))
title('Disparity')
subplot(222)
imshow(HHA(:,:,2))
title('Height')
subplot(223)
imshow(HHA(:,:,3))
title('Angle')