close all
%following will load PMMA raw spectrums then normalized

%get all PMMA files
files = dir('*.txt');

rawSpec = {};
normSpec = {};

for i=1:length(files)
    rawSpec{end+1} = dlmread(files(i).name);
    normSpec{end+1} = pmmanormalizer2(rawSpec{end});
end

figure

subplot(2,1,1)
for i=1:length(files)
    plot(rawSpec{i}(:,1),rawSpec{i}(:,2))
    hold on
end
xlabel('Wavenumber')
ylabel('Raw Intensity')
title('Raw PMMA Spectrum')


subplot(2,1,2)
for i=1:length(files)
    plot(normSpec{i}(:,1),normSpec{i}(:,2))
    hold on
end

xlabel('Wavenumber')
ylabel('Normalized Intensity')
title('PMMA Spectrum Normalized by Peak at 813 Wavenumber')

suptitle('TLR5KO PMMA')