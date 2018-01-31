[height, width, imgNum] = size(labels);
for i  = 1: imgNum
    label = double(labels(:,:,i));
    minNum = min(label(:));
    maxNum = max(label(:));
    label = (label-minNum)/(maxNum-minNum);
    imwrite(label, strcat('imgs/labels/', int2str(i), '.png'))
end
