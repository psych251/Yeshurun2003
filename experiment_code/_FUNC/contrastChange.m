function outPutImage=contrastChange(inputImage,contrast)

% michelson contrast (in percentage)
minCol = ((1-contrast/100)/2)*255;
maxCol = 255-minCol;
outPutImage = ((inputImage-128).*(maxCol-minCol)/255)+128;

end
