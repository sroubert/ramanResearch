%The following script analyzes raman samples of bone centered at 1300
%utilizing the ramanAnalysisExternal & pmmanormalizer2 functions.

%%
%dealing with PMMA

%extract the .txt file of the PMMA sample you're working with in the
%region. Example: using the PMMA scan of region 1 for all the raman samples
%in that region.

%extract
PMMA = dlmread('Region 1_Copy.txt');

figure
plot(PMMA(:,1),PMMA(:,2));

%normalize
normPMMA = pmmanormalizer2(PMMA);
figure
plot(normPMMA(:,1),normPMMA(:,2));

%%
%analysis
rawSpec = dlmread('Scan 5_Copy.txt');
figure
plot(rawSpec(:,1),rawSpec(:,2));


sample1Region1 = ramanAnalysis6withindexeditET2017_updated_11_16_17(rawSpec,normPMMA);

