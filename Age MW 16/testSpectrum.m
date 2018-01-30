[rows, columns] = size(rawSpectrum);

rawSpectrumMat = cell2mat(rawSpectrum);

intensities = [];

for i = 2:2:2*columns
    intensities = [intensities rawSpectrumMat(:,i)];
    
end