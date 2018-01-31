%load('nyu_depth_v2_labeled.mat')
[height, width, imgNum] = size(depths);
C = cropCamera(getCameraParam('color'));

depths = double(depths);
rawDepths = double(rawDepths) * 100;

for i = 1:imgNum
    depthImg = depths(:,:,i);
    %maxNum = max(depthImg(:));
    %minNum = min(depthImg(:));
    %depthImg = (depthImg - minNum) / (maxNum-minNum);
    %imwrite(depthImg, strcat('imgs/depth-' , int2str(i) , '.png'))
    
    rdepthImg = rawDepths(:,:,i);
    %maxNum = max(rdepthImg(:));
    %minNum = min(rdepthImg(:));
    %rdepthImg = (rdepthImg - minNum) / (maxNum-minNum);
    %imwrite(rdepthImg, strcat('imgs/rawdepth-' , int2str(i) , '.png'))
    
    missingMask = (rdepthImg == 0);
    [pc, N, yDir, h, pcRot, NRot] = processDepthImage(depthImg*100, missingMask, C);
    angl = acosd(min(1,max(-1,sum(bsxfun(@times, N, reshape(yDir, 1, 1, 3)), 3))));
    % Making the minimum depth to be 100, to prevent large values for disparity!!!
    h = h-min(h(:));
    pc(:,:,3) = max(pc(:,:,3), 100); 
    I(:,:,1) = 31000./pc(:,:,3); 
    I(:,:,2) = h;
    I(:,:,3) = (angl+128-90); %Keeping some slack
    HHA = uint8(I);
    imwrite(HHA, strcat('imgs/hha/' , int2str(i) , '.png'))
    imwrite(HHA(:,:,2), strcat('imgs/height/' , int2str(i) , '.png'))

end