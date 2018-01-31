CamMatrix = getCameraParam('color');
depthImg = double(imread('imgs/depth.png')) ./ 1000;
[height,width] = size(depthImg);
rawDepth = imread('imgs/rawdepth.png');
missingMask = (rawDepth == 0);
[pc,N,yDir,h,pcRot,NRot] = processDepthImage(depthImg*100, missingMask, CamMatrix);

X = pc(:,:,1);
Y = h;
Z = pc(:,:,3);
X = X-min(X(:))+1;Z=Z-min(Z(:))+1;

roundX = round(X);roundZ=round(Z);
maxX = max(roundX(:));
maxZ = max(roundZ(:));

[mx,mz] = meshgrid(1:maxX+1, 1:maxZ+1);
heightMap = ones(maxZ+1, maxX+1) * inf;
for i = 1:height
    for j=1:width
        tx = roundX(i,j)+1;tz=roundZ(i,j)+1;
        heightMap(tz,tx) = min(h(i,j), heightMap(tz,tx));
    end
end
mesh(mx,mz,heightMap,'FaceAlpha',0.5)