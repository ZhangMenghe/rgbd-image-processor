[height, width, channels, imgNum] = size(images);
for i  = 1: imgNum
    imwrite(images(:,:,:,i), strcat('imgs/rgb/' , int2str(i) , '.png'))
end